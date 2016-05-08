//
//  HaptikAPIClient.h
//  HaptikChatApp
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HaptikAPIClient : AFHTTPSessionManager
+ (instancetype)sharedHTTPClient;
@end
