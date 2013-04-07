//
//  PollViewController.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "PollViewController.h"
#import "PollVoteViewController.h"
#import "Model.h"
#import "Poll.h"

@interface PollViewController ()

@end

@implementation PollViewController
@synthesize scrollView, polls;

- (void)viewDidLoad {
    CGRect screenRect = [self.view bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    _ptr = [[PullToRefresh alloc] initWithScrollView:self.scrollView delegate:self];
    self.polls = [[NSMutableArray alloc] init];
    [self populateScrollViewCompletion:nil];
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self populateScrollViewCompletion:nil];
}
- (void)populateScrollViewCompletion:(void (^)(void))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[Model sharedInstance] getPollsWithCompletion:^(NSArray *pollsArray) {
            [self.polls removeAllObjects];
            for (UIView *view in [self.scrollView subviews]) {
                if (view.tag != 10) [view removeFromSuperview];
            }
            NSLog(@"After clean, subview count:%d", [self.scrollView subviews].count);
            int i = 0;
            for (Poll *poll in pollsArray) {
                PollVoteViewController *vc = [[PollVoteViewController alloc] initWithNibName:@"PollVoteViewController" bundle:nil];

                vc.poll = poll;
                vc.view.frame = CGRectMake(0, i * 462, 320, 462);
                [self.scrollView addSubview:vc.view];
                [self.polls addObject:vc];
                i++;
            }
            self.scrollView.contentSize = CGSizeMake(320, i * 462);
            
            
            if (completion) completion();
            NSLog(@"After populate, subview count:%d", [self.scrollView subviews].count);
        }];
    });
}


#pragma mark - CustomPullToRefresh Delegate Methods

- (void)customPullToRefreshShouldRefresh:(PullToRefresh *)ptr {
    NSLog(@"REFRESH");
    if (!isrefreshing) {
        [self populateScrollViewCompletion:^{
            [ptr endRefresh];
            isrefreshing = NO;
        }];
    }
    
}
@end
