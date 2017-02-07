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
    ZNKWeakSelf(self);
    [self.controlView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.left.right.equalTo(weakself.view).width.offset(0);
        make.top.mas_equalTo(150);
        make.width.equalTo(weakself.view.mas_width);
        make.height.mas_equalTo(200);
    }];
    self.controlView.backgroundColor = [UIColor greenColor];
    self.controlView.titleLabel.text = @"测试哈哈哈哈哈哈哈";
    self.controlView.titleLabel.backgroundColor = [UIColor redColor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
