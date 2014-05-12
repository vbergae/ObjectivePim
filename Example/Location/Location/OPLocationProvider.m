//
//  OPLocationProvider.m
//  Location
//
//  Created by Víctor on 11/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import "OPLocationProvider.h"

@interface OPLocationProvider() {
@private
    CLLocationManager *_manager;
}

@property (readonly) CLLocationManager *manager;
@property (strong) void(^handler)(NSArray *, NSError *);

@end

@implementation OPLocationProvider

#pragma mark -
#pragma mark Properties

- (CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    
    return _manager;
}

#pragma mark -
#pragma mark Instance methods

- (void)updateLocations:(void (^)(NSArray *, NSError *))handler
{
    NSParameterAssert(handler);
    
    self.handler = handler;
    [self.manager startUpdatingLocation];
}

#pragma mark -
#pragma mark OPServiveProviderProtocol

- (NSString *)identifier
{
    return @"location";
}

- (void)registerProvider:(OPContainer *)container
{

}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    self.handler(locations, nil);
    [self.manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    self.handler(nil, error);
    [self.manager stopUpdatingLocation];
}

@end
