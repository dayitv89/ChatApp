//
//  ChatDataModel.m
//  HaptikChatApp
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import "ChatDataManager.h"

@implementation ChatDataManager

- (NSArray *)sortedMessageCountWithUser:(NSArray *)result {
    self.arrAllMessages = [NSMutableArray arrayWithArray:result];
    [self allUserName];
    return self.arrSorted;
}

- (void)allUserName {
    NSMutableArray *arrUsers = [[NSMutableArray alloc]init];
    [self.arrAllMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrUsers addObject:[obj objectForKey:@"username"]];
    }];
    //remove duplicate users
    self.arrAllUsersName = [[NSSet setWithArray:arrUsers] allObjects];
    [self findCountOfEachUserMessages];
}

- (void)findCountOfEachUserMessages {
    self.arrCountMessages = [[NSMutableArray alloc]init];
    for (NSString *userName in self.arrAllUsersName) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.username = %@",userName];
        NSArray *arr = [self.arrAllMessages filteredArrayUsingPredicate:predicate];
        NSDictionary *dict = @{@"userName" : userName, @"messageCount" : [NSNumber numberWithInteger:arr.count]};
        [self.arrCountMessages addObject:dict];
    }
    [self sortUsersWithMessageCount];
}

- (void)sortUsersWithMessageCount {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"messageCount" ascending:NO];
    self.arrSorted = [self.arrCountMessages sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end


