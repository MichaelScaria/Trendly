//
//  ResultsViewController.h
//  Trendly
//
//  Created by Michael Scaria on 4/7/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poll.h"

@interface ResultsViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) Poll *poll;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end
