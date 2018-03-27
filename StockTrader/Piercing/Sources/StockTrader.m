
//
#import "HookUtil.h"
#import "HTTPServer.h"
#import "StockTrader.h"

//
tztStockBuySellViewNew *_view = nil;

NSData *StockTrade(NSMutableDictionary *dict)
{
	if (!dict[@"StockCode"] || !dict[@"Price"] || !dict[@"Volume"] || !dict[@"WTAccount"] || !dict[@"WTAccountType"])
		return [@"USAGE: http://xxx.xxx.x.x/?StockCode=xxxxxx&Price=xx.xx&Volume=xxx&WTAccount=AXXXXXXXXX&WTAccountType=SHACCOUNT" dataUsingEncoding:NSUTF8StringEncoding];

	if (!dict[@"CommBatchEntrustInfo"])
		dict[@"CommBatchEntrustInfo"] = @"1";
	if (!dict[@"Direction"])
		dict[@"Direction"] = @"B";
	if (!dict[@"PriceType"])
		dict[@"PriceType"] = @"0";
	if (!dict[@"Reqno"])
	{
		Class tztNewReqno = NSClassFromString(@"tztNewReqno");
		NSString *string = [tztNewReqno key:(long long)_view reqno:[_view ntztReqNo]];
		id reqno = [tztNewReqno reqnoWithString:string];
		NSString *data = [NSString stringWithFormat:@"%lld+%@", [_view nMsgType], dict[@"StockCode"]];
		[reqno setPageData:data];
		NSString *rn = [reqno getReqnoValue];
		dict[@"Reqno"] = rn;
	}

	Class tztMoblieStockComm = NSClassFromString(@"tztMoblieStockComm");
	unsigned long long ret = [[tztMoblieStockComm getShareInstance] onSendDataAction:@"110" withDictValue:dict];
	dict[@"RETURN"] = @(ret);
	return [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
}

//
HOOK_MESSAGE(void, tztStockTradeViewController, viewDidAppear_, BOOL animated)
{
	_tztStockTradeViewController_viewDidAppear_(self, sel, animated);
	
	UIView *contentView = [[self view] subviews][0];
	for (UIView *view in contentView.subviews)
	{
		if ([NSStringFromClass(view.class) isEqualToString:@"tztStockBuySellViewNew"])
		{
			static HTTPServer *_httpServer = nil;
			if (_httpServer == nil)
			{
				_httpServer = [[HTTPServer alloc] init];
				[_httpServer start:80];
			}
			_view = (id)view;
			break;
		}
	}
}

//
#if 0

//
HOOK_MESSAGE(unsigned long long, tztMoblieStockComm, onSendDataAction_withDictValue_/*bShowProcess_*/, NSString *arg1, id dict/*, BOOL arg3*/)
{
	NSLog(@"tztMoblieStockComm_onSendDataAction_withDictValue: arg1=%@, arg2=%@"/*, arg3=%d"*/, arg1, dict/*, arg3*/);
	if ([arg1 isEqualToString:@"110"])
	{
		//
		_LogLine();
		//return 0;
	}
	unsigned long long ret = _tztMoblieStockComm_onSendDataAction_withDictValue_/*bShowProcess_*/(self, sel, arg1, dict/*, arg3*/);
	//NSLog(@"tztMoblieStockComm_onSendDataAction_withDictValue: ret=%lld, dict=%@", ret, dict);
	return ret;
}

//
HOOK_MESSAGE(void, tztStockBuySellViewNew, OnSendBuySell)
{
	_tztStockBuySellViewNew_OnSendBuySell(self, sel);
	//StockTrade(@"600588", @"30.00", @"100");
}

HOOK_META(id, tztNewReqno, key_reqno_, long long key, int reqno)
{
	id ret = _tztNewReqno_key_reqno_(self, sel, key, reqno);
	NSLog(@"tztNewReqno_key_reqno_: key=%lld, reqno=%d, ret=%@", key, reqno, ret);
	return ret;
}

//
HOOK_META(id, tztNewReqno, reqnoWithString_, id arg)
{
	id ret = _tztNewReqno_reqnoWithString_(self, sel, arg);
	NSLog(@"tztNewReqno_reqnoWithString_: arg=%@, ret=%@", arg, ret);
	return ret;
}

//
HOOK_MESSAGE(void, tztNewReqno, setPageData_, id arg)
{
	NSLog(@"tztNewReqno_setPageData_: arg=%@", arg);
	_tztNewReqno_setPageData_(self, sel, arg);
}
#endif

