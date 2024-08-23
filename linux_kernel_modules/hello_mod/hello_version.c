// SPDX-License-Identifier: GPL-2.0
#include <linux/init.h>
#include <linux/module.h>
#include <linux/utsname.h>

static int __init hello_init(void)
{
	pr_info("Hello World. You are currently using Linux %s\n", utsname()->release);
	return 0;
}

static void __exit hello_exit(void)
{
	pr_info("Bye, lonesome world.\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
