//
//  NSString+ObjectivePim.m
//  ObjectivePim
//
//  Created by Víctor Berga on 13/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import "NSString+ObjectivePim.h"

@implementation NSString (ObjectivePim)

- (BOOL)isKeyPath
{
    return [self rangeOfString:@"."].location != NSNotFound ? YES : NO;
}

@end
