//
//  UserMessageManager.m
//  HaptikChatApp
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import "UserMessageManager.h"

@implementation UserMessageManager

+ (JSQMessage *)jsqUserMessage:(NSDictionary *)messageDict {
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:[messageDict objectForKey:@"username"]
                                             senderDisplayName:[messageDict objectForKey:@"Name"]
                                                          date:[NSDate distantPast]
                                                          text:[messageDict objectForKey:@"body"]];
    return message;
}

@end
