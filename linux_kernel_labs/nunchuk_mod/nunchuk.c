// SPDX-License-Identifier: GPL-2.0
#include <linux/init.h>
#include <linux/module.h>
#include <linux/i2c.h>
#include <linux/delay.h>
#include <linux/input.h>

static char buffer[6] = {0};

static void nunchuk_read_registers(struct i2c_client *client)
{
	usleep_range(10000, 20000);
	const unsigned char trig[] = {0x00};
	i2c_master_send(client, trig, 1);

	usleep_range(10000, 20000);
	int r = i2c_master_recv(client, buffer, 6);

	pr_info("Read %d bytes from call to i2c_master_recv.\n", r);
}

static int nunchuk_probe(struct i2c_client *client)
{
	const unsigned char first[] = {0xf0, 0x55};
	const unsigned char second[] = {0xfb, 0x00};

	int r = i2c_master_send(client, first, 2);
	udelay(1000);
	int s_r = i2c_master_send(client, second, 2);

	// the number of transmitted bytes is returned by i2c_master_send.
	// A negative number is returned on failure
	// Assert that both bytes were sent in both cases
	if(r != 2 || s_r != 2) { 
		pr_alert("Failed to communicate on probe.\n");
		return 1;
	}

	nunchuk_read_registers(client);	
	nunchuk_read_registers(client);	

	const char last_byte = buffer[5];
	int zpressed = last_byte & (0b00000001); // button Z is bit 0(lsb). 0 is pressed, 1 is release
	int cpressed = (last_byte >> 1) & (0b0000001); // button C is bit 1(from lsb). 0 is pressed, 1 is release

	pr_info("Z pressed: %d\n", zpressed);
	pr_info("C pressed: %d\n", cpressed);

	struct input_dev *input = devm_input_allocate_device(&client->dev);
	input->name = "Wii Nunchuk";
	input->id.bustype = BUS_I2C;

	set_bit(EV_KEY, input->evbit);
	set_bit(BTN_C, input->keybit);
	set_bit(BTN_Z, input->keybit);

	int ret = input_register_device(input);

	if (ret) {
		pr_alert("Failed to register input device.\n");
		return ret;
	}

	return 0;
}

static void nunchuk_remove(struct i2c_client *client)
{
	pr_info("Device is being removed...\n");
}

static const struct of_device_id nunchuk_of_match[] = {
	{ .compatible = "nintendo,nunchuk"},
	{ },
};

MODULE_DEVICE_TABLE(of, nunchuk_of_match);

static struct i2c_driver nunchuk_i2c_driver = {
	.driver = {
		.name = "nunchuk_i2c",
		.of_match_table = nunchuk_of_match,
	},
	.probe = nunchuk_probe,
	.remove = nunchuk_remove,
};

module_i2c_driver(nunchuk_i2c_driver);

MODULE_LICENSE("GPL");
