//
//  DDSwitchTableViewCell.h
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const DDSwitchTableViewCellId;

@interface DDSwitchTableViewCell : UITableViewCell

@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, copy) void (^didSwitchBlock)(void);

@end
