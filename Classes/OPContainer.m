//
//  ObjectivePim.m
//  ObjectivePim
//
//  Created by Víctor on 17/04/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import "OPContainer.h"
#import "NSString+ObjectivePim.h"

/**
 @name Helper functions
 */

static BOOL IsBlock(id object)
{
  // Checks if the value is a block
  // Tip from: http://stackoverflow.com/a/16285585/581667
  id block = ^{};
  Class blockClass = [block class];
  while ([blockClass superclass] != [NSObject class]) {
    blockClass = [blockClass superclass];
  }
  
  return ([object isKindOfClass:blockClass]) ? YES : NO;
}

/**
 @name Factory class
 */

@interface Factory : NSObject

@property (strong) id(^block)(OPContainer *container);

+ (instancetype)factoryWithBlock:(id(^)(OPContainer *container))block;

@end

@implementation Factory

+ (instancetype)factoryWithBlock:(id (^)(OPContainer *))block
{
  NSParameterAssert(block);
  
  Factory *fac = Factory.new;
  fac.block = block;
  
  return fac;
}

@end

/**
 @name OPContainer's implementation
 */

@interface OPContainer()

@property NSMutableDictionary *dictionary;
@property NSMutableDictionary *extensions;

- (id)rootObjectForKeyPath:(id)aKey;
- (void)setObject:(id)anObject forKeyPath:(id<NSCopying>)aKey;
- (id)objectForKeyPath:(id)aKey;
- (void)extendService:(id)aKey object:(id)object;
- (BOOL)bootService:(id *)object_p withKey:(id)aKey;

@end

@implementation OPContainer

#pragma mark -
#pragma mark Memory management;

- (void) dealloc
{
  self.dictionary = nil;
  self.extensions = nil;
}

#pragma mark -
#pragma mark NSDictionary overrideds

- (instancetype _Nonnull)init
{
  return [self initWithObjects:NULL forKeys:NULL count:0];
}

- (instancetype _Nonnull)initWithParams:(NSDictionary *)params
{
  
  
  self = [self init];
  if (self) {
    for (NSString *key in params) {
      self[key] = params[key];
    }
  }
  
  return self;
}

- (instancetype _Nonnull)initWithObjects:(const id [])objects
                                 forKeys:(const id<NSCopying> [])keys
                                   count:(NSUInteger)cnt
{
  self = [super init];
  if (self) {
    self.dictionary = [[NSMutableDictionary alloc]
                       initWithObjects:objects
                       forKeys:keys
                       count:cnt];
    self.extensions = NSMutableDictionary.new;
  }
  
  return self;
}

- (NSUInteger)count
{
  return [self.dictionary count];
}

- (id)objectForKey:(id)aKey
{
  id object = nil;
  
  if ([(NSObject *)aKey isKindOfClass:NSString.class]
      && [(NSString *)aKey isKeyPath])
  {
    object = [self objectForKeyPath:aKey];
  } else {
    object = self.dictionary[aKey];
    NSParameterAssert(object);
    
    BOOL needToExtend = [self bootService:&object withKey:aKey];
    if (needToExtend) {
      [self extendService:aKey object:object];
    }
  }
  
  return object;
}

- (NSEnumerator *)keyEnumerator
{
  return [self.dictionary keyEnumerator];
}

#pragma mark -
#pragma mark NSMutableDictionary overrides

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
  NSParameterAssert(anObject);
  NSParameterAssert(aKey);
  
  if ([(NSObject *)aKey isKindOfClass:NSString.class]
      && ![(NSString *)aKey isKeyPath])
  {
    [self.dictionary setObject:anObject forKey:aKey];
  } else {
    [self setObject:anObject forKeyPath:aKey];
  }
}

- (void)removeObjectForKey:(id)aKey
{
  [self.dictionary removeObjectForKey:aKey];
}

#pragma mark -
#pragma mark Instance methods

- (id)factory:(id(^)(OPContainer *))block
{
  NSParameterAssert(block);
  
  return [Factory factoryWithBlock:block];
}

- (void)extend:(NSString *)key withCode:(void (^)(id, OPContainer *))block
{
  NSParameterAssert([self.allKeys indexOfObject:key] != NSNotFound);
  
  id currentExtension = self.extensions[key];
  
  if (!currentExtension) {
    self.extensions[key] = block;
  } else if ([currentExtension isKindOfClass:NSMutableArray.class]) {
    [(NSMutableArray *)currentExtension addObject:block];
  } else {
    NSMutableArray *objectExtensions = [NSMutableArray arrayWithObjects:
                                        currentExtension, block, nil];
    self.extensions[key] = objectExtensions;
  }
}

- (id)protect:(id (^)(void))code
{
  NSParameterAssert(code);
  
  id value = code();
  NSParameterAssert(value);
  
  return value;
}

- (instancetype _Nonnull)registerProvider:(id<OPServiceProviderProtocol>)provider
{
  NSParameterAssert(provider);
  
  if ([provider respondsToSelector:@selector(registerProvider:)]) {
    [provider registerProvider:self];
  }
  
  self[provider.identifier] = provider;
  
  return self;
}

- (instancetype _Nonnull)registerProvider:(id<OPServiceProviderProtocol>)provider
                                   params:(NSDictionary *)params
{
  [self registerProvider:provider];
  NSString *serviceKey = provider.identifier;
  
  for (NSString *key in params) {
    NSString *keypath = [serviceKey stringByAppendingFormat:@".%@", key];
    [self setObject:params[key] forKeyPath:keypath];
  }
  
  return self;
}

#pragma mark -
#pragma mark Private methods

- (id)rootObjectForKeyPath:(id)aKey
{
  NSString *objectKey = [(NSString *)aKey rootKey];
  
  return self[objectKey];
}

- (void)setObject:(id)anObject forKeyPath:(id<NSCopying>)aKey
{
  id object = [self rootObjectForKeyPath:aKey];
  
  [object setValue:anObject forKeyPath:[(NSString *)aKey relativeKeyPath]];
}

- (id)objectForKeyPath:(id)aKey
{
  id object = [self rootObjectForKeyPath:aKey];
  
  return [object valueForKeyPath:[(NSString *)aKey relativeKeyPath]];
}

- (void)extendService:(id)aKey object:(id)object
{
  id extension = self.extensions[aKey];
  if (IsBlock(extension)) {
    void(^extensionBlock)(id, OPContainer *) = extension;
    extensionBlock(object, self);
  } else if ([extension isKindOfClass:NSMutableArray.class]) {
    for (void(^extensionBlock)(id, OPContainer *) in (NSMutableArray *)extension) {
      extensionBlock(object, self);
    }
  }
  
  [self.extensions removeObjectForKey:aKey];
}

- (BOOL)bootService:(id *)object_p withKey:(id)aKey
{
  if (IsBlock(*object_p)) {
    id(^block)(void) = *object_p;
    *object_p = block();
    
    [self.dictionary setObject:*object_p forKey:aKey];
  } else if ([*object_p isKindOfClass:Factory.class]) {
    id(^block)(OPContainer *) = [(Factory *)*object_p block];
    *object_p = block(self);
  }
  
  return self.extensions[aKey] ? YES : NO;
}

@end