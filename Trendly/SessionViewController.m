//
//  SessionViewController.m
//  Trendly
//
//  Created by Michael Scaria on 4/7/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "SessionViewController.h"
#import "Model.h"

@interface SessionViewController ()

@end

@implementation SessionViewController
@synthesize username, password;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.password.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {

}

- (IBAction)signup:(id)sender {
    NSDictionary *d = @{@"username": self.username.text, @"password" : self.password.text, @"first_name" : @"name", @"last_name" : @"last", @"email" : @"email"};
    [[Model sharedInstance] signUpWithDictionary:d WithSuccess:nil failure:nil];
    [username resignFirstResponder];
    [password resignFirstResponder];

}
@end
