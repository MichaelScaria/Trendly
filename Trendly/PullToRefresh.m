//
//  PullToRefresh.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "PullToRefresh.h"

@implementation PullToRefresh
@synthesize _rainbowTop, _scrollView;
- (id) initWithScrollView:(UIScrollView *)scrollView delegate:(id<PullToRefreshDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _scrollView = scrollView;
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
        _ptrc = [[MSPullToRefreshController alloc] initWithScrollView:_scrollView delegate:self];
        _rainbowTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pull.png"]];
        _rainbowTop.tag = 10;
        _rainbowTop.frame = CGRectMake(0, -500, 320, 500);
        [scrollView addSubview:_rainbowTop];
        _arrowTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RefreshArrow.png"]];
        _arrowTop.frame = CGRectMake(floorf((_rainbowTop.frame.size.width-_arrowTop.frame.size.width)/2), _rainbowTop.frame.size.height - _arrowTop.frame.size.height - 10 , _arrowTop.frame.size.width, _arrowTop.frame.size.height);
        [_rainbowTop addSubview:_arrowTop];
        
    }
    return self;
}



- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    /**** FUTURE IMPLEMENTATION
     NSLog(@"%@",NSStringFromCGSize(_scrollView.contentSize));
     CGFloat contentSizeArea = _scrollView.contentSize.width*_scrollView.contentSize.height;
     CGFloat frameArea = _scrollView.frame.size.width*_scrollView.frame.size.height;
     CGSize adjustedContentSize = contentSizeArea < frameArea ? _scrollView.frame.size : _scrollView.contentSize;
     _rainbowBot.frame = CGRectMake(0, adjustedContentSize.height, _scrollView.frame.size.width, _scrollView.frame.size.height);*/
    if (_scrollView.contentSize.height == 0.0f) {
        _rainbowTop.frame = CGRectMake(0, -500, 320, 500);
        _arrowTop.frame = CGRectMake(floorf((_rainbowTop.frame.size.width-_arrowTop.frame.size.width)/2), _rainbowTop.frame.size.height - _arrowTop.frame.size.height - 10 , _arrowTop.frame.size.width, _arrowTop.frame.size.height);
    }
    else {
        _rainbowTop.frame = CGRectMake(0, -_scrollView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height);
        _arrowTop.frame = CGRectMake(floorf((_rainbowTop.frame.size.width-_arrowTop.frame.size.width)/2), _rainbowTop.frame.size.height - _arrowTop.frame.size.height - 10 , _arrowTop.frame.size.width, _arrowTop.frame.size.height);
        NSLog(@"_rainbowTop:%@", NSStringFromCGRect(_rainbowTop.frame));
        NSLog(@"_arrowTop:%@", NSStringFromCGRect(_arrowTop.frame));
    }
    
}



- (void) endRefresh {
    [_ptrc finishRefreshingDirection:MSRefreshDirectionTop animated:YES];
    [_ptrc finishRefreshingDirection:MSRefreshDirectionBottom animated:YES];
    [_rainbowTop stopAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        _arrowTop.hidden = NO;
        _arrowTop.transform = CGAffineTransformIdentity;
    });
    
}

- (void) startRefresh {
    [_ptrc startRefreshingDirection:MSRefreshDirectionTop];
}

- (void)updateFrame {
    
}


#pragma mark - MSPullToRefreshDelegate Methods

- (BOOL) pullToRefreshController:(MSPullToRefreshController *)controller canRefreshInDirection:(MSRefreshDirection)direction {
    return direction == MSRefreshDirectionTop || direction == MSRefreshDirectionBottom;
}

- (CGFloat) pullToRefreshController:(MSPullToRefreshController *)controller refreshingInsetForDirection:(MSRefreshDirection)direction {
    return 60;
}

- (CGFloat) pullToRefreshController:(MSPullToRefreshController *)controller refreshableInsetForDirection:(MSRefreshDirection)direction {
    return 60;
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller canEngageRefreshDirection:(MSRefreshDirection)direction {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    _arrowTop.transform = CGAffineTransformMakeRotation(M_PI);
    [UIView commitAnimations];
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller didDisengageRefreshDirection:(MSRefreshDirection)direction {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    _arrowTop.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller didEngageRefreshDirection:(MSRefreshDirection)direction {
    NSLog(@"Should refresh method is");
    if (direction == MSRefreshDirectionTop) {
        NSLog(@"sent");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            _arrowTop.hidden = YES;
            [_rainbowTop startAnimating];
        });
        [_delegate customPullToRefreshShouldRefresh:self];
    }
    
}
@end
