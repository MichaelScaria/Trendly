//
//  Session.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "Session.h"

@implementation Session
@synthesize user;
static Session* _sharedInstance = nil;

+(Session*)sharedInstance {
    @synchronized([Session class])
    {
        if(!_sharedInstance)
            [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([Session class])
    {
        NSAssert(_sharedInstance == nil, @"Attempted to allocated a second instance of the Session singleton");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}
@end
