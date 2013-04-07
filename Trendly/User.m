//
//  User.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize userID, username, firstName, lastName, email;
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        for (NSString *key in dictionary) {
            id value = [dictionary objectForKey:key];
            if (!value) continue; //if value is null, skip
            
            if ([key isEqualToString:@"id"]) {
                self.userID = [value intValue];
            }
            else if ([key isEqualToString:@"first_name"]) {
                self.firstName = value;
            }
            else if ([key isEqualToString:@"last_name"]) {
                self.lastName = value;
            }
            else if ([self respondsToSelector:NSSelectorFromString(key)]) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
    
}
@end
