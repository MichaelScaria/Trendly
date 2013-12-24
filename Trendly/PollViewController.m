//
//  PollViewController.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "PollViewController.h"
#import "PollVoteViewController.h"
#import "ResultsViewController.h"
#import "WebViewController.h"
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
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(results:) name:@"Results" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(web:) name:@"Web" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Results" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Web" object:nil];
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
            self.scrollView.contentSize = CGSizeMake(320, (i * 462) - 10.0f);
            
            
            if (completion) completion();
            NSLog(@"After populate, subview count:%d", [self.scrollView subviews].count);
        }];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Results"]) {
        Poll *p = (Poll *)sender;
        ResultsViewController *vc = (ResultsViewController*)segue.destinationViewController;
        vc.poll = p;
        
    }
    else if ([segue.identifier isEqualToString:@"Web"]) {
        NSURL *url = (NSURL *)sender;
        WebViewController *vc = (WebViewController*)segue.destinationViewController;
        vc.url = url;
    }

}


- (void)results:(NSNotification *)notification {
    Poll *p = (Poll *)notification.object;
    [self performSegueWithIdentifier:@"Results" sender:p];
}

- (void)web:(NSNotification *)notification {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", notification.object]];
    [self performSegueWithIdentifier:@"Web" sender:url];

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
