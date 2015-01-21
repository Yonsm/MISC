
#import "LiteralParser.h"

//
int main(int argc, char * argv[])
{
	puts("Literal Parser 1.0.1\n"
		 "Copyleft(L) 2014, Yonsm.NET, No Rights Reserved.\n");

#if DEBUG
	const char *p = "@{@\"StrType\":@\"bbbb\", @\"BOOLType\":@YES, @\"doubleType\":@1234.567,@YES:@[],@NO:@{@\"A\":@YES,@1:@[@2]}}";
#else
	if (argc < 2)
	{
		puts("USAGE: Literal @[NSString|NSNumber|NSArray|NSDictionary Literals]\n\n"
			 "EXAMPLE: Literal \"@{@\\\"StrType\\\":@\\\"bbbb\\\", @\\\"BOOLType\\\":@YES, @\\\"doubleType\\\":@1234.567,@YES:@[],@\\\"Dict\\\":@{@\\\"A\\\":@YES,@\\\"Array\\\":@[@1,@\\\"XX\\\"]}}\"\n");
		return EXIT_FAILURE;
	}
	const char *p = argv[1];
#endif

	LiteralParser parser;
	id obj = parser.ParseLiterals(p);
	if (obj == nil)
	{
		printf("Syntax Error: %s\n", p);
		return EXIT_FAILURE;
	}

	printf("%s: %s\n", [[obj className] UTF8String], [[obj description] UTF8String]);
	return EXIT_SUCCESS;
}
