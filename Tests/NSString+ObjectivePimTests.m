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
    NSString *keyPath;
    
    keyPath = @"foo.bar";
    XCTAssertEqualObjects(keyPath.rootKey, @"foo");
    
    keyPath = @"foo";
    XCTAssertNil(keyPath.rootKey);
    
    keyPath = @"foo.bar.other";
    XCTAssertEqualObjects(keyPath.rootKey, @"foo");
}

- (void)testRelativeKeyPath
{
    NSString *keyPath;
    
    keyPath = @"one.two.three";
    XCTAssertEqualObjects(keyPath.relativeKeyPath, @"two.three");
    
    keyPath = @"one";
    XCTAssertNil(keyPath.relativeKeyPath);
    
    keyPath = @"one.two";
    XCTAssertEqualObjects(keyPath.relativeKeyPath, @"two");
}

@end
