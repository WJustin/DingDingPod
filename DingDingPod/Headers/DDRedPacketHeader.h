//
//  DDRedPacketHeader.h
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#ifndef DDRedPacketHeader_h
#define DDRedPacketHeader_h

#import <Foundation/Foundation.h>

@interface WKBizMessage

@property(nonatomic) NSString *attachmentsJson;
@property(nonatomic) _Bool isMine;

@end

@interface WKBizConversation

@property(nonatomic) NSString *latestMessageJson;//最新一条消息的json字符串
@property(nonatomic) WKBizMessage *latestMessage;//最新一条消息

@end

@interface DTRedEnvelopServiceFactory

+ (id)createServiceIMPWithPersistence:(id)arg1 network:(id)arg2;
+ (id)defaultServiceIMP;

@end

@interface DTRedEnvelopServiceIMP

- (void)pickRedEnvelopCluster:(long long)sid
                    clusterId:(NSString *)arg2
                 successBlock:(id)arg3
                 failureBlock:(id)arg4;

@end

@interface DTConversationListDataSource

- (void)controller:(id)arg1
   didChangeObject:(id)arg2
           atIndex:(unsigned long long)arg3
     forChangeType:(long long)arg4
          newIndex:(unsigned long long)arg5;

@end


#endif /* DDRedPacketHeader_h */
