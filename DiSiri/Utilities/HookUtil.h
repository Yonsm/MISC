
#import <dlfcn.h>
#import <objc/runtime.h>

#define _HOOK_METHOD(RET, CLS, MSG, CLASS, ...)	RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__);\
												RET (*_##CLS##_##MSG)(id self, SEL sel, ##__VA_ARGS__);\
												void __attribute__((constructor)) _Init_##CLS##_##MSG() {_HookMessage(CLASS, #MSG, $##CLS##_##MSG, (void **)&_##CLS##_##MSG);}\
												RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__)
#define HOOK_CLASS(RET, CLS, MSG, ...)			_HOOK_METHOD(RET, CLS, MSG, objc_getMetaClass(#CLS), ##__VA_ARGS__)
#define HOOK_INSTANCE(RET, CLS, MSG, ...)		_HOOK_METHOD(RET, CLS, MSG, objc_getClass(#CLS), ##__VA_ARGS__)

#define HOOK_FUNCTION(RET, LIB, FUN, ...)		RET $##FUN(__VA_ARGS__);\
												RET (*_##FUN)(##__VA_ARGS__);\
												void __attribute__((constructor)) _Init_##FUN() {_HookFunction(#LIB, #FUN, $##FUN, (void **)&_##FUN);}\
												RET $##FUN(__VA_ARGS__)


//
//extern "C"
void _HookFunction(const char *lib, const char *fun, void *hook, void **old);

//
//extern "C"
void _HookMessage(Class cls, const char *msg, void *hook, void **old);
