//
//  Item.m
//  Trendly
//
//  Created by Michael Scaria on 4/7/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "Item.h"

@implementation Item
@synthesize brand, imageURL, productID, name;
+ (NSArray *)itemsWithArray:(NSArray *)itemArray {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:itemArray.count];
    for (NSDictionary *dictionary in itemArray) {
        Item *item = [[self alloc] initWithDictionary:dictionary];
        [items addObject:item];
    }
    return [items copy];
}

+ (id)itemWithDictionary:(NSDictionary *)itemDictionary {
    Item *item = [[self alloc] initWithDictionary:itemDictionary];
    return item;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        for (NSString *key in dictionary) {
            id value = [dictionary objectForKey:key];
            if (!value) continue; //if value is null, skip
            if ([key isEqualToString:@"designer"]) {
                self.brand = value;
            }
            else if ([key isEqualToString:@"product_id"]) {
                self.productID = value;
            }
            else if ([key isEqualToString:@"product_image"]) {
                self.imageURL = value;
            }
            else if ([key isEqualToString:@"product_name"]) {
                self.name = value;
            }
            
        }
    }
    return self;
    
}
@end
