//
//  NSString+ObjectivePim.m
//  ObjectivePim
//
//  Created by Víctor Berga on 13/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import "NSString+ObjectivePim.h"

static NSRange FirstDotRange(NSString *path)
{
    return [path rangeOfString:@"."];
}

@implementation NSString (ObjectivePim)

- (BOOL)isKeyPath
{
    return FirstDotRange(self).location != NSNotFound ? YES : NO;
}

- (NSString *)rootKey
{
    NSString *root = nil;
    
    if (self.isKeyPath) {
        root = [self substringToIndex:FirstDotRange(self).location];
    }
    
    return root;
}

- (NSString *)relativeKeyPath
{
    NSString *relativePath = nil;
    
    if (self.isKeyPath) {
        relativePath = [self substringFromIndex:FirstDotRange(self).location + 1];
    }
    
    return relativePath;
}

@end
