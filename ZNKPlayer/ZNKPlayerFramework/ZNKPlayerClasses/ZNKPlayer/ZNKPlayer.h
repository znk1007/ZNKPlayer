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

@interface ZNKPlayer : ZNKBaseView
/**播放器缩放模式*/
@property (nonatomic, assign) ZNKMPMovieScalingMode scalingMode;
/**单例设计模式*/
+ (ZNKPlayer *)sharedManager:(BOOL)kill;

@end
