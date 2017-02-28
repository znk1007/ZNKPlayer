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
#import "Video.h"

#define M3U8URL @"http://edge.ctg.swiftserve.com.cn/live/XZXWHCBChina/xzxwhcb-live-rtmp-ingest/playlist.m3u8"

@interface ViewController ()

@property (nonatomic, strong) ZNKControlView *controlView;

@property (nonatomic, strong) ZNKPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[HTTPEngine sharedEngine] getRequestWithURL:@"http://c.m.163.com/nc/video/home/0-10.html" parameters:nil success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        NSLog(@"success %@",responseObject);
        if (responseObject) {
            Video *v = [[Video alloc] init];
            if (responseObject[@"videoHomeSid"]) {
                v.videoHomeSid = [ZNKFormat stringFormat:responseObject[@"videoHomeSid"]];
            }
            if (responseObject[@"videoList"] && [responseObject[@"videoList"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *videoList = [NSMutableArray array];
                NSArray *videoListArr = responseObject[@"videoList"];
                for (NSDictionary *videoListDict in videoListArr) {
                    VideoListModel *listModel = [[VideoListModel alloc] init];
                    listModel.cover = [ZNKFormat stringFormat:videoListDict[@"cover"]];
                    listModel.videoDescription = [ZNKFormat stringFormat:videoListDict[@"description"]];
                    listModel.length = [ZNKFormat stringFormat:videoListDict[@"length"]];
                    listModel.m3u8_url = [ZNKFormat stringFormat:videoListDict[@"m3u8_url"]];
                    listModel.m3u8Hd_url = [ZNKFormat stringFormat:videoListDict[@"m3u8Hd_url"]];
                    listModel.mp4_url = [ZNKFormat stringFormat:videoListDict[@"mp4_url"]];
                    listModel.mp4_Hd_url = [ZNKFormat stringFormat:videoListDict[@"mp4Hd_url"]];
                    listModel.playCount = [ZNKFormat stringFormat:videoListDict[@"playCount"]];
                    listModel.playersize = [ZNKFormat stringFormat:videoListDict[@"playersize"]];
                    listModel.ptime = [ZNKFormat stringFormat:videoListDict[@"ptime"]];
                    listModel.replyBoard = [ZNKFormat stringFormat:videoListDict[@"replyBoard"]];
                    listModel.replyid = [ZNKFormat stringFormat:videoListDict[@"replyid"]];
                    listModel.sectiontitle = [ZNKFormat stringFormat:videoListDict[@"sectiontitle"]];
                    listModel.title = [ZNKFormat stringFormat:videoListDict[@"title"]];
                    listModel.topicDesc = [ZNKFormat stringFormat:videoListDict[@"topicDesc"]];
                    listModel.topicImg = [ZNKFormat stringFormat:videoListDict[@"topicImg"]];
                    listModel.topicName = [ZNKFormat stringFormat:videoListDict[@"topicName"]];
                    listModel.topicSid = [ZNKFormat stringFormat:videoListDict[@"topicSid"]];
                    listModel.vid = [ZNKFormat stringFormat:videoListDict[@"vid"]];
                    listModel.videosource = [ZNKFormat stringFormat:videoListDict[@"videosource"]];
                    [videoList addObject:listModel];
                }
                v.videoList = videoList;
            }
            if (responseObject[@"videoSidList"] && [responseObject[@"videoSidList"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *videoSidList = [NSMutableArray array];
                NSArray *videoSidListArr = responseObject[@"videoSidList"];
                for (NSDictionary *videoSidDict in videoSidListArr) {
                    VideoSidListModel *sidListModel = [[VideoSidListModel alloc] init];
                    sidListModel.imgsrc = [ZNKFormat stringFormat:videoSidDict[@"imgsrc"]];
                    sidListModel.sid = [ZNKFormat stringFormat:videoSidDict[@"sid"]];
                    sidListModel.title = [ZNKFormat stringFormat:videoSidDict[@"title"]];
                    [videoSidList addObject:sidListModel];
                }
                v.videoSidList = videoSidList;
            }
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSLog(@"error %@",error.localizedDescription);
    }];
    
    
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
    
    ZNKWeakSelf(self);
    
    self.player = [ZNKPlayer sharedManager:NO];
    self.player.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.player];
    [self.player mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        make.top.equalTo(weakself.view.mas_top);
        make.width.mas_equalTo(width);
        make.trailing.equalTo(weakself.view.mas_trailing);
        make.height.equalTo(weakself.view.mas_width).multipliedBy(9.0f / 16.0f);
    }];
    [self.player setVideoUrl:M3U8URL scalingMode:ZNKMPMovieScalingModeAspectFit];
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
    [self.player play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
