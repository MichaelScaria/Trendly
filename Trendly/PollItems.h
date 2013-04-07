//
//  PollItems.h
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PollItems : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSArray *votes;

+ (id)pollItemWithDictionary:(NSDictionary *)itemDictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
