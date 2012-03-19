//
//  StringHelper.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

+ (BOOL) isNullOrEmpty: (NSString *) value {
    
    if ([value length] == 0) 
    { 
        // nil or empty
        return YES;
    } 
    else if ([[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) 
    {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

@end
