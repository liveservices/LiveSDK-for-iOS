//
//  UrlHelperTests.m
//  Live SDK for iOS
//
//  Copyright 2014 Microsoft Corporation
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "UrlHelper.h"
#import "UrlHelperTests.h"

@implementation UrlHelperTests

- (void) testUrlParameterEncoding
{
    NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value 1", @"key1", @"value 2", @"key2", nil ];
    STAssertEqualObjects(@"key1=value%201&key2=value%202", [UrlHelper encodeUrlParameters:params], @"Encoding incorrectly");
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
    
    STAssertEqualObjects(@"http://apis.live.net/v5.0/obj001?key1=value%201&key2=value%202", url.absoluteString, @"Construct Url incorrrectly");
}

- (void) testConstructUrl_WithParamsAndParams
{
    NSURL *url = [UrlHelper constructUrl:@"http://apis.live.net/v5.0/obj001?key3=V3"
                                  params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"value 1", @"key1", @"value 2", @"key2", nil ]];
    
    STAssertEqualObjects(@"http://apis.live.net/v5.0/obj001?key3=V3&key1=value%201&key2=value%202", url.absoluteString, @"Construct Url incorrrectly");
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
