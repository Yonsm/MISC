
#import <dlfcn.h>
#import <objc/runtime.h>


#define _HOOK_FUNCTION(MOD, RET, LIB, FUN, ...)			RET $##FUN(__VA_ARGS__);\
														RET (*_##FUN)(##__VA_ARGS__);\
														void MOD _Init_##FUN() {_HookFunction(#LIB, #FUN, (void *)$##FUN, (void **)&_##FUN);}\
														RET $##FUN(__VA_ARGS__)

#define _HOOK_MESSAGE(MOD, RET, CLS, MSG, META, ...)	RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__);\
														RET (*_##CLS##_##MSG)(id self, SEL sel, ##__VA_ARGS__);\
														void MOD _Init_##CLS##_##MSG() {_HookMessage(objc_get##META##Class(#CLS), #MSG, (void *)$##CLS##_##MSG, (void **)&_##CLS##_##MSG);}\
														RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__)

#define HOOK_FUNCTION(RET, LIB, FUN, ...)				_HOOK_FUNCTION(inline, RET, LIB, FUN, __VA_ARGS__)
#define HOOK_MESSAGE(RET, CLS, MSG, ...)				_HOOK_MESSAGE(inline, RET, CLS, MSG, , ##__VA_ARGS__)
#define HOOK_META_MESSAGE(RET, CLS, MSG, ...)			_HOOK_MESSAGE(inline, RET, CLS, MSG, Meta, ##__VA_ARGS__)

#define AUTOHOOK_FUNCTION(RET, LIB, FUN, ...)			_HOOK_FUNCTION(__attribute__((constructor)), RET, LIB, FUN, __VA_ARGS__)
#define AUTOHOOK_MESSAGE(RET, CLS, MSG, ...)			_HOOK_MESSAGE(__attribute__((constructor)), RET, CLS, MSG, , ##__VA_ARGS__)
#define AUTOHOOK_META_MESSAGE(RET, CLS, MSG, ...)		_HOOK_MESSAGE(__attribute__((constructor)), RET, CLS, MSG, Meta, ##__VA_ARGS__)

//
#ifdef __cplusplus
extern "C"
#endif
void _HookFunction(const char *lib, const char *fun, void *hook, void **old);

//
#ifdef __cplusplus
extern "C"
#endif
void _HookMessage(Class cls, const char *msg, void *hook, void **old);
