# ObjectivePim

ObjectivePim is a small Dependency Injection Container for Objective-C based on the code of [Pimple](https://github.com/fabpot/Pimple) project (including this file :P).

## Installation


The supported way to get OCJiraFeedback is using [CocoaPods](http://cocoapods.org/).

Add OCJiraFeedback to your Podfile:


	platform :ios, '7.0'

	pod 'ObjectivePim'

## Usage


Creating a container is a matter of instating the ``OPContainer`` class

    #import "OPContainer.h"

    OPContainer *container = OPContainer.new;


As many other dependency injection containers, ObjectivePim is able to manage two
different kind of data: *services* and *parameters*.

### Defining Parameters

Defining a parameter is as simple as using the ObjectivePim instance as a dictionary:

    // define some parameters
    container[@"foo"] = @"bar"";
    container[@"default_items"] = @5;

### Defining Services

A service is an object that does something as part of a larger system.
Examples of services: Database connection, templating engine, mailer. Almost
any object could be a service.

Services are defined by blocks that return an instance of an object

    // define some services
	container[@"service"] = ^(void) {
        return Foo.new;
    };
    
    __block OPContainer *container = OPContainer.new;
    container[@"other_service"] = ^(void) {
    	return [[Bar alloc] initWithValue:container[@"value"]];
    };

Notice that, in the second example, the block has access to the current container instance, 
allowing references to other services or parameters.

As objects are only created when you get them, the order of the definitions
does not matter, and there is no performance penalty.

Using the defined services is also very easy

    // get the session object
    id service = container[@"service"];

### Protecting Parameters

Because ObjectivePim sees blocks as service definitions, you need to
wrap blocks with the ``protect:`` method to store them as
parameter

	container[@"random"] = [container protect:^(void){
        return @(arc4random());
    }];

### Modifying services after creation

In some cases you may want to modify a service definition after it has been
defined. You can use the ``extend:`` method to define additional code to
be run on your service just after it is created

	container[@"afnetworking"] = ^(void) {
		NSURL *baseURL = [NSURL URLWithString:@"http://somehost.com"];
			
		return [[AFAppDotNetAPIClient alloc] 
		         initWithBaseURL:baseURL];
	};
	
	[container extend:@"afnetworking" withCode:^(id service, OPContainer *container) {
		AFAppDotNetAPIClient *client = (AFAppDotNetAPIClient *)service;
		
		client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
	}];

The first argument is the name of the object, the second is a block that
gets access to the object instance and the container.

### Extending a Container

If you use the same libraries over and over, you might want to reuse some
services from one project to the other; package your services into a
**provider** by implementing ``OPServiceProviderProtocol``:

	@interface FooProvider : NSObject<OPServiceProviderProtocol>

	@end 
	
	@implementation FooProvider
	
	- (void)registerProvider:(OPContainer *)container
	{
		// register some services and parameters
        // on container
	}
	
	@end

Then, the provider can be easily registered on a Container:

    [container register:FooProvider.new];

### Defining Factory Services

By default, each time you get a service, ObjectivePim returns the **same instance**
of it. If you want a different instance to be returned for all calls, wrap your
block with the ``factory:`` method

    container[@"service"] = [container factory:^(OPContainer *container) {
        return [[Foo alloc] initWithValue:container[@"key_to_value"]];
    }];

