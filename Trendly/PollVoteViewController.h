//
//  PollVoteViewController.h
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poll.h"

@interface PollVoteViewController : UIViewController
@property (nonatomic, strong) Poll *poll;


@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;

@property (strong, nonatomic) IBOutlet UIButton *results;
@property (strong, nonatomic) IBOutlet UILabel *name;
- (IBAction)vote:(UIButton *)sender;
- (IBAction)comment:(id)sender;
- (IBAction)results:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)link:(id)sender;
@end
