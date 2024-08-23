// SPDX-License-Identifier: GPL-2.0
#include <linux/init.h>
#include <linux/module.h>
#include <linux/utsname.h>
#include <linux/timekeeping.h>

static char *whom = "world";
module_param(whom, charp, 0644);
MODULE_PARM_DESC(whom, "Recipient of the hello message.");

static time64_t start;

static int __init hello_init(void)
{
	start = ktime_get_seconds();
	pr_info("Hello %s. You are currently using Linux %s\n", whom, utsname()->release);

	return 0;
}

static void __exit hello_exit(void)
{
	time64_t duration = ktime_get_seconds() - start;
	pr_info("Bye, lonesome world. I was alived for a mere %d seconds.\n", (int)duration);
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
