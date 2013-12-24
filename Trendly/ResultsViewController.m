//
//  ResultsViewController.m
//  Trendly
//
//  Created by Michael Scaria on 4/7/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "ResultsViewController.h"
#import "PollItems.h"
#import "Vote.h"
#import "User.h"
#import "JSONKit.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController
@synthesize poll =_poll;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setPoll:(Poll *)poll {
    if (poll != _poll) {
        _poll = poll;
        for (int i = 1; i <= 4; i++) {
            PollItems *item = [self.poll.items objectAtIndex:i-1];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageURL]];
                if (data) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8 + (79 * (i-1)), 36, 68, 68)];
                        imageView.image = [UIImage imageWithData:data];
                        [self.view addSubview:imageView];
                        UILabel *brand = [[UILabel alloc] initWithFrame:CGRectMake(18 + (79 * (i-1)), 113, 38, 21)];
                        brand.font = [UIFont fontWithName:@"Fabrica" size:11];
                        brand.text = item.brand;
                        brand.textColor = [UIColor whiteColor];
                        brand.backgroundColor = [UIColor clearColor];
                        [self.view addSubview:brand];
                        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(36 + (79 * (i-1)), 142, 42, 24)];
                        number.font = [UIFont fontWithName:@"Fabrica" size:19];
                        number.text = [NSString stringWithFormat:@"%d", item.votes.count];
                        number.textColor = [UIColor colorWithRed:208.0/255.0 green:207.0/255.0 blue:185.0/255.0 alpha:1.0];
                        number.backgroundColor = [UIColor clearColor];
                        [self.view addSubview:number];
                        UILabel *votes = [[UILabel alloc] initWithFrame:CGRectMake(26 + (79 * (i-1)), 157, 42, 24)];
                        votes.font = [UIFont fontWithName:@"Fabrica" size:13];
                        votes.text = @"votes";
                        votes.textColor = [UIColor colorWithRed:208.0/255.0 green:207.0/255.0 blue:185.0/255.0 alpha:1.0];
                        votes.backgroundColor = [UIColor clearColor];
                        [self.view addSubview:votes];
                    }];
                }
            });
            /*for (Vote *v in item.votes) {
                int row1 = 5;
                int row2 = 5;
                int row3 = 5;
                int row4 = 5;

                if (v.voteIndex == 1) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, row1, 16, 16)];
                    NSMutableURLRequest *userReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://rshack.herokuapp.com/users/%d", v.user]]];
                    [userReq setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                    [userReq setHTTPMethod:@"GET"];
                    NSError *error;
                    NSHTTPURLResponse *response;
                    NSData *data = [NSURLConnection sendSynchronousRequest:userReq returningResponse:&response error:&error];

                    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(5, row1, 25, 16)];
                    username.font = [UIFont fontWithName:@"Fabrica" size:11];
                    username.textColor =  [UIColor colorWithRed:142.0/255.0 green:191.0/255.0 blue:182.0/255.0 alpha:1.0];
                    username.backgroundColor = [UIColor clearColor];
                    if (data){
                        NSArray *userJSON = [[JSONDecoder decoder] objectWithData:data];
                        User *user = [[User alloc] initWithDictionary:[userJSON objectAtIndex:0]];
                        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.imageURL]]];
                        [self.scrollView addSubview:imageView];
                        username.text = user.username;

                    }
                    else {
                        username.text = @"anonymous";

                        [self.scrollView addSubview:username];

                    }
                    row1 += 20;
                }
                self.scrollView.contentSize = CGSizeMake(320, (row1 + row2 + row3 + row4) / 2);
            }*/
        }
    }

}

@end
