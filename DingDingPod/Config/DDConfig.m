//
//  DDConfig.m
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import "DDConfig.h"

static NSString * const kCanRevokeMsgKey        = @"canRevokeMsg";
static NSString * const kCanAutoRobRedPacketKey = @"canAutoRobRedPacket";
static NSString * const kCanRobSelfKey          = @"canRobSelf";
static NSString * const kRobDelayKey            = @"robDelay";
static NSString * const kStepsKey               = @"steps";

@implementation DDConfig

+ (instancetype)shareConfig {
    static DDConfig *shareConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareConfig = [[DDConfig alloc] init];
    });
    return shareConfig;
}

#pragma mark - Setter

- (void)setCanRevokeMsg:(BOOL)canRevokeMsg {
    [[NSUserDefaults standardUserDefaults] setBool:canRevokeMsg forKey:kCanRevokeMsgKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCanAutoRobRedPacket:(BOOL)canAutoRobRedPacket {
    [[NSUserDefaults standardUserDefaults] setBool:canAutoRobRedPacket forKey:kCanAutoRobRedPacketKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCanRobSelf:(BOOL)canRobSelf {
    [[NSUserDefaults standardUserDefaults] setBool:canRobSelf forKey:kCanRobSelfKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setRobDelay:(NSInteger)robDelay {
    [[NSUserDefaults standardUserDefaults] setObject:@(robDelay) forKey:kRobDelayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSteps:(NSInteger)steps {
    [[NSUserDefaults standardUserDefaults] setObject:@(steps) forKey:kStepsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Getter

- (BOOL)canRevokeMsg {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kCanRevokeMsgKey];
}

- (BOOL)canAutoRobRedPacket {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kCanAutoRobRedPacketKey];
}

- (BOOL)canRobSelf {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kCanRobSelfKey];
}

- (NSInteger)robDelay {
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kRobDelayKey];
    return [num integerValue];
}

- (NSInteger)steps {
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kStepsKey];
    return [num integerValue];
}

@end
