//
//  Item.h
//  Trendly
//
//  Created by Michael Scaria on 4/7/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *name;

+ (NSArray *)itemsWithArray:(NSArray *)itemArray;
+ (id)itemWithDictionary:(NSDictionary *)itemDictionary;
@end
