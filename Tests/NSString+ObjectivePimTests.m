//
//  NSString+ObjectivePimTests.m
//  ObjectivePim
//
//  Created by Víctor Berga on 13/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+ObjectivePim.h"

@interface NSString_ObjectivePimTests : XCTestCase

@end

@implementation NSString_ObjectivePimTests

- (void)testIsKeyPath
{
    NSString *target = nil;
    
    target = @"foo";
    XCTAssertFalse(target.isKeyPath);
    
    target = @"foo.bar";
    XCTAssertTrue(target.isKeyPath);
    
    target = @"foo-bar";
    XCTAssertFalse(target.isKeyPath);
    
    target = @"foo.bar-foo";
    XCTAssertTrue(target.isKeyPath);
}

- (void)testRootKey
{
    NSDictionary *fixture = @{@"foo.bar": @"foo",
                              @"foo" : NSNull.null,
                              @"foo.bar.other" : @"foo"};
    for (NSString *key in fixture) {
        NSString *root = [key rootKey];
        XCTAssertEqualObjects(root, fixture[key]);
    }
}

@end
