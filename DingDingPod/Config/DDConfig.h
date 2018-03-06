//
//  DDConfig.h
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDConfig : NSObject

@property (nonatomic, assign) BOOL canRevokeMsg;
@property (nonatomic, assign) BOOL canAutoRobRedPacket;
@property (nonatomic, assign) BOOL canRobSelf;
@property (nonatomic, assign) NSInteger robDelay;
@property (nonatomic, assign) NSInteger steps;

+ (instancetype)shareConfig;

@end
