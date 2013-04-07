//
//  Poll.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "Poll.h"
#import "PollItems.h"

@implementation Poll
@synthesize pollID, items;

+ (NSArray *)pollsWithArray:(NSArray *)pollArray {
    NSMutableArray *contests = [NSMutableArray arrayWithCapacity:pollArray.count];
    for (NSDictionary *dictionary in pollArray) {
        Poll *contest = [[self alloc] initWithDictionary:dictionary];
        [contests addObject:contest];
    }
    return [contests copy];
}

+ (id)pollWithDictionary:(NSDictionary *)pollDictionary {
    Poll *poll = [[self alloc] initWithDictionary:pollDictionary];
    return poll;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        for (NSString *key in dictionary) {
            id value = [dictionary objectForKey:key];
            if (!value) continue; //if value is null, skip
            if ([key isEqualToString:@"id"]) {
                self.pollID = [value intValue];
            }
            else if ([key isEqualToString:@"poll_items"]) {
                NSMutableArray *tempItems = [[NSMutableArray alloc] init];
                for (NSDictionary *itemDictionary in value) {
                    NSLog(@"item:%@", itemDictionary);
                    [tempItems addObject:[PollItems pollItemWithDictionary:itemDictionary]];
                }
                self.items = (NSArray *)[tempItems copy];
            }
            
        }
    }
    return self;
    
}

@end
