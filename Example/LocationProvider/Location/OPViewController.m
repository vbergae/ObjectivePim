//
//  OPViewController.m
//  Location
//
//  Created by Víctor on 11/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import "OPViewController.h"
#import "OPLocationProvider.h"

@interface OPViewController ()

@end

@implementation OPViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
