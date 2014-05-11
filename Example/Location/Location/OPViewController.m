//
//  OPViewController.m
//  Location
//
//  Created by Víctor on 11/05/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

#import "OPViewController.h"

@interface OPViewController ()

@end

@implementation OPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *application = UIApplication.sharedApplication;
    NSString *value = application.container[@"value"];
    
    NSLog(@"Value: %@", value);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
