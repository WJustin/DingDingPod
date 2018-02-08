//
//  DDEditorTableViewCell.m
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import "DDEditorTableViewCell.h"

NSString * const DDEditorTableViewCellId = @"DDEditorTableViewCellId";

@implementation DDEditorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = CGRectMake(150,
                                      0,
                                      self.contentView.frame.size.width - 150 - 30,
                                      self.contentView.frame.size.height);
}


- (void)didEditValueChanged:(UITextField *)textField {
    if (self.didEditValueChangedBlock) {
        self.didEditValueChangedBlock(textField.text);
    }
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"0";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.textAlignment = NSTextAlignmentRight;
        [_textField addTarget:self
                       action:@selector(didEditValueChanged:)
             forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_textField];
    }
    return _textField;
}

@end
