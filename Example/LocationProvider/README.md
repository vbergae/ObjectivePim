# Objective Pim Example #

## Location ##

Location is a simple example projects which shows how to encapsulate quick access to user's location values using ObjectivePim.

Steps to create a service provider are:

1. Implement ``OPServiceProviderProtocol`` on some class to create the service provider
2. Register some service using ``OPContainer``
3. Use your service on any place!

### Implement OPServiceProviderProtocol ###

*OPLocationProvider.h*

	@import Foundation;
	@import CoreLocation;

	@interface OPLocationProvider : NSObject
	<OPServiceProviderProtocol, CLLocationManagerDelegate>

	- (void)updateLocations:(void(^)(NSArray *locations, NSError *error))handler;

	@end
	
*OPLocationProvider.m*

	#import "OPLocationProvider.h"

	@interface OPLocationProvider() {
	@private
    	CLLocationManager *_manager;
	}

	@property (readonly) CLLocationManager *manager;
	@property (strong) void(^handler)(NSArray *, NSError *);

	@end

	@implementation OPLocationProvider

	#pragma mark -
	#pragma mark Properties

	- (CLLocationManager *)manager
	{
    	if (!_manager) {
        	_manager = [[CLLocationManager alloc] init];
	        _manager.delegate = self;
    	}
    
	    return _manager;
	}

	#pragma mark -
	#pragma mark Instance methods

	- (void)updateLocations:(void (^)(NSArray *, NSError *))handler
	{
    	NSParameterAssert(handler);
    
	    self.handler = handler;
    	[self.manager startUpdatingLocation];
	}

	#pragma mark -
	#pragma mark OPServiveProviderProtocol

	- (NSString *)identifier
	{
    	return @"location";
	}

	#pragma mark -
	#pragma mark CLLocationManagerDelegate

	- (void)locationManager:(CLLocationManager *)manager
    	 didUpdateLocations:(NSArray *)locations
	{
    	self.handler(locations, nil);
	    [self.manager stopUpdatingLocation];
	}

	- (void)locationManager:(CLLocationManager *)manager
    	   didFailWithError:(NSError *)error
	{
    	self.handler(nil, error);
	    [self.manager stopUpdatingLocation];
	}

	@end
	
### Register the service ###

*OPAppDelegate.m*

	- (BOOL)application:(UIApplication *)application 
	didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		// Override point for customization after application launch.
    	[application.container registerProvider:OPLocationProvider.new];
        
    	return YES;
	}
	
### Use your service at any place! ###

*OPViewController*

	- (void)viewDidLoad
	{
    	[super viewDidLoad];
    
	    UIApplication *application = UIApplication.sharedApplication;
    	OPLocationProvider *location = application.container[@"location"];
	    [location updateLocations:^(NSArray *locations, NSError *error) {
    	    if (error) {
        	    NSLog(@"Error updating location: %@", error);
	        } else {
    	        NSLog(@"Locations: %@", locations);
        	}
	    }];
	}





