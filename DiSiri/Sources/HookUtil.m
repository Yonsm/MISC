
#import "HookUtil.h"

//
void *_HookFunction(void *symbol, void *hook)
{
	static void (*_MSHookFunction)(void *symbol, void *hook, void **old) = NULL;
	if (_MSHookFunction == NULL)
	{
		void *lib = dlopen("/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY);
		if (lib)
		{
			_MSHookFunction = dlsym(lib, "MSHookFunction");
		}
	}

	void *old = NULL;
	if (_MSHookFunction)
	{
		_MSHookFunction(symbol, hook, &old);
	}
	return NULL;
}

//
void *_HookMessage(Class cls, const char *msg, void *hook)
{
	static void (*_MSHookMessageEx)(Class cls, SEL sel, void *hook, void **old) = NULL;
	if (_MSHookMessageEx == nil)
	{
		void *lib = dlopen("/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY);
		if (lib)
		{
			_MSHookMessageEx = dlsym(lib, "MSHookMessageEx");
		}
	}

	void *old = NULL;
	SEL sel = sel_registerName(msg);//NSSelectorFromString([@"" stringByReplacingOccurrencesOfString:@"_" withString:@":"]);
	if (_MSHookMessageEx)
	{
		_MSHookMessageEx(cls, sel, hook, &old);
	}
	else
	{
		old = method_setImplementation(class_getInstanceMethod(cls, sel), hook);
	}
	return old;
}
