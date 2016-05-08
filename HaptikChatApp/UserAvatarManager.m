//
//  UserAvatarManager.m
//  HaptikChatApp
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import "UserAvatarManager.h"

@implementation UserAvatarManager

+ (JSQMessagesAvatarImage *)jsqUserAvatarImage:(NSString *)avatarUrl {
    JSQMessagesAvatarImage *avatarImage =[JSQMessagesAvatarImageFactory avatarImageWithImage:[self getImageFromURL:avatarUrl]
                                               diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    return avatarImage;
}

+ (UIImage *)getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    if (result) {
        return result;
    } else {
        return [UIImage imageNamed:@"haptik_logo"];
    }
}

@end
