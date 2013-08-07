//
//  UrlHelperTests.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "UrlHelper.h"
#import "UrlHelperTests.h"

@implementation UrlHelperTests

- (void) testUrlParameterEncoding
{
    NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value 1", @"key1", @"value 2", @"key2", nil ];
    STAssertEqualObjects(@"key2=value%202&key1=value%201", [UrlHelper encodeUrlParameters:params], @"Encoding incorrectly");
}

- (void) testUrlParameterDecoding
{
    NSDictionary *params = [UrlHelper decodeUrlParameters:@"key2=value%202&key1=value%201"];
    STAssertEqualObjects(@"value 1", [params valueForKey:@"key1"] , @"Url decoded incorrectly for key1");
    STAssertEqualObjects(@"value 2", [params valueForKey:@"key2"] , @"Url decoded incorrectly for key1");
}

- (void) testConstructUrl_noParameter
{
    NSURL *url = [UrlHelper constructUrl:@"http://apis.live.net/v5.0/obj001"
                                  params:nil];
    
    STAssertEqualObjects(@"http://apis.live.net/v5.0/obj001", url.absoluteString, @"Construct Url incorrrectly");
}

- (void) testConstructUrl_WithParameters
{    
    NSURL *url = [UrlHelper constructUrl:@"http://apis.live.net/v5.0/obj001"
                                  params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"value 1", @"key1", @"value 2", @"key2", nil ]];
    
    STAssertEqualObjects(@"http://apis.live.net/v5.0/obj001?key2=value%202&key1=value%201", url.absoluteString, @"Construct Url incorrrectly");
}

- (void) testConstructUrl_WithParamsAndParams
{
    NSURL *url = [UrlHelper constructUrl:@"http://apis.live.net/v5.0/obj001?key3=V3"
                                  params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"value 1", @"key1", @"value 2", @"key2", nil ]];
    
    STAssertEqualObjects(@"http://apis.live.net/v5.0/obj001?key3=V3&key2=value%202&key1=value%201", url.absoluteString, @"Construct Url incorrrectly");
}

- (void) testParseUrl
{
    NSDictionary *params = [UrlHelper parseUrl:[NSURL URLWithString:@"http://apis.live.net/v5.0/obj001?key3=V3&key2=value%202&key1=value%201"]];
    STAssertEqualObjects(@"value 1", [params valueForKey:@"key1"] , @"Url decoded incorrectly for key1");
    STAssertEqualObjects(@"value 2", [params valueForKey:@"key2"] , @"Url decoded incorrectly for key1");
    
    STAssertEqualObjects(@"V3", [params valueForKey:@"key3"] , @"Url decoded incorrectly for key1");
}

- (void) testIsFullUrl
{
    STAssertTrue([UrlHelper isFullUrl:@"http://foo.com/"] , @"String begining with http: or https: should be considered as full Url");
    STAssertTrue([UrlHelper isFullUrl:@"https://foo.com/"] , @"String begining with http: or https: should be considered as full Url");
    STAssertTrue([UrlHelper isFullUrl:@" http://foo.com/ "] , @"Adding spaces to a full Url, it is still a full url");
    STAssertTrue([UrlHelper isFullUrl:@" https://foo.com/ "] , @"Adding spaces to a full Url, it is still a full url");
    STAssertFalse([UrlHelper isFullUrl:@"me"] , @"");
    STAssertFalse([UrlHelper isFullUrl:@"/me"] , @"");
    STAssertFalse([UrlHelper isFullUrl:@" /me/ "] , @"");
    STAssertFalse([UrlHelper isFullUrl:@" me "] , @"");
}

- (void) testGetQueryString_FullPath
{
    STAssertEqualObjects(@"a=b",[UrlHelper getQueryString:@"https://apis.live.net/v5.0/me/skydrive/?a=b"] , @"Incorrect query string value.");
}

- (void) testGetQueryString_RelativePath
{
    STAssertEqualObjects(@"a=b",[UrlHelper getQueryString:@"/me/skydrive/?a=b"] , @"Incorrect query string value.");
}

- (void) testGetQueryString_NoQuery
{
    STAssertEqualObjects(@"", [UrlHelper getQueryString:@"/me/skydrive/?"] , @"Incorrect query value.");
    STAssertNil([UrlHelper getQueryString:@"https://apis.live.net/v5.0/me/skydrive/"] , @"Incorrect query value.");
    STAssertNil([UrlHelper getQueryString:@"/me/skydrive/"] , @"Incorrect query value.");
}

- (void) testAppendQueryString_AppendQuery
{
    STAssertEqualObjects(@"https://apis.live.net/v5.0/me/skydrive/?a=b",[UrlHelper appendQueryString:@"a=b" toPath:@"https://apis.live.net/v5.0/me/skydrive/"] , @"The path was appended incorrectly.");
    
    STAssertEqualObjects(@"/me/skydrive/?a=b",[UrlHelper appendQueryString:@"a=b" toPath:@"/me/skydrive/"] , @"The path was appended incorrectly.");
}

- (void) testAppendQueryString_MergeQuery
{
    STAssertEqualObjects(@"https://apis.live.net/v5.0/me/skydrive/?a=b",[UrlHelper appendQueryString:@"a=b" toPath:@"https://apis.live.net/v5.0/me/skydrive/"] , @"The path was appended incorrectly.");
    
    STAssertEqualObjects(@"/me/skydrive/?a=b&c=d",[UrlHelper appendQueryString:@"c=d" toPath:@"/me/skydrive/?a=b"] , @"The path was appended incorrectly.");
}

- (void) testAppendQueryString_AppendNullOrEmpty
{
    STAssertEqualObjects(@"https://apis.live.net/v5.0/me",[UrlHelper appendQueryString:@"" toPath:@"https://apis.live.net/v5.0/me"] , @"The path was appended incorrectly.");
    STAssertEqualObjects(@"https://apis.live.net/v5.0/me",[UrlHelper appendQueryString:nil toPath:@"https://apis.live.net/v5.0/me"] , @"The path was appended incorrectly.");
}

- (void) testAppendQueryString_AlreadyAppended
{
    STAssertEqualObjects(@"https://apis.live.net/v5.0/me?a=b",[UrlHelper appendQueryString:@"a=b" toPath:@"https://apis.live.net/v5.0/me?a=b"] , @"The path was appended incorrectly.");
}
@end
