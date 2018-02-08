//
//  DDWindow.h
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDWindow : UIWindow

@property (nonatomic, copy) void (^dismissBlock)(void);

+ (instancetype)shareWindow;

@end
