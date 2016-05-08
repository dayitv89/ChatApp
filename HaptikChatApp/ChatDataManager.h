//
//  ChatDataModel.h
//  HaptikChatApp
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatDataManager : NSObject
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userImageUrl;
@property (nonatomic, strong) NSString *messageTime;
@property (nonatomic, strong) NSMutableArray *arrAllMessages;
@property (nonatomic, strong) NSMutableArray *arrCountMessages;
@property (nonatomic, strong) NSArray *arrSorted;
@property (nonatomic, strong) NSArray *arrAllUsersName;
- (NSArray *)sortedMessageCountWithUser:(NSArray *)result;
@end
