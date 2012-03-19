//
//  StringHelperTests.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import "StringHelperTests.h"
#import "StringHelper.h"

@implementation StringHelperTests

// All code under test must be linked into the Unit Test bundle
- (void)testNullOfEmpty
{
    STAssertTrue([StringHelper isNullOrEmpty:nil], @"nil input should returns true.");
    STAssertTrue([StringHelper isNullOrEmpty:@" "], @"empty string input should returns true.");    
    
    STAssertTrue([StringHelper isNullOrEmpty:@""], @"Whitespace input should returns true.");
    
    STAssertFalse([StringHelper isNullOrEmpty:@" bal "], @"Definitely not empty string.");
}

@end
