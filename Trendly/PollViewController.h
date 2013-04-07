//
//  PollViewController.h
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh.h"

@interface PollViewController : UIViewController <UIScrollViewDelegate, PullToRefreshDelegate> {
    PullToRefresh *_ptr;
    BOOL isrefreshing;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *polls;
@end