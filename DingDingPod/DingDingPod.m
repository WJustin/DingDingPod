//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  DingDingPod.m
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright (c) 2018年 Justin.wang. All rights reserved.
//

#import "DingDingPod.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DDWindow.h"
#import "DDConfig.h"

#import "DDRevokeMessageHeader.h"
#import "DDRedPacketHeader.h"

#pragma mark - Setting

CHDeclareClass(UITabBarController);

CHOptimizedMethod0(self, void, UITabBarController, viewDidLoad) {
    CHSuper0(UITabBarController, viewDidLoad);
    [[DDWindow shareWindow] setDismissBlock:^{
        [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UINavigationController *nav = (UINavigationController *)obj;
            [nav popToRootViewControllerAnimated:YES];
        }];
    }];
}

CHConstructor{
    CHLoadLateClass(UITabBarController);
    CHHook0(UITabBarController, viewDidLoad);
}

#pragma mark - RevokeMessage

CHDeclareClass(YYLabel)
CHDeclareClass(DTMessageControllerDataSource)
CHDeclareClass(DTMessageBaseViewController)

CHOptimizedMethod1(self, void, DTMessageControllerDataSource, setMessages, NSArray<DTBizMessage *> *, messages) {
    if ([DDConfig shareConfig].canRevokeMsg) {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        __block DTBizMessage *preMessage;
        [messages enumerateObjectsUsingBlock:^(DTBizMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.recallStatus > 0 && !obj.isMine) {
                obj.recallStatus = 0;
                DTBizMessage *bizMessage = [[objc_getClass("DTBizMessage") alloc] init];
                bizMessage.senderId = obj.senderId;
                bizMessage.mId = obj.mId;
                bizMessage.isMine = obj.isMine;
                bizMessage.attachmentsType = obj.attachmentsType;
                bizMessage.content = obj.content;
                bizMessage.recallStatus = 1;
                if (preMessage.mId > 0 && preMessage.mId != obj.mId) {
                    [mutableArray addObject:obj];
                }
                [mutableArray addObject:bizMessage];
            } else {
                [mutableArray addObject:obj];
            }
            preMessage = obj;
        }];
        CHSuper1(DTMessageControllerDataSource, setMessages, mutableArray);
    } else {
        CHSuper1(DTMessageControllerDataSource, setMessages, messages);
    }
}

CHOptimizedMethod1(self, void, YYLabel, setAttributedText, NSAttributedString *, attributedText) {
    if ([DDConfig shareConfig].canRevokeMsg) {
        if ([attributedText.string containsString:@"撤回了一条消息"] &&
            ![attributedText.string containsString:@"已阻止"] &&
            ![attributedText.string containsString:@"你"]) {
            NSString *string = [NSString stringWithFormat:@"已阻止%@", attributedText.string];
            string =  [string stringByReplacingOccurrencesOfString:@"了一条" withString:@""];
            attributedText = [[NSAttributedString alloc] initWithString:string attributes:nil];
        }
    }
    CHSuper1(YYLabel, setAttributedText, attributedText);
}

CHOptimizedMethod1(self, void, DTMessageBaseViewController, receivedMessageNoticeUpdateNotification, id, arg1) {
    if ([DDConfig shareConfig].canRevokeMsg) {
        NSNotification *notify = arg1;
        NSArray *messages = notify.userInfo[@"WKUserInfoMessagesKey"];
        DTBizMessage *message = [messages lastObject];
        if (message && !isFalse) {
            [self.dataSource.messages lastObject].recallStatus = 1;
            self.dataSource.messages = self.dataSource.messages;
            [self refreshAllMessages];
        }
        isFalse = !isFalse;
        return;
    }
    CHSuper1(DTMessageBaseViewController, receivedMessageNoticeUpdateNotification, arg1);
}

CHConstructor{
    CHLoadLateClass(YYLabel);
    CHLoadLateClass(DTMessageControllerDataSource);
    CHLoadLateClass(DTMessageBaseViewController);
    
    CHHook1(YYLabel, setAttributedText);
    CHHook1(DTMessageControllerDataSource, setMessages);
    CHHook1(DTMessageBaseViewController, receivedMessageNoticeUpdateNotification);
}

#pragma mark - RedPacket

CHDeclareClass(DTConversationListDataSource)

CHOptimizedMethod5(self, void, DTConversationListDataSource, controller, id, arg1, didChangeObject, id, arg2, atIndex, unsigned long long, arg3, forChangeType, long long, arg4, newIndex, unsigned long long, arg5) {
    CHSuper5(DTConversationListDataSource, controller, arg1, didChangeObject, arg2, atIndex, arg3, forChangeType, arg4, newIndex, arg5);
    if (![DDConfig shareConfig].canAutoRobRedPacket) {
        return;
    }
    WKBizConversation *converdation = arg2;
    NSMutableArray *retArr = [[NSMutableArray alloc] init];
    NSString *attachmentsJson = converdation.latestMessage.attachmentsJson;
    if (attachmentsJson.length > 0) {
        NSData* jsonData = [attachmentsJson dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSNumber *contentType = dict[@"contentType"];
        NSMutableDictionary *retDict = [NSMutableDictionary new];
        retDict[@"contentType"] = contentType;
        NSArray *arr = dict[@"attachments"];
        if (arr.count > 0) {
            [arr enumerateObjectsUsingBlock:^(NSDictionary *attachmentDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *extension = attachmentDict[@"extension"];
                retDict[@"clusterid"] = extension[@"clusterid"];
                retDict[@"sid"] = extension[@"sid"];
                retDict[@"isMine"] = @([converdation.latestMessage isMine]);
                retDict[@"congrats"] = extension[@"congrats"];
                retDict[@"sname"] = extension[@"sname"];
                
                [retArr addObject:retDict];
            }];
        }
    }
    
    [retArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DTRedEnvelopServiceIMP *imp = [objc_getClass("DTRedEnvelopServiceFactory") defaultServiceIMP];
        long long sid = [obj[@"sid"] longLongValue];
        NSString *cluseId = obj[@"clusterid"];
        if (cluseId.length > 0){
            BOOL isMine = [obj[@"isMine"] boolValue];
            if (isMine && ![DDConfig shareConfig].canRobSelf) {
                return;
            }
            if ([DDConfig shareConfig].robDelay > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([DDConfig shareConfig].robDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [imp pickRedEnvelopCluster:sid clusterId:cluseId successBlock:nil failureBlock:nil];
                });
            } else {
                [imp pickRedEnvelopCluster:sid clusterId:cluseId successBlock:nil failureBlock:nil];
            }
        }
    }];
}

CHConstructor{
    CHLoadLateClass(DTConversationListDataSource);
    CHHook5(DTConversationListDataSource, controller, didChangeObject, atIndex, forChangeType, newIndex);
}



