//
//  ZNKPlayer.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/4.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKBaseView.h"
#import "ZNKTool.h"
@class ZNKControlView;
typedef NS_ENUM(NSInteger, ZNKMPMovieScalingMode) {
    ZNKMPMovieScalingModeNone,       /**不进行缩放*/
    ZNKMPMovieScalingModeAspectFit,  /**缩放尺寸直到一维拟合*/
    ZNKMPMovieScalingModeAspectFill, /**缩放尺寸，直到视图填补可见边界。且裁剪内容*/
    ZNKMPMovieScalingModeFill        /**非均匀缩放。按可是边界渲染*/
};

@interface ZNKPlayer : ZNKBaseView
/**是否自动播放*/
@property (nonatomic, assign) BOOL shouldAutoPlay;
/**控制视图*/
@property (nonatomic, readonly) ZNKControlView *controlView;
///**单例设计模式*/
+ (ZNKPlayer *)sharedManager:(BOOL)kill;
/**设置播放地址，缩放模式默认ZNKMPMovieScalingModeAspectFit*/
- (void)startWithVideoUrl:(NSString *)url;
/**设置播放地址，缩放模式*/
- (void)startWithVideoUrl:(NSString *)url scalingMode:(ZNKMPMovieScalingMode)mode;
/**开始播放*/
- (void)play;
@end
