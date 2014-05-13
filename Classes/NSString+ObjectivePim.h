//
//  NSString+ObjectivePim.h
//  ObjectivePim
//
//  Created by Víctor Berga on 13/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Category to NSString which adds some helper methods
 */
@interface NSString (ObjectivePim)

/**
 Returns YES if the receiver is a keypath (it contains at lest one dot).

 For example:
    * @"foo"            -> returns NO;
    * @"foo.bar"        -> returns YES;
    * @"foo.bar-value"  -> returns YES;
    * @"foo-bar"        -> returns NO;
 */
@property (readonly, getter = isKeyPath) BOOL keyPath;

/**
 Returns root key if the receiver is a KeyPath, otherside returns NO. 
 @see isKeyPath
 
 @return Root key if the receiver is a valid keyPath
 */
- (NSString *)rootKey;

@end
