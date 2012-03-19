//
//  UrlHelper.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
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
    
    NSRange range = [baseUrl rangeOfString:@"?"];
    NSString *joinChar = (range.location == NSNotFound)? @"?" : @"&";
    NSString *query = [UrlHelper encodeUrlParameters:params];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", baseUrl, joinChar, query]];
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

@end
