//
//  ObjectivePimTests.m
//  ObjectivePimTests
//
//  Created by Víctor on 17/04/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPContainer.h"

@interface Foo : NSObject

@property NSString *bar;

@end


@implementation Foo


@end

@interface ObjectivePimTests : XCTestCase

@property OPContainer *pim;

@end

@implementation ObjectivePimTests

- (void)setUp
{
    [super setUp];

    self.pim = OPContainer.new;
}

- (void)tearDown
{
    self.pim = nil;
    
    [super tearDown];
}

- (void)testWithString
{
    self.pim[@"param"] = @"value";
    
    XCTAssertEqualObjects(self.pim[@"param"], @"value");
}

- (void)testWithBlock
{
    self.pim[@"service"] = ^(void) {
        return Foo.new;
    };
    XCTAssertTrue([self.pim[@"service"] isKindOfClass:Foo.class]);
}

- (void)testServicesShouldBeDifferent
{
    self.pim[@"service"] = [self.pim factory:^(OPContainer *container) {
        return Foo.new;
    }];
    
    Foo *serviceOne = self.pim[@"service"];
    XCTAssertTrue([serviceOne isKindOfClass:Foo.class]);
    
    Foo *serviceTwo = self.pim[@"service"];
    XCTAssertTrue([serviceTwo isKindOfClass:Foo.class]);
    
    XCTAssertTrue(serviceOne != serviceTwo);
}

- (void)testShouldPassContainerAsParameter
{
    self.pim[@"service"] = ^(void) {
        return Foo.new;
    };
    __block OPContainer *pimRef = self.pim;
    self.pim[@"container"] = ^(void) {
        return pimRef;
    };
    
    XCTAssertTrue(self.pim != self.pim[@"service"]);
    XCTAssertTrue(self.pim == self.pim[@"container"]);
}

- (void)testIsset
{
    self.pim[@"param"] = @"value";
    self.pim[@"service"] = ^(void) {
        return Foo.new;
    };
    self.pim[@"null"] = NSNull.null;
    
    XCTAssertNotNil(self.pim[@"param"]);
    XCTAssertNotNil(self.pim[@"service"]);
    XCTAssertNotNil(self.pim[@"null"]);
}

- (void)testConstructorInjection
{
    NSDictionary *params = @{@"param": @"value"};
    OPContainer *pim = [[OPContainer alloc] initWithParams:params];
    
    XCTAssertEqualObjects(pim[@"param"], @"value");
}

- (void)testValidatesKey
{
    XCTAssertThrows(self.pim[@"unknown"]);
}

- (void)testExtendValidatesKey
{
    XCTAssertThrows(
        [self.pim extend:@"foo"
                withCode:^(id service, OPContainer *container) {}]
    );
}

- (void)testShare
{
    self.pim[@"shared_service"] = Foo.new;
    
    Foo *serviceOne = self.pim[@"shared_service"];
    XCTAssertTrue([serviceOne isKindOfClass:Foo.class]);
    
    Foo *serviceTwo = self.pim[@"shared_service"];
    XCTAssertTrue([serviceTwo isKindOfClass:Foo.class]);
    
    XCTAssertTrue(serviceOne == serviceTwo);
}

- (void)testProtect
{
    __block id result = nil;
    self.pim[@"protected"] = [self.pim protect:^(void){
        result = @(arc4random());
        return result;
    }];
    
    XCTAssertTrue(result == self.pim[@"protected"]);
}

- (void)testExtend
{
    self.pim[@"shared_service"] = ^(void) {
        return Foo.new;
    };
    self.pim[@"factory_service"] = [self.pim factory:^id(OPContainer *c) {
        return Foo.new;
    }];
    
    [self.pim extend:@"shared_service"
            withCode:^(id service, OPContainer *container)
    {
        NSString *value = [[NSString alloc] initWithFormat:@"%@", @"value"];
        [(Foo *)service setBar:value];        [(Foo *)service setBar:@"value"];
    }];
    
    Foo *serviceOne = nil;
    Foo *serviceTwo = nil;
    
    serviceOne = self.pim[@"shared_service"];
    XCTAssertTrue([serviceOne isKindOfClass:Foo.class]);
    serviceTwo = self.pim[@"shared_service"];
    XCTAssertTrue([serviceTwo isKindOfClass:Foo.class]);
    XCTAssertTrue(serviceOne == serviceTwo);
    XCTAssertTrue(serviceOne.bar == serviceTwo.bar);
    
    [self.pim extend:@"factory_service"
            withCode:^(id service, OPContainer *container)
    {
        NSString *value = [[NSString alloc] initWithFormat:@"%@", @"value"];
        [(Foo *)service setBar:value];
    }];
    
    serviceOne = self.pim[@"factory_service"];
    XCTAssertTrue([serviceOne isKindOfClass:Foo.class]);
    serviceTwo = self.pim[@"factory_service"];
    XCTAssertTrue([serviceTwo isKindOfClass:Foo.class]);
    XCTAssertFalse(serviceOne == serviceTwo);
    XCTAssertFalse(serviceOne.bar == serviceTwo.bar);
}

@end
