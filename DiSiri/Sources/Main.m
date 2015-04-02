

//
#if 0
HOOK_INSTANCE(BOOL, SBAssistantController, uiPluginWantsActivation_forEvent_completion_, id arg1, int arg2, id arg3)
{
	_LogStack();

	NSLog(@"SBAssistantController__presentForMainScreenAnimated_completion:%@, %d, %@", arg1, arg2, arg3);

	if (arg2 == 1)
	{
		//
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disable Siri" message:@"Disable Siri!! Do something here." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alertView show];
		return NO;
	}

	return _SBAssistantController_uiPluginWantsActivation_forEvent_completion_(self, sel, arg1, arg2, arg3);
}
#endif


HOOK_INSTANCE(void, SBAssistantController, uiPluginWantsActivation_forEvent_completion_, id arg1, int arg2, id arg3)
{
	return _SBAssistantController_uiPluginWantsActivation_forEvent_completion_(self, sel, arg1, arg2, arg3);
}

int main()
{
	return 0;
}
