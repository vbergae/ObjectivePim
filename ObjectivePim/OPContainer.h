//
//  ObjectivePim.h
//  ObjectivePim
//
//  Created by Víctor on 17/04/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef OP_INSTANCETYPE
#if __has_feature(objc_instancetype)
    #define OP_INSTANCETYPE instancetype
#else
    #define OP_INSTANCETYPE id
#endif
#endif

@class OPContainer;

/**
 * ObjectivePim service provider interface.
 */
@protocol OPServiceProviderProtocol <NSObject>
@required

/**
 * Registers services on the given container.
 *
 * This method should only be used to configure services and parameters.
 * It should not get services.
 *
 * @param contaienr An Container instance
 */
- (void)registerProvider:(OPContainer *)container;

@end

/**
 ObjectivePim
 
 ObjectivePim is a small Dependency Injection Container for Objective-C that 
 consists of just one file and one class.
 
 Download it, require it in your code, and you're good to go
 
 #import "ObjectivePim.h"
 
 Creating a container is a matter of instating the ObjectivePim class
 
 ObjectivePim *container = ObjectivePim.new;
 
 As many other dependency injection containers, ObjectivePim is able to manage 
 two different kind of data: services and parameters.
 */
@interface OPContainer : NSMutableDictionary

/**
 @name Initialization
 */

/**
 * Instantiate the container.
 *
 * Objects and parameters can be passed as argument to the constructor.
 *
 * @param params The parameters or objects dictionary.
 */
- (OP_INSTANCETYPE)initWithParams:(NSDictionary *)params;

/**
 @name Service Container
 */

/**
 Marks a block as being a factory service.
 
 @param block A service definition to be used as a factory
 *
 @return The passed block result
 */
- (id)factory:(id(^)(OPContainer *container))block;

/**
 * Protects a callable from being interpreted as a service.
 *
 * This is useful when you want to store a callable as a parameter.
 *
 * @param code A block to protect from being evaluated
 *
 * @return The passed block result
 */
- (id)protect:(id(^)(void))code;

/**
 * Extends an object definition.
 *
 * Useful when you want to extend an existing object definition,
 * without necessarily loading that object.
 *
 * @param key The unique identifier for the object
 * @param block A service definition to extend the original
 *
 * @return callable The wrapped callable
 */
- (void)extend:(NSString *)key
      withCode:(void(^)(id service, OPContainer *container))block;

/**
 @name Register service providers
 */

/**
 * Registers a service provider.
 *
 * @param provider A ServiceProviderInterface instance
 *
 * @return self
 */
- (OP_INSTANCETYPE)registerProvider:(id<OPServiceProviderProtocol>)provider;

/**
 * Registers a service provider.
 *
 * @param provider A ServiceProviderInterface instance
 * @param params An array of values that customizes the provider
 *
 * @return self
 */
- (OP_INSTANCETYPE)registerProvider:(id<OPServiceProviderProtocol>)provider
                          params:(NSDictionary *)params;

@end
