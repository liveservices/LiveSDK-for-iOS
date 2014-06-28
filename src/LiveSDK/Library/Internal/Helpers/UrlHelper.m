//
//  UrlHelper.m
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
#import "StringHelper.h"

@implementation UrlHelper

+ (NSString *) encodeUrlParameters: (NSDictionary *)params
{
    NSMutableArray *entrylist = [NSMutableArray array];
    
    for (NSString* key in params.keyEnumerator) 
    {
        id value = [params valueForKey:key];
        id kvStr = [NSString stringWithFormat:@"%@=%@", key, 
                    [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [entrylist addObject: kvStr];
    }
    
    return [entrylist componentsJoinedByString:@"&"];
}

+ (NSDictionary *) decodeUrlParameters: (NSString *)paramStr
{
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSArray *kvStrs = [paramStr componentsSeparatedByString: @"&"];
    for (NSString *kvStr in kvStrs) 
    {
        NSArray *kv = [kvStr componentsSeparatedByString: @"="];
        
        [params setObject:[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
                   forKey:[kv objectAtIndex:0]];
    }
    
    return params;
}

+ (NSURL *)constructUrl:(NSString *)baseUrl
                 params:(NSDictionary *)params
{
    if (params.count <= 0) 
    {
        return [NSURL URLWithString:baseUrl];
    }
    
    NSString *query = [UrlHelper encodeUrlParameters:params];
    
    return [NSURL URLWithString:[UrlHelper appendQueryString:query toPath:baseUrl]];
}

+ (NSDictionary *)parseUrl:(NSURL *)url 
{    
    NSString *query = [url query];
    
    return [UrlHelper decodeUrlParameters: query];
}

+ (BOOL) isFullUrl:(NSString *)url
{
    if ([StringHelper isNullOrEmpty:url])
    {
        return NO;
    }
    
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSRange httpRange = [url rangeOfString:@"http:"];
    if (httpRange.location == 0) 
    {
        return YES;
    }
    
    NSRange httpsRange = [url rangeOfString:@"https:"];
    if (httpsRange.location == 0)
    {
        return YES;
    }
    
    return NO;
}

+ (NSString *) getQueryString: (NSString *)path
{
    return [[NSURL URLWithString:path] query];
}

+ (NSString *) appendQueryString: (NSString *)query toPath: (NSString *)path
{
    if ([StringHelper isNullOrEmpty:query])
    {
        return path;
    }
    
    if ([path rangeOfString:query].location != NSNotFound)
    {
        // The path already contains the query.
        return path;
    }
    
    NSRange range = [path rangeOfString:@"?"];
    NSString *joinChar = (range.location == NSNotFound)? @"?" : @"&";
    
    return [NSString stringWithFormat:@"%@%@%@", path, joinChar, query];
}

@end
