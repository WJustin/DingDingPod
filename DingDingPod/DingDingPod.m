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

CHDeclareClass(CustomViewController)

CHOptimizedMethod(0, self, NSString*, CustomViewController,getMyName){
    return @"MonkeyDevPod";
}

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook(0, CustomViewController, getMyName);
}
