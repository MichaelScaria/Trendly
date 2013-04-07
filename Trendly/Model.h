//
//  Model.h
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
+ (Model*)sharedInstance;
- (void)getPollsWithCompletion:(void (^)(NSArray *))completion;
- (void)vote:(NSInteger)voteIndex onPoll:(int)pollID completion:(void (^)(void))completion;
- (void)signUpWithDictionary:(NSDictionary *)dictionary WithSuccess:(void (^)(void))success failure:(void (^)(void))failure;
- (void)logInWithDictionary:(NSDictionary *)dictionary WithSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end

