//
//  ViewController.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/4.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ViewController.h"
#import "ZNKControlView.h"
#import "ZNKMasonry.h"
#import "ZNKHeader.h"

@interface ViewController ()

@property (nonatomic, strong) ZNKControlView *controlView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.controlView = [[ZNKControlView alloc] init];
    [self.view addSubview:self.controlView];
    BOOL landscape = NO;
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        landscape = YES;
    }else{
        landscape = NO;
    }
    ZNKWeakSelf(self);
    [self.controlView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.left.right.equalTo(weakself.view).width.offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.equalTo(weakself.view.mas_width);
        if (landscape) {
            make.height.equalTo(self.view);
        }else{
            make.height.equalTo(self.view);
        }
    }];
    self.controlView.backgroundColor = [UIColor greenColor];
    self.controlView.titleLabel.text = @"测试哈哈哈哈哈哈哈";
    self.controlView.isLandscape = YES;
    self.controlView.resolustionType = ZNKResolustionTypeLDSDAndHD;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
