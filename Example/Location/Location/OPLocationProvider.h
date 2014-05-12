//
//  OPLocationProvider.h
//  Location
//
//  Created by Víctor on 11/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface OPLocationProvider : NSObject
<OPServiceProviderProtocol, CLLocationManagerDelegate>

- (void)updateLocations:(void(^)(NSArray *locations, NSError *error))handler;

@end
