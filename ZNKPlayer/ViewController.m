//
//  ViewController.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/4.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ViewController.h"
#import "ZNKControlView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZNKControlView *controlView = [[ZNKControlView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 200)];
    controlView.backgroundColor = [UIColor greenColor];
    controlView.titleLabel.text = @"测试哈哈哈哈哈哈哈";
    [self.view addSubview:controlView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
