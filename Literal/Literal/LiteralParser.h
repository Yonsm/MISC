
#import <Foundation/Foundation.h>

//#import <stdlib.h>
//#import <stdio.h>
//#import <string.h>

//
// http://joris.kluivers.nl/blog/2012/03/13/new-objectivec-literal-syntax/
class LiteralParser
{
public:
	//
	inline id ParseLiterals(const char *&p)
	{
		return p ? ParseObject(p) : nil;
	}

private:
	id ParseObject(const char *&p)
	{
		while (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n') p++;

		if (*p != '@')
			return nil;

		//
		do p++;
		while (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n');

		if (*p == '{')
		{
			return ParseDictionary(p);
		}
		else if (*p == '[')
		{
			return ParseArray(p);
		}
		else if (*p == '"')
		{
			return ParseString(p);
		}
		else if (*p == '\'')
		{
			return ParseChar(p);
		}
		else
		{
			return ParseNumber(p);
		}
	}

	//
	NSDictionary *ParseDictionary(const char *&p)
	{
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		for (p++; id key = ParseObject(p); p++)
		{
			while (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n') p++;
			if (*p != ':')
				return nil;

			id obj = ParseObject(++p);
			if (obj == NULL)
				return nil;

			dict[key] = obj;
			while (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n') p++;
			if (*p == '}')
			{
				p++;
				return dict;
			}
			else if (*p != ',')
			{
				return nil;
			}
		}
		if (dict.count == 0 && *p == '}')
		{
			p++;
			return dict;
		}
		return nil;
	}

	//
	NSArray *ParseArray(const char *&p)
	{
		NSMutableArray *array = [NSMutableArray array];
		for (p++; id obj = ParseObject(p); p++)
		{
			[array addObject:obj];

			while (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n') p++;
			if (*p == ']')
			{
				p++;
				return array;
			}
			else if (*p != ',')
			{
				return nil;
			}
		}
		if (array.count == 0 && *p == ']')
		{
			p++;
			return array;
		}
		return nil;
	}

	//
	NSString *ParseString(const char *&p)
	{
		// TODO: Escape string ...
		for (const char *s = ++p; *p; p++)
		{
			if (*p == '"')
			{
				CFStringRef string = CFStringCreateWithBytes(NULL, (const UInt8 *)s, (CFIndex)(p - s), kCFStringEncodingUTF8, NO);
				p++;
				return CFBridgingRelease(string);
			}
		}
		return nil;
	}

	//
	NSNumber *ParseChar(const char *&p)
	{
		// TODO: Escape char '\xFF'...
		char c = p[1];
		p += 3;
		return [NSNumber numberWithChar:c];
	}

	//
	NSNumber *ParseNumber(const char *&p)
	{
		if (!memcmp(p, "YES", 3))
		{
			p += 3;
			return [NSNumber numberWithBool:YES];
		}
		else if (!memcmp(p, "NO", 2))
		{
			p += 2;
			return [NSNumber numberWithBool:NO];
		}

		BOOL dot = NO;
		for (const char *s = p; TRUE; p++)
		{
			if (*p == '.')
			{
				dot = YES;
			}
			else if (*p < '0' || *p > '9')
			{
				if (*p == 'f')
				{
					p++;
					return [NSNumber numberWithFloat:atof(s)];
				}
				else if (*p == 'u')
				{
					p++;
					return [NSNumber numberWithUnsignedInt:atoi(s)];
				}
				else if (dot)
				{
					return [NSNumber numberWithDouble:atof(s)];
				}
				else if (p > s)
				{
					return [NSNumber numberWithInt:atoi(s)];
				}
				return nil;
			}
		}
	}
};
