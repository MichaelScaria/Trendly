//
//  PullToRefresh.h
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSPullToRefreshController.h"

@protocol PullToRefreshDelegate;

@interface PullToRefresh : NSObject <MSPullToRefreshDelegate> {
    UIImageView *_rainbowTop;
    UIImageView *_arrowTop;
    MSPullToRefreshController *_ptrc;
    UIScrollView *_scrollView;
    
    id <PullToRefreshDelegate> _delegate;
}
@property (nonatomic, strong) UIImageView *_rainbowTop;
@property (nonatomic, strong) UIScrollView *_scrollView;
- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id <PullToRefreshDelegate>)delegate;
- (void) endRefresh;
- (void) startRefresh;

@end

@protocol PullToRefreshDelegate <NSObject>

- (void)customPullToRefreshShouldRefresh:(PullToRefresh *)ptr;

@end
