//
//  PollVoteViewController.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "PollVoteViewController.h"
#import "Model.h"
#import "Session.h"
#import "PollItems.h"
#import "Vote.h"


@interface PollVoteViewController ()

@end

@implementation PollVoteViewController
@synthesize poll = _poll;

- (void)setPoll:(Poll *)poll {
    if (poll != _poll) {
        _poll = poll;
        for (int i = 1; i <= 4; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            PollItems *item = [self.poll.items objectAtIndex:i-1];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageURL]];
                if (data) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    }];
                }
            });
        }
        
        BOOL userFound = NO;
        int voteIndex = 0;
        if ([Session sharedInstance].user) {
            Vote *v;
            for (PollItems *item in poll.items) {
                //declare low, mid, and high
                if (item.votes.count < 1) continue;
                int low = 0, mid, high = item.votes.count - 1;
                int x = [Session sharedInstance].user.userID; //search for this
                mid = (low + high) / 2;
                //binary search loop
                while (low <= high)
                {
                    //check target against list[mid]
                    if (x < [(Vote *)[item.votes objectAtIndex:mid] user]) {
                        //if target is below list[mid] reset high
                        high = mid;
                        mid = floorf((low + high) / 2);
                    }
                    else if (x > [(Vote *)[item.votes objectAtIndex:mid] user]) {
                        //if target is below list[mid]) reset low
                        low = high + 1;
                        mid = ceilf((low + high) / 2);
                    }
                    else
                        //if target is found set low to exit the loop
                        low = high + 1;
                }
                
                //return true if target found, false if not found
                if (x == [(Vote *)[item.votes objectAtIndex:mid] user]) {
                    userFound = YES;
                    v = [item.votes objectAtIndex:mid];
                    voteIndex = v.voteIndex;

                    break;
                }
                else
                    userFound = NO;
            }
        }
        else {
            NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
            for (NSString *key in defaults) {
                if ([key isEqualToString:[NSString stringWithFormat:@"Poll:%d", poll.pollID]]) {
                    userFound = YES;
                    voteIndex = [[defaults objectForKey:key] intValue];
                    
                }
            }
        }
        

        

        
        if (userFound) {
            //user has already voted for this item
            UIButton *button = (UIButton *)[self.view viewWithTag:voteIndex];
            UIImageView *voteView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x - 6, button.frame.origin.y - 6, button.frame.size.width + 11, button.frame.size.height + 11)];
            voteView.image = [UIImage imageNamed:@"Voted.png"];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.view addSubview:voteView];
                for (int i = 1; i <= 4; i++) {
                    UIButton *b = (UIButton *)[self.view viewWithTag:i];
                    b.userInteractionEnabled = NO;
                    if (i != voteIndex) {
                        UIImageView *nonvotedView = [[UIImageView alloc] initWithFrame:CGRectMake(b.frame.origin.x - 6, b.frame.origin.y - 4, b.frame.size.width + 12, b.frame.size.height + 8)];
                        nonvotedView.image = [UIImage imageNamed:@"NotVoted.png"];
                        [self.view addSubview:nonvotedView];
                        
                    }
                }
            }];
        }
    }
}

- (IBAction)vote:(UIButton *)sender {
    [[Model sharedInstance] vote:sender.tag onPoll:self.poll.pollID completion:^{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(sender.frame.origin.x - 5, sender.frame.origin.y - 4, sender.frame.size.width + 8, sender.frame.size.height + 8)];
        imageView.image = [UIImage imageNamed:@"Voted.png"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.view addSubview:imageView];
            for (int i = 1; i <= 4; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                button.userInteractionEnabled = NO;
                if (i != sender.tag) {
                    UIImageView *nonvotedView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x - 5, button.frame.origin.y - 4, button.frame.size.width + 8, button.frame.size.height + 8)];
                    nonvotedView.image = [UIImage imageNamed:@"NotVoted.png"];
                    //nonvotedView.layer.cornerRadius = 50.0f; - not working
                    [self.view addSubview:nonvotedView];
                    
                }
            }
        }];
        
    }];
}

@end
