//
//  ObjectivePim.h
//  ObjectivePim
//
//  Created by Víctor on 17/04/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPContainer;

/**
 * ObjectivePim service provider interface.
 */
@protocol OPServiceProviderProtocol <NSObject>
@required

/**
 Returns an unique identifier used by OPContainer as service's key
 */
@property (readonly) NSString * _Nonnull identifier;

@optional

/**
 * Registers services on the given container.
 *
 * This method should only be used to configure services and parameters.
 * It should not get services.
 *
 * @param contaienr An Container instance
 */
- (void)registerProvider:(OPContainer * _Nonnull)container;

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
- (instancetype _Nonnull)initWithParams:(NSDictionary * _Nullable)params;

/**
 @name Service Container
 */

/**
 Marks a block as being a factory service.
 
 @param block A service definition to be used as a factory
 *
 @return The passed block result
 */
- (id _Nonnull)factory:(nonnull id _Nonnull (^)(OPContainer * _Nonnull container))block;

/**
 * Protects a callable from being interpreted as a service.
 *
 * This is useful when you want to store a callable as a parameter.
 *
 * @param code A block to protect from being evaluated
 *
 * @return The passed block result
 */
- (id _Nonnull)protect:(nonnull id _Nonnull(^)(void))code;

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
- (void)extend:(NSString * _Nonnull)key
      withCode:(nonnull void(^)(id _Nonnull service, OPContainer * _Nonnull container))block;

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
- (instancetype _Nonnull)registerProvider:(id<OPServiceProviderProtocol> _Nonnull)provider;

/**
 * Registers a service provider.
 *
 * @param provider A ServiceProviderInterface instance
 * @param params An array of values that customizes the provider
 *
 * @return self
 */
- (instancetype _Nonnull)registerProvider:(id<OPServiceProviderProtocol> _Nonnull)provider
                             params:(NSDictionary * _Nonnull)params;

@end
