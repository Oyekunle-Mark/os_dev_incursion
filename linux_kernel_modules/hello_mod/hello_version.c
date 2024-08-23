// SPDX-License-Identifier: GPL-2.0
#include <linux/init.h>
#include <linux/module.h>
#include <linux/utsname.h>

static char *whom = "world";
module_param(whom, charp, 0644);
MODULE_PARM_DESC(whom, "Recipient of the hello message.");

static int __init hello_init(void)
{
	pr_info("Hello %s. You are currently using Linux %s\n", whom, utsname()->release);
	return 0;
}

static void __exit hello_exit(void)
{
	pr_info("Bye, lonesome world.\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
