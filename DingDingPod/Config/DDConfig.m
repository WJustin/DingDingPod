//
//  DDConfig.m
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import "DDConfig.h"

@implementation DDConfig

+ (instancetype)shareConfig {
    static DDConfig *shareConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareConfig = [[DDConfig alloc] init];
    });
    return shareConfig;
}

@end
