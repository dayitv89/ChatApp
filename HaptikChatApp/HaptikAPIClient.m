//
//  HaptikAPIClient.m
//  HaptikChatApp
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import "HaptikAPIClient.h"

#define BASE_URL @"http://haptik.co/android/"

@implementation HaptikAPIClient

+ (instancetype) sharedHTTPClient {
    static dispatch_once_t oncePredicate = 0;
    __strong static HaptikAPIClient *_sharedInstance = nil;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    return _sharedInstance;
}

-(instancetype) initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

@end
