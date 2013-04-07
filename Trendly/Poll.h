//
//  Poll.h
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Poll : NSObject
@property (nonatomic, assign) int pollID;
@property (nonatomic, strong) NSArray *items;

+ (NSArray *)pollsWithArray:(NSArray *)pollArray;
+ (id)pollWithDictionary:(NSDictionary *)pollDictionary;
@end
