//
//  UserAvatarManager.h
//  HaptikChatApp
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"

@interface UserAvatarManager : NSObject
+ (JSQMessagesAvatarImage *)jsqUserAvatarImage:(NSString *)avatarUrl;
@end
