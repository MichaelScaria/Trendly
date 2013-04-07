//
//  PollItems.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "PollItems.h"
#import "Vote.h"

@implementation PollItems

+ (id)pollItemWithDictionary:(NSDictionary *)itemDictionary {
    PollItems *item = [[self alloc] initWithDictionary:itemDictionary];
    return item;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        for (NSString *key in dictionary) {
            id value = [dictionary objectForKey:key];
            if (!value) continue; //if value is null, skip
            
            if ([key isEqualToString:@"image_url"]) {
                self.imageURL = value;
            }
            else if ([key isEqualToString:@"votes"]) {
                NSMutableArray *tempVotes = [[NSMutableArray alloc] init];
                for (NSDictionary *voteDictionary in value) {
                    [tempVotes addObject:[Vote voteWithDictionary:voteDictionary]];
                }
                self.votes = (NSArray *)[tempVotes copy];
            }
            else if ([self respondsToSelector:NSSelectorFromString(key)]) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
    
}
@end
