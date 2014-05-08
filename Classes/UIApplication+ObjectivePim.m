//
//  UIApplication+ObjectivePim.m
//  ObjectivePim
//
//  Created by Víctor on 06/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import "UIApplication+ObjectivePim.h"
#import "OPContainer.h"

@implementation UIApplication (ObjectivePim)

- (OPContainer *)container
{
    static OPContainer *container;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        container = [[OPContainer alloc] init];
    });
    
    return container;
}

@end
