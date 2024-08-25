// SPDX-License-Identifier: GPL-2.0
#include <linux/init.h>
#include <linux/module.h>
#include <linux/i2c.h>
#include <linux/delay.h>
#include <linux/input.h>

static char buffer[6] = {0};
struct nunchuk_dev {
	struct i2c_client *i2c_client;
};

static void nunchuk_read_registers(struct i2c_client *client)
{
	usleep_range(10000, 20000);
	const unsigned char trig[] = {0x00};
	i2c_master_send(client, trig, 1);

	usleep_range(10000, 20000);
	int r = i2c_master_recv(client, buffer, 6);

	if (r != 6) {
		pr_alert("Did not receive up to 6 bytes.\n");
	}
}

static void nunchuk_poll(struct input_dev *input)
{
	struct nunchuk_dev *nunchuk = input_get_drvdata(input);
	struct i2c_client *client = nunchuk->i2c_client;
	nunchuk_read_registers(client);

	const char last_byte = buffer[5];
	int zpressed = (last_byte & (0b00000001)) ? 0 : 1; // button Z is bit 0(lsb). 0 is pressed, 1 is release
	int cpressed = ((last_byte >> 1) & (0b0000001)) ? 0 : 1; // button C is bit 1(from lsb). 0 is pressed, 1 is release

	input_report_key(input, BTN_Z, zpressed);
	input_report_key(input, BTN_C, cpressed);
	input_sync(input);
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

	struct nunchuk_dev *nunchuk = devm_kzalloc(&client->dev, sizeof(*nunchuk), GFP_KERNEL);

	if (!nunchuk)
		return -ENOMEM;

	nunchuk->i2c_client = client;
	i2c_set_clientdata(client, nunchuk);

	struct input_dev *input = devm_input_allocate_device(&client->dev);
	input->name = "Wii Nunchuk";
	input->id.bustype = BUS_I2C;
	input_set_drvdata(input, nunchuk);

	set_bit(EV_KEY, input->evbit);
	set_bit(BTN_C, input->keybit);
	set_bit(BTN_Z, input->keybit);

	int poll_ret = input_setup_polling(input, nunchuk_poll);

	if (poll_ret) {
		pr_alert("Failed to setup polling.\n");
		return poll_ret;
	}

	input_set_poll_interval(input, 50);

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

static const struct i2c_device_id nunchuk_id[] = {
	{"nunchuk", 0},
	{ },
};

MODULE_DEVICE_TABLE(i2c, nunchuk_id);

static struct i2c_driver nunchuk_i2c_driver = {
	.driver = {
		.name = "nunchuk_i2c",
		.of_match_table = nunchuk_of_match,
	},
	.probe = nunchuk_probe,
	.remove = nunchuk_remove,
	.id_table = nunchuk_id,
};

module_i2c_driver(nunchuk_i2c_driver);

MODULE_LICENSE("GPL");
