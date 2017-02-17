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
#import "ZNKNetworkListener.h"
#import "ZNKPlayer.h"

#define M3U8URL @"http://edge.ctg.swiftserve.com.cn/live/XZXWHCBChina/xzxwhcb-live-rtmp-ingest/playlist.m3u8"

@interface ViewController ()

@property (nonatomic, strong) ZNKControlView *controlView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
//    [[ZNKNetworkListener sharedManager] getReachablityStatusWithChangeBlock:^(NetWorkSatusType status) {
//        /*
//         NetWorkSatusType_None =0x00,
//         NetWorkSatusType_WiFi =0x01,
//         NetWorkSatusType_2G = 0x02,
//         NetWorkSatusType_3G = 0x03,
//         NetWorkSatusType_4G = 0x04,
//         NetWorkSatusType_5G = 0x05,
//         */
//        switch (status) {
//            case NetWorkSatusType_None:
//            {
//                NSLog(@"NetWorkSatusType_None");
//            }
//                break;
//            case NetWorkSatusType_WiFi:
//            {
//                NSLog(@"NetWorkSatusType_WiFi");
//            }
//                break;
//            case NetWorkSatusType_2G:
//            {
//                NSLog(@"NetWorkSatusType_2G");
//            }
//                break;
//            case NetWorkSatusType_3G:
//            {
//                NSLog(@"NetWorkSatusType_3G");
//            }
//                break;
//            case NetWorkSatusType_4G:
//            {
//                NSLog(@"NetWorkSatusType_4G");
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }];
    
    ZNKPlayer *player = [ZNKPlayer sharedManager:NO];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.controlView = [ZNKControlView new];
//    [self.view addSubview:self.controlView];
//    ZNKWeakSelf(self);
    
//    [self.controlView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
//        make.left.right.equalTo(weakself.view).width.offset(0);
//        make.top.equalTo(weakself.view.mas_top).offset(0);
//        make.width.equalTo(weakself.view.mas_width);
//        make.height.equalTo(weakself.view);
//    }];
//    self.controlView.titleLabel.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈";
//    self.controlView.backgroundColor = [UIColor greenColor];
//    self.controlView.ZNKSliderTap = ^(ZNKSlider *slider, CGFloat value){
//        NSLog(@"value is %f",value);
//        return value;
//    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
