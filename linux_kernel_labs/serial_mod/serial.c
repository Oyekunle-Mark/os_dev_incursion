// SPDX-License-Identifier: GPL-2.0
#include <linux/init.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/of.h>
#include <uapi/linux/serial_reg.h>
#include <linux/pm_runtime.h>
#include <linux/io.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <linux/interrupt.h>

// ioctl operations
#define SERIAL_RESET_COUNTER 0
#define SERIAL_GET_COUNTER 1

struct serial_dev {
	void __iomem *regs;
	struct miscdevice miscdev;
	unsigned int counter;
};

static u32 reg_read(struct serial_dev *serial, unsigned int reg)
{
	return readl(serial->regs + (reg * 4));
}

static void reg_write(struct serial_dev *serial, u32 val, unsigned int reg)
{
	writel(val, serial->regs + (reg * 4));
}

static void serial_write_char(struct serial_dev *serial, unsigned char c)
{
	while((reg_read(serial, UART_LSR) & UART_LSR_THRE) == 0)
		cpu_relax();

	reg_write(serial, c, UART_TX);
}

static ssize_t serial_write(struct file *file, const char __user *buf, size_t sz, loff_t *ppos)
{
	struct miscdevice *miscdev_ptr = file->private_data;
	struct serial_dev *serial = container_of(miscdev_ptr, struct serial_dev, miscdev);

	for (int i = 0; i < sz; i++) {
		unsigned char c;
		get_user(c, buf + i);

		serial_write_char(serial, c);
		serial->counter++; // increment char count

		// add additional carriage return writes for new lines
		if (c == '\n')
			serial_write_char(serial, '\r');
	}

	*ppos += sz;
	return sz;
}

static ssize_t serial_read(struct file *file, char __user *buf, size_t sz, loff_t *ppos)
{
	return -EINVAL;
}

static long serial_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	struct miscdevice *miscdev_ptr = file->private_data;
	struct serial_dev *serial = container_of(miscdev_ptr, struct serial_dev, miscdev);

	switch(cmd) {
	case SERIAL_RESET_COUNTER:
		serial->counter = 0;
		break;
	case SERIAL_GET_COUNTER:
		put_user(serial->counter, (unsigned int __user *)arg);
		break;
	default:
		return -ENOTTY;
	}

	return 0;
}

static const struct file_operations serial_fops = {
	.owner = THIS_MODULE, // tell the kernel our module is in charge of this serial device to get reference count of usage
	.write = serial_write,
	.read = serial_read,
	.unlocked_ioctl = serial_ioctl,
};

static irqreturn_t serial_handler(int irq, void *dev_id)
{
	pr_info("%s called.\n", __func__);
	return IRQ_HANDLED;
}

static int serial_probe(struct platform_device *pdev)
{
	int ret;
	struct serial_dev *serial = devm_kzalloc(&pdev->dev, sizeof(*serial), GFP_KERNEL);
	if (!serial)
		return -ENOMEM;
	serial->regs = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(serial->regs))
		return PTR_ERR(serial->regs);

	pm_runtime_enable(&pdev->dev);
	pm_runtime_get_sync(&pdev->dev);

	unsigned int baud_divisor, uartclk;
	/* Configure the baud rate to 115200 */
	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &uartclk);
	if (ret) {
		dev_err(&pdev->dev,
			"clock-frequency property not found in Device Tree\n");
		return ret;
	}

	baud_divisor = uartclk / 16 / 115200;
	reg_write(serial, 0x07, UART_OMAP_MDR1);
	reg_write(serial, 0x00, UART_LCR); reg_write(serial, UART_LCR_DLAB, UART_LCR);
	reg_write(serial, baud_divisor & 0xff, UART_DLL);
	reg_write(serial, (baud_divisor >> 8) & 0xff, UART_DLM);
	reg_write(serial, UART_LCR_WLEN8, UART_LCR);
	reg_write(serial, 0x00, UART_OMAP_MDR1);
	/* Clear UART FIFOs */
	reg_write(serial, UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT, UART_FCR);

	// get irq number from device tree and register interrupt handler
	int irq = platform_get_irq(pdev, 0);
	ret = devm_request_irq(&pdev->dev, irq, serial_handler, 0, pdev->name, serial);
	// enable interrupts
	reg_write(serial, UART_IER_RDI, UART_IER);

	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!res) {
		ret = -EINVAL;
		goto disable_runtime_pm;
	}

	/* Declare misc device */
	serial->miscdev.minor = MISC_DYNAMIC_MINOR;
	serial->miscdev.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
					      "serial-%x", res->start);
	serial->miscdev.fops = &serial_fops;
	serial->miscdev.parent = &pdev->dev;

	/* Setup pointer from physical to per device data */
	platform_set_drvdata(pdev, serial);

	/* Everything is ready, register the misc device */
	ret = misc_register(&serial->miscdev);
	if (ret) {
		dev_err(&pdev->dev, "Cannot register misc device (%d)\n", ret);
		goto disable_runtime_pm;
	}

	pr_info("Called %s\n", __func__);

	return 0;
disable_runtime_pm:
	pm_runtime_disable(&pdev->dev);

	return ret;
}

static int serial_remove(struct platform_device *pdev)
{
	struct serial_dev *serial = platform_get_drvdata(pdev);
	misc_deregister(&serial->miscdev);

	pm_runtime_disable(&pdev->dev);

	pr_info("Called %s\n", __func__);
	return 0;
}

static const struct of_device_id serial_of_match[] = {
	{ .compatible = "bootlin,serial" },
	{ },
};
MODULE_DEVICE_TABLE(of, serial_of_match);

static struct platform_driver serial_driver = {
        .driver = {
                .name = "serial",
                .owner = THIS_MODULE,
				.of_match_table = of_match_ptr(serial_of_match),
        },
        .probe = serial_probe,
        .remove = serial_remove,
};
module_platform_driver(serial_driver);

MODULE_LICENSE("GPL");
