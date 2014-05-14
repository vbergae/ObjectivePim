//
//  UIApplication+ObjectivePim.h
//  ObjectivePim
//
//  Created by Víctor on 06/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPContainer;

/**
 Category on UIApplication which provides direct access to OPContainer
 */
@interface UIApplication (ObjectivePim)

/**
 Returns a initialized insantance of OPContainer. Always returns the
 same instance.
 */
@property (readonly) OPContainer *container;

@end
