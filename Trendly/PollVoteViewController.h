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

- (IBAction)vote:(UIButton *)sender;
@end
