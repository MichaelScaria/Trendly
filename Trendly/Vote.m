//
//  Vote.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "Vote.h"

@implementation Vote
@synthesize voteIndex, poll, user;

+ (id)voteWithDictionary:(NSDictionary *)itemDictionary {
    Vote *vote = [[self alloc] initWithDictionary:itemDictionary];
    return vote;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        for (NSString *key in dictionary) {
            id value = [dictionary objectForKey:key];
            if (!value) continue; //if value is null, skip
            
            if ([key isEqualToString:@"vote_index"]) {
                self.voteIndex = [value intValue];
            }
            else if ([key isEqualToString:@"poll_id"]) {
                self.poll = [value intValue];
            }
            else if ([key isEqualToString:@"user_id"]) {
                self.user = [value intValue];
            }
        }
    }
    return self;
    
}
@end
