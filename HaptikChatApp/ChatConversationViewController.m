//
//  ChatConversationViewController.m
//  HaptikChatApp
//
//  Created by Pramod Sharma on 07/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import "ChatConversationViewController.h"
#import "HaptikAPIClient.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UserMessageManager.h"
#import "UserAvatarManager.h"
#import "ChatDataManager.h"

@interface ChatConversationViewController ()
{
    NSMutableArray *arrChatData;
    NSMutableArray *arrUserAvatar;
    NSArray *arrSortedUsersWithMessageCount;
}
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@end

@implementation ChatConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //I am using self as "Shawn"
    self.senderId = @"shawn-t";
    self.title = @"Conversation";
    arrChatData = [[NSMutableArray alloc]init];
    arrUserAvatar = [[NSMutableArray alloc]init];
    [self setupForMessageUI];
    [self addRightSideNavBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchAllMessagesFromServer];
}

- (void)addRightSideNavBtn {
    UIButton *btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPlus.frame = CGRectMake(0, 13, 100, 19);
    [btnPlus setTitle:@"Two People" forState:UIControlStateNormal];
    [btnPlus setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnPlus addTarget:self action:@selector(seeMostConversationPeople:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtns = [[UIBarButtonItem alloc]initWithCustomView:btnPlus];
    self.navigationItem.rightBarButtonItem = rightBtns;
}

- (void)setupForMessageUI {
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    self.inputToolbar.hidden = true;
}

- (void)seeMostConversationPeople:(id)sender {
    NSMutableString *twoUserWithGreaterMsgCount = [[NSMutableString alloc]init];
    for (int i = 0; i < 2; i++) {
        NSDictionary *dic = [arrSortedUsersWithMessageCount objectAtIndex:i];
        [twoUserWithGreaterMsgCount appendString:[NSString stringWithFormat:@"%d. %@(Mesage count - %@)\n",i+1,[dic objectForKey:@"userName"],[dic objectForKey:@"messageCount"]]];
    }
    [self showAlertMessage:twoUserWithGreaterMsgCount];
}

/*!
 *  @author Pramod Sharma, 16-05-07 09:05:05
 *
 *  @brief Fetch messages from server
 *
 *  @since <#1.0#>
 */
- (void)fetchAllMessagesFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    HaptikAPIClient *apiClient = [HaptikAPIClient sharedHTTPClient];
    [apiClient GET:@"test_data" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        NSArray *arrMessages = [responseObject objectForKey:@"messages"];
        [self parseData:arrMessages];
        ChatDataManager *chatManager =[[ChatDataManager alloc]init];
         arrSortedUsersWithMessageCount = [chatManager sortedMessageCountWithUser:arrMessages];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)parseData:(NSArray *)arrMessages {
    [arrChatData removeAllObjects];
    [arrMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrChatData addObject:[UserMessageManager jsqUserMessage:obj]];
        [arrUserAvatar addObject:[UserAvatarManager jsqUserAvatarImage:[obj objectForKey:@"image-url"]]];
    }];
    [self.collectionView reloadData];
}

- (void)showAlertMessage:(NSString *)msgStr {
    UIAlertController * alert = [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:msgStr
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [arrChatData objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [arrChatData removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [arrChatData objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [arrUserAvatar objectAtIndex:indexPath.row];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [arrChatData objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [arrChatData objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [arrChatData objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrChatData count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [arrChatData objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *currentMessage = [arrChatData objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [arrChatData objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
