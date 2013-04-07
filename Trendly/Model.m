//
//  Model.m
//  Trendly
//
//  Created by Michael Scaria on 4/6/13.
//  Copyright (c) 2013 Michael Scaria. All rights reserved.
//

#import "Model.h"
#import "Session.h"

#import "Poll.h"
#import "User.h"

#import "JSONKit.h"
#import "AFNetworking.h"

#define kRootURL @"http://rshack.herokuapp.com"

@implementation Model
static Model* _sharedInstance = nil;

+(Model*)sharedInstance {
    @synchronized([Model class])
    {
        if(!_sharedInstance)
            [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([Model class])
    {
        NSAssert(_sharedInstance == nil, @"Attempted to allocated a second instance of the Model singleton");
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

- (void)getPollsWithCompletion:(void (^)(NSArray *))completion {
    NSLog(@"getPollsWithCompletion");
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/polls", kRootURL]]];
    [req setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [req setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        if (data){
            NSArray *pollJSON = [[JSONDecoder decoder] objectWithData:data];
            NSArray *polls = [Poll pollsWithArray:pollJSON];
            completion(polls);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)signUpWithDictionary:(NSDictionary *)dictionary WithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSLog(@"signUpWithDictionary");
    NSString *body = [NSString stringWithFormat:@"username=%@&password=%@&first_name=%@&last_name=%@&email=%@", [dictionary objectForKey:@"username"], [dictionary objectForKey:@"password"], [dictionary objectForKey:@"first_name"], [dictionary objectForKey:@"last_name"], [dictionary objectForKey:@"email"]];

    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users", kRootURL]]];
    [req setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSData *data = (NSData *)responseObject;
        if (data){
            NSDictionary *userJSON = [[JSONDecoder decoder] objectWithData:data];
            User *user = [[User alloc] initWithDictionary:userJSON];
            [Session sharedInstance].user = user;
            if (success) success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) failure();
    }];
    [operation start];
}

- (void)logInWithDictionary:(NSDictionary *)dictionary WithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSLog(@"logInWithDictionary");
    NSString *body = [NSString stringWithFormat:@"username=%@&password=%@", [dictionary objectForKey:@"username"], [dictionary objectForKey:@"password"]];
    
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/login", kRootURL]]];
    [req setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSData *data = (NSData *)responseObject;
        if (data){
            NSArray *userJSON = [[JSONDecoder decoder] objectWithData:data];
            User *user = [[User alloc] initWithDictionary:[userJSON objectAtIndex:0]];
            NSLog(@"%d", user.userID);
            [Session sharedInstance].user = user;
            if (success) success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) failure();
    }];
    [operation start];
}

- (void)vote:(NSInteger)voteIndex onPoll:(int)pollID completion:(void (^)(void))completion {
    NSLog(@"vote");
    NSString *userString = ([[Session sharedInstance] user]) ? [NSString stringWithFormat:@"user_id=%d&", [Session sharedInstance].user.userID] : @"";
    NSString *body = [NSString stringWithFormat:@"%@vote_index=%d", userString, voteIndex];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/polls/%d/vote", kRootURL, pollID]]];
    [req setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:voteIndex forKey:[NSString stringWithFormat:@"Poll:%d", voteIndex]];
        [defaults synchronize];
        if (completion) completion();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}



@end
