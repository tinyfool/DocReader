//
//  NSString+UrlEncode.m
//  testlib
//
//  Created by hao peiqiang on 11-1-12.
//  Copyright 2011 http://tiny4.org. All rights reserved.
//

#import "NSString+UrlEncode.h"


@implementation NSString (TinyUrlEncode)

- (NSString *)stringWithUrlEncode {

	CFStringRef tempString = CFURLCreateStringByAddingPercentEscapes(
											NULL,
											(__bridge CFStringRef)self,
											NULL,
											(CFStringRef)@"!*'();:@&=+$,?%#[]",
											kCFStringEncodingUTF8 );
	
	NSString * encodedString = [NSString stringWithString:(__bridge NSString*)tempString];
	CFRelease(tempString);
	return encodedString;
}

@end
