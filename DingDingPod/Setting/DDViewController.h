//
//  DDViewController.h
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDViewController : UIViewController

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
