//
//  DDWindow.m
//  DingDingPod
//
//  Created by Justin.wang on 2018/2/8.
//  Copyright © 2018年 Justin.wang. All rights reserved.
//

#import "DDWindow.h"
#import "DDViewController.h"

static CGFloat const kDotWindowOutsideDiameter = 50.0f;
static CGFloat const kDotWindowInsideDiameter  = kDotWindowOutsideDiameter - 10;
static CGFloat const kDotWindowMargin          = 20.0f;

@implementation DDWindow

+ (instancetype)shareWindow {
    static DDWindow *shareWindow;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareWindow = [[DDWindow alloc] init];
    });
    return shareWindow;
}

- (instancetype)init {
    if (self  = [super init]) {
        self.hidden = NO;
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [UIViewController new];
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        self.frame = CGRectMake(kDotWindowMargin, kDotWindowMargin, kDotWindowOutsideDiameter, kDotWindowOutsideDiameter);
        CGFloat radius = kDotWindowOutsideDiameter / 2;
        self.layer.cornerRadius  = radius;
        self.layer.masksToBounds = YES;
        UIView *redView = [[UIView alloc] init];
        redView.center = CGPointMake(radius, radius);
        redView.bounds = CGRectMake(0, 0, kDotWindowInsideDiameter, kDotWindowInsideDiameter);
        redView.backgroundColor = [UIColor redColor];
        redView.layer.cornerRadius = kDotWindowInsideDiameter / 2;
        redView.layer.masksToBounds = YES;
        [self addSubview:redView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(panWithGesture:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark -Events

- (void)panWithGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:[[UIApplication sharedApplication] keyWindow]];
    self.center = CGPointMake(point.x +self.center.x, point.y + self.center.y);
    [gesture setTranslation:CGPointZero inView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)tap {
    DDViewController *vc = [[DDViewController alloc] init];
    self.hidden = YES;
    [vc setDismissBlock:^{
        self.hidden = NO;
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav
                                                                                 animated:YES
                                                                               completion:nil];
    
}

@end
