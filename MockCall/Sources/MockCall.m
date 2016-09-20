

// Upload the request data and response data to the mock server.
void uploadDataToMockServer(NSString *rpcName, NSString *requestString, NSData *responseData)
{
	NSString *requestUrl, *responseUrl;
	{
		NSString *mockPrefix = mockConfigUrl;
		const char *mockString = mockConfigUrl.UTF8String;
		const char *p = strrchr(mockString, '/');
		if (p) mockPrefix = [mockConfigUrl substringToIndex:p + 1 - mockString];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		formatter.dateFormat = @"yyyyMMdd-HHmmss";
		NSString *dateString = [formatter stringFromDate:[NSDate date]];
		requestUrl = [mockPrefix stringByAppendingFormat:@"uploads/%@_%@.request.txt", dateString, rpcName];
		responseUrl = [mockPrefix stringByAppendingFormat:@"uploads/%@_%@.txt", dateString, rpcName];
		_Log(@"Mocks: requestUrl - %@", requestUrl);
	}
	{
		NSMutableURLRequest *requestREQ = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
		[requestREQ setHTTPMethod:@"PUT"];
		[requestREQ setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
		[requestREQ setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
		[NSURLConnection sendAsynchronousRequest:requestREQ queue:nil completionHandler:nil];
	}
	{
		NSMutableURLRequest *requestRES = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:responseUrl]];
		[requestRES setHTTPMethod:@"PUT"];
		[requestRES setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
		[requestRES setHTTPBody:responseData];
		[NSURLConnection sendAsynchronousRequest:requestRES queue:nil completionHandler:nil];
	}
}

//
NSString * configMockDataUrl(NSString *url)
{
	NSString *mockUrl = url;
	if ([url rangeOfString:@":"].location == NSNotFound)
	{
		NSString *mockPrefix = mockConfigUrl;
		const char *mockString = mockConfigUrl.UTF8String;
		_Log(@"Mocks: mockString - *-->%s", mockString);

		if ([url hasPrefix:@"/"])
		{
			for (const char *p = mockString; *p; p++)
			{
				if (*p == ':')
				{
					do {p++;} while (*p == '/');
					p = strchr(p, '/');
					if (p) mockPrefix = [mockConfigUrl substringToIndex:p - mockString];
					break;
				}
			}
		}
		else
		{
			const char *p = strrchr(mockString, '/');
			if (p) mockPrefix = [mockConfigUrl substringToIndex:p + 1 - mockString];
		}
		mockUrl = [mockPrefix stringByAppendingString:url];
	}

	_Log(@"Mocks: mock url - %@", mockUrl);
	return mockUrl;
}


BOOL readMockConfig()
{
	if (configDict)
		return YES;

	mockConfigUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"MockConfigUrl"];
	if (mockConfigUrl.length == 0)
		return NO;

	_Log(@"Mocks: Setting MockConfigUrl - %@", mockConfigUrl);
	NSHTTPURLResponse *response;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:mockConfigUrl]];
	[request setTimeoutInterval:2.0];
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	if (response.statusCode != 200)
		return NO;

	configDict = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : nil;
	if (configDict.count == 0)
	{
		configDict = @{@"*":@"*"};
	}
	return YES;
}


//
HOOK_MESSAGE(void, DTRpcOperation, didFinish)
{
	if (!readMockConfig())
		return _DTRpcOperation_didFinish(self, sel);

    NSString *requestString = nil;//[[self httpBodyParameters] description];
	NSString *rpc = nil;//[self httpBodyParameters][@"operationType"];
	_Log(@"Mocks: req - %@", requestString);

	// 调整“*”的位置到最后一个
	NSArray *keyArray = configDict.allKeys;
	if ([keyArray containsObject:@"*"] && ![keyArray.lastObject isEqualToString:@"*"])
	{
		keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			NSString *string1 = (NSString *)obj1;
			return [string1 isEqualToString:@"*"] ? NSOrderedDescending : NSOrderedAscending;
		}];
	}

	//
	for (NSString *aKey in keyArray)
	{
		NSString *key = [aKey isEqualToString:@"*"] ? rpc : aKey;
		NSString *url = configDict[aKey];
		_Log(@"Mocks: akey=%@  key=%@ url=%@", aKey, key, url);

		if ([requestString rangeOfString:key].location != NSNotFound)
		{
			if (url.length == 0 || [url isEqualToString:@"*"])
			{
				url = [rpc stringByAppendingPathExtension:@"txt"];
				_Log(@"Mocks: mock url - *-->%@", url);
			}

			url = configMockDataUrl(url);

			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
			[request setTimeoutInterval:3.0];

			NSHTTPURLResponse *response;
			NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
			_Log(@"Mocks: response.statusCode = %d, data = %@", (int)response.statusCode, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
			if (response.statusCode == 200)
			{
				_Log(@"Mocks: mock data is valid");
				//[[NSClassFromString(@"DTURLCache") sharedCache] removeAllCachedResponses];
				//[self setResponseData:data];
			}
			else
			{
				// 从url取Data为nil，则将原始的请求和响应数据写入服务器中
				_Log(@"Mocks: mock data is nil");
				//uploadDataToMockServer(rpc, requestString, [self responseData]);
			}
			break;
		}
	}

	//_Log(@"Mocks: Response - %@", [self responseString]);

	_DTRpcOperation_didFinish(self, sel);
}

