//
//  ZNKPlayer.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/4.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKBaseView.h"

typedef NS_ENUM(NSInteger, ZNKMPMovieScalingMode) {
    ZNKMPMovieScalingModeNone,       /**不进行缩放*/
    ZNKMPMovieScalingModeAspectFit,  /**缩放尺寸直到一维拟合*/
    ZNKMPMovieScalingModeAspectFill, /**缩放尺寸，直到视图填补可见边界。且裁剪内容*/
    ZNKMPMovieScalingModeFill        /**非均匀缩放。按可是边界渲染*/
};

@interface ZNKTool : NSObject
/**单例模式*/
+ (ZNKTool *)sharedInstance:(BOOL)kill;
/**获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向*/
+ (void)startNotifyDeviceOrientation;
/**停止监听设备旋转*/
+ (void)endNotifyDeviceOrientation;
/**类清除缓存*/
- (void)cleanCache;
/**获取旋转方向*/
- (void)getDeviceOrientation:(void(^)(UIInterfaceOrientation orientation))completionHandler;
@end

@interface ZNKPlayer : ZNKBaseView
/**单例设计模式*/
+ (ZNKPlayer *)sharedManager:(BOOL)kill;
/**设置播放地址，缩放模式*/
- (void)setVideoUrl:(NSString *)url scalingMode:(ZNKMPMovieScalingMode)mode;
/**开始播放*/
- (void)play;
@end
