// SPDX-License-Identifier: GPL-2.0
#include <linux/init.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/of.h>
#include <uapi/linux/serial_reg.h>
#include <linux/pm_runtime.h>
#include <linux/io.h>

struct serial_dev {
	void __iomem *regs;
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

static int serial_probe(struct platform_device *pdev)
{
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
	int ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &uartclk);
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

	// write a test string
	serial_write_char(serial, '>');
	serial_write_char(serial, ' ');
	serial_write_char(serial, 'H');
	serial_write_char(serial, 'e');
	serial_write_char(serial, 'l');
	serial_write_char(serial, 'l');
	serial_write_char(serial, 'o');
	serial_write_char(serial, ' ');
	serial_write_char(serial, 's');
	serial_write_char(serial, 'e');
	serial_write_char(serial, 'r');
	serial_write_char(serial, 'i');
	serial_write_char(serial, 'a');
	serial_write_char(serial, 'l');
	serial_write_char(serial, '!');

	pr_info("Called %s\n", __func__);

	return 0;
}

static int serial_remove(struct platform_device *pdev)
{
	pr_info("Called %s\n", __func__);
	pm_runtime_disable(&pdev->dev);

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
