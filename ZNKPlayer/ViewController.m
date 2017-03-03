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
#import "VideoListCell.h"
#import "SVPullToRefresh.h"

#define M3U8URL @"http://edge.ctg.swiftserve.com.cn/live/XZXWHCBChina/xzxwhcb-live-rtmp-ingest/playlist.m3u8"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZNKControlView *controlView;

@property (nonatomic, strong) ZNKPlayer *player;

@property (nonatomic, strong) UITableView *videoTable;

@property (nonatomic, strong) NSArray *videoData;

@end

@implementation ViewController

- (UITableView *)videoTable{
    if (!_videoTable) {
        _videoTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _videoTable.delegate = self;
        _videoTable.dataSource = self;
    }
    return _videoTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.videoData = [NSArray array];
    [self.view addSubview:self.videoTable];
    ZNKWeakSelf(self);
    [self.videoTable addPullToRefreshWithActionHandler:^{
        [Video videoData:^(Video *data) {
            weakself.videoData = data.videoList;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.videoTable reloadData];
                [weakself.videoTable.pullToRefreshView stopAnimating];
            });
        }];
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
    
//    ZNKWeakSelf(self);
//    
//    self.player = [ZNKPlayer sharedManager:NO];
//    self.player.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:self.player];
//    [self.player mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
//        make.top.equalTo(weakself.view.mas_top);
//        make.width.mas_equalTo(width);
//        make.trailing.equalTo(weakself.view.mas_trailing);
//        make.height.equalTo(weakself.view.mas_width).multipliedBy(9.0f / 16.0f);
//    }];
//    [self.player setVideoUrl:M3U8URL scalingMode:ZNKMPMovieScalingModeAspectFit];
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
//    [self.player play];
    [self.videoTable triggerPullToRefresh];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videoData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"VideoListCellId";
    VideoListCell *cell = (VideoListCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    VideoListModel *model = self.videoData[indexPath.row];
    ZNKWeakSelf(self);
    [cell refreshCell:model atIndexPath:indexPath playAction:^(VideoPlayButton *btn) {
        NSLog(@"btn tag %d",btn.indexPath.row);
        VideoListCell *currentCell = (VideoListCell *)[tableView cellForRowAtIndexPath:btn.indexPath];
        [weakself currentCell:currentCell currentModel:btn];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListModel *model = self.videoData[indexPath.row];
    CGFloat titleHeight = [model.title sizeForFontSize:18].height;
    CGFloat descHeight = [model.videoDescription sizeForFontSize:15].height;
    return titleHeight + descHeight + 120;
}

- (void)currentCell:(VideoListCell *)cell currentModel:(VideoPlayButton *)btn{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor greenColor];
    [cell.videoImageView addSubview:view];
    [view mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(cell.videoImageView);
    }];
}

@end
