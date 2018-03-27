
//
#import "HookUtil.h"

//
int $ptrace(int request, pid_t pid, caddr_t addr, int data)
//_HOOK_FUNCTION(int, /usr/lib/libSystem.B.dylib, ptrace, int request, pid_t pid, caddr_t addr, int data)
{
	return 0;
}

//
_HOOK_FUNCTION(void *, /usr/lib/libSystem.B.dylib, dlsym, void *handle, const char *symbol)
{
	if (strcmp(symbol, "ptrace") == 0)
	{
		_LogLine();
		return (void *)&$ptrace;
	}

	return _dlsym(handle, symbol);
}

//
__attribute__((constructor)) int main()
{
	_LogLine();
	_Init_dlsym();
	return 0;
}

//
#if 0
HOOK_MESSAGE(id, NSBundle, bundleIdentifier)
{
	Dl_info info = {0};
	dladdr(__builtin_return_address(0), &info);
	const char *Youkui4Phone = "Youkui4Phone";
	size_t len = strlen(info.dli_fname);
	const char *p = info.dli_fname + len - strlen(Youkui4Phone);
	if (strcmp(p, Youkui4Phone) == 0)
	{
		//NSLog(@"%s", info.dli_fname);
		return @"com.youku.YouKu";
	}

	return _NSBundle_bundleIdentifier(self, sel);
}
#endif

//HOOK_MESSAGE(id, NSDictionary, objectForKeyedSubscript_, NSString *key)
//{
//	id ret = _NSDictionary_objectForKeyedSubscript_(self, sel, key);
//	if ([key isKindOfClass:NSString.class] && [key isEqualToString:@"CFBundleIdentifier"])
//	{
//		_LogObj(key);
//		return @"com.youku.YouKu";
//	}
//	return ret;
//}

