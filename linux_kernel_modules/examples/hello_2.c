#include <linux/init.h>
#include <linux/module.h>
#include <linux/printk.h>

MODULE_LICENSE("GPL"); 
MODULE_AUTHOR("LKMPG"); 
MODULE_DESCRIPTION("A sample driver");

static int hello_2_data __initdata = 3;

static int __init hello_2_init(void)
{
	pr_info("Hello, world %d\n", hello_2_data);

	return 0;
}

static void __exit hello_2_exit(void)
{
	pr_info("Goodbye,world 2\n");
}

module_init(hello_2_init);
module_exit(hello_2_exit);

MODULE_LICENSE("GPL");

