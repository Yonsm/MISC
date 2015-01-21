
#import <dlfcn.h>
#include <mach/mach.h>
#include <libkern/OSCacheControl.h>

//
NS_INLINE uint8_t *ModuleBase(NSString *path, NSString *refFunc, unsigned long refAddr = 0x1000)
{
	unsigned char *base = (unsigned char *)dlsym(dlopen(path.UTF8String, RTLD_LAZY), refFunc.UTF8String);
	if (base == nil)
	{
		_Log(@"HOOK Base symbol not found");
		return nil;
	}
	
	if (((unsigned long)base & 0x0FF0) != (refAddr & 0x0FF0))
	{
		_Log(@"HOOK Base symbol miss match: %p !=! %lX", base, refAddr);
		return nil;
	}
	
	base -= refAddr;
	_Log(@"HOOK Base: %@ at %p", path, base);
	return base;
}

//
extern "C" kern_return_t mach_vm_region
(
 vm_map_t target_task,
 vm_address_t *address,
 vm_size_t *size,
 vm_region_flavor_t flavor,
 vm_region_info_t info,
 mach_msg_type_number_t *infoCnt,
 mach_port_t *object_name
 );

//
template <typename TYPE> NS_INLINE bool FakeCode(TYPE *addr, TYPE code)
{
	mach_port_t task;
	vm_size_t region_size = 0;
	vm_address_t region = (vm_address_t)addr;

	/* Get region boundaries */
#if defined(_MAC64) || defined(__LP64__)
	vm_region_basic_info_data_64_t info;
	mach_msg_type_number_t info_count = VM_REGION_BASIC_INFO_COUNT_64;
	vm_region_flavor_t flavor = VM_REGION_BASIC_INFO_64;
	if (mach_vm_region(mach_task_self(), &region, &region_size, flavor, (vm_region_info_t)&info, (mach_msg_type_number_t*)&info_count, (mach_port_t*)&task) != KERN_SUCCESS)
	{
		return false;
	}
#else
	vm_region_basic_info_data_t info;
	mach_msg_type_number_t info_count = VM_REGION_BASIC_INFO_COUNT;
	vm_region_flavor_t flavor = VM_REGION_BASIC_INFO;
	if (vm_region(mach_task_self(), &region, &region_size, flavor, (vm_region_info_t)&info, (mach_msg_type_number_t*)&info_count, (mach_port_t*)&task) != KERN_SUCCESS)
	{
		return false;
	}
#endif
	
	/* Change memory protections to rw- */
	if (vm_protect(mach_task_self(), region, region_size, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY) != KERN_SUCCESS)
	{
		return false;
	}
	
	/* Actually perform the write */
	*addr = code;
	
	/* Flush CPU data cache to save write to RAM */
	sys_dcache_flush(addr, sizeof(code));
	
	/* Invalidate instruction cache to make the CPU read patched instructions from RAM */
	sys_icache_invalidate(addr, sizeof(code));
	
	/* Change memory protections back to r-x */
	vm_protect(mach_task_self(), region, region_size, false, VM_PROT_EXECUTE | VM_PROT_READ);
	return true;
}
