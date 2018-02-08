//
//  DDRevokeMessageHeader.h
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#ifndef DDRevokeMessageHeader_h
#define DDRevokeMessageHeader_h

static BOOL isFalse;

@interface YYLabel

@property (nonatomic) NSAttributedString *attributedText;

@end

@interface DTBizMessage

@property(nonatomic) long long senderId;
@property(copy, nonatomic) NSString *localMid;
@property(nonatomic) long long mId;
@property(nonatomic) long long attachmentsType; //1
@property(nonatomic) long long recallStatus;
@property(copy, nonatomic) NSString *content;
@property(nonatomic) _Bool isMine;

@end

@interface DTMessageControllerDataSource

@property (nonatomic) NSArray<DTBizMessage *> *messages;

@end

@interface DTMessageBaseViewController

@property(retain, nonatomic) DTMessageControllerDataSource *dataSource;
- (void)receivedMessageNoticeUpdateNotification:(id)arg1;
- (void)refreshAllMessages;

@end

#endif /* DDRevokeMessageHeader_h */
