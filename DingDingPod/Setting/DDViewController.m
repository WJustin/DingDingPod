//
//  DDViewController.m
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import "DDViewController.h"
#import "DDConfig.h"

#import "DDSwitchTableViewCell.h"
#import "DDEditorTableViewCell.h"
#import "DDGoNextTableViewCell.h"

@interface DDViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.navigationItem.title = @"设置";
    UIBarButtonItem *close= [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [close setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil]
                         forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = close;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[DDSwitchTableViewCell class] forCellReuseIdentifier:DDSwitchTableViewCellId];
    [self.tableView registerClass:[DDEditorTableViewCell class] forCellReuseIdentifier:DDEditorTableViewCellId];
    [self.tableView registerClass:[DDGoNextTableViewCell class]
           forCellReuseIdentifier:DDGoNextTableViewCellId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self switchCellWithTitle:@"防撤回"
                                   andOn:[DDConfig shareConfig].canRevokeMsg
                                andBlock:^{
                  [DDConfig shareConfig].canRevokeMsg = ![DDConfig shareConfig].canRevokeMsg;
               }];
    } else if (indexPath.row == 1) {
        return [self switchCellWithTitle:@"自动抢红包"
                                   andOn:[DDConfig shareConfig].canAutoRobRedPacket
                                andBlock:^{
            [DDConfig shareConfig].canAutoRobRedPacket = ![DDConfig shareConfig].canAutoRobRedPacket;
        }];
    } else if (indexPath.row == 2) {
        return [self switchCellWithTitle:@"抢自己"
                                   andOn:[DDConfig shareConfig].canRobSelf
                                andBlock:^{
            [DDConfig shareConfig].canRobSelf = ![DDConfig shareConfig].canRobSelf;
        }];
    } else if (indexPath.row == 3) {
        DDEditorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DDEditorTableViewCellId];
        cell.textLabel.text = @"延迟秒数";
        cell.textField.text = @([DDConfig shareConfig].robDelay).stringValue;
        [cell setDidEditValueChangedBlock:^(NSString *text) {
            [DDConfig shareConfig].robDelay = [text integerValue];
        }];
        return cell;
    } else if (indexPath.row == 4) {
        DDEditorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DDEditorTableViewCellId];
        cell.textLabel.text = @"钉钉步数";
        cell.textField.text = @([DDConfig shareConfig].steps).stringValue;
        [cell setDidEditValueChangedBlock:^(NSString *text) {
            [DDConfig shareConfig].steps = [text integerValue];
        }];
        return cell;
    } else if (indexPath.row == 5) {
        DDGoNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DDGoNextTableViewCellId];
        cell.textLabel.text = @"我的GitHub";
        cell.detailTextLabel.text = @"star";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/WJustin/DingDingPod"]];
    }
}

#pragma mark - Dequeue

- (DDSwitchTableViewCell *)switchCellWithTitle:(NSString *)title
                                         andOn:(BOOL)on
                                      andBlock:(dispatch_block_t)block {
    DDSwitchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DDSwitchTableViewCellId];
    cell.textLabel.text = title;
    [cell.switchButton setOn:on];
    [cell setDidSwitchBlock:^{
        if (block) {
            block();
        }
    }];
    return cell;
}

#pragma mark - Events

- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


@end
