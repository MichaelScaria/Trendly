//
//  Vote.h
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vote : NSObject
@property (nonatomic, assign) int voteIndex;
@property (nonatomic, assign) int poll;
@property (nonatomic, assign) int user;

+ (id)voteWithDictionary:(NSDictionary *)itemDictionary;

@end
