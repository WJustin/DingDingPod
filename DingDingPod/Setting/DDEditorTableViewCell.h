//
//  DDEditorTableViewCell.h
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const DDEditorTableViewCellId;

@interface DDEditorTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy  ) void (^didEditValueChangedBlock)(NSString *text);

@end
