//
//  DDSwitchTableViewCell.m
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import "DDSwitchTableViewCell.h"

NSString * const DDSwitchTableViewCellId = @"DDSwitchTableViewCellId";

@implementation DDSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.switchButton.center = CGPointMake(self.frame.size.width - 40, self.contentView.center.y);
    self.switchButton.bounds = CGRectMake(0, 0, 60, 30);
}

- (void)didSwitch {
    if (self.didSwitchBlock) {
        self.didSwitchBlock();
    }
}

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchButton addTarget:self
                          action:@selector(didSwitch)
                forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchButton];
    }
    return _switchButton;
}

@end
