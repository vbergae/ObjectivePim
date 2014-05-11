//
//  OPLocationProvider.m
//  Location
//
//  Created by Víctor on 11/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import "OPLocationProvider.h"

@implementation OPLocationProvider

#pragma mark -
#pragma mark OPServiveProviderProtocol

- (void)registerProvider:(OPContainer *)container
{
    container[@"value"] = @"Hello world!";
}

@end
