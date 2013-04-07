//
//  Session.h
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Session : NSObject
+ (Session*)sharedInstance;
@property (nonatomic, strong) User *user;
@end
