
#import <dlfcn.h>
#import <objc/runtime.h>

#define _HOOK_PASTE(A, B)						A##B
#define _HOOK_CONCAT(A, B)						_HOOK_PASTE(A, B)
#define _HOOK_UNIQUE							_HOOK_CONCAT(_HOOK_, __LINE__)
#define _HOOK_UNIQUE1(S)						_HOOK_CONCAT(_HOOK_UNIQUE, S)

#define _HOOK_METHOD(RET, CLS, MSG, CLASS, ...)	RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__);\
												typedef RET (*_HOOK_UNIQUE)(id self, SEL sel, ##__VA_ARGS__);\
												_HOOK_UNIQUE _##CLS##_##MSG;\
												void __attribute__((constructor)) _HOOK_UNIQUE1(_INIT)() {_##CLS##_##MSG = (_HOOK_UNIQUE)_HookMessage(CLASS, #MSG, $##CLS##_##MSG);}\
												RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__)
#define HOOK_CLASS(RET, CLS, MSG, ...)			_HOOK_METHOD(RET, CLS, MSG, objc_getMetaClass(#CLS), ##__VA_ARGS__)
#define HOOK_INSTANCE(RET, CLS, MSG, ...)		_HOOK_METHOD(RET, CLS, MSG, objc_getClass(#CLS), ##__VA_ARGS__)

#define HOOK_FUNCTION


//
//extern "C"
void *_HookFunction(void *symbol, void *hook);

//
//extern "C"
void *_HookMessage(Class cls, const char *msg, void *hook);
