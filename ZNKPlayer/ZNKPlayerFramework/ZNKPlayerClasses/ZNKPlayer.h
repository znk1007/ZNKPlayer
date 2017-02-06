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

typedef NS_ENUM(NSInteger, ZNKMPMoviePlaybackState) {
    ZNKMPMoviePlaybackStateStopped,             /**停止*/
    ZNKMPMoviePlaybackStatePlaying,             /**播放*/
    ZNKMPMoviePlaybackStatePaused,              /**暂停*/
    ZNKMPMoviePlaybackStateInterrupted,         /**中断*/
    ZNKMPMoviePlaybackStateSeekingForward,      /**快进*/
    ZNKMPMoviePlaybackStateSeekingBackward      /**快退*/
};

typedef NS_OPTIONS(NSUInteger, ZNKMPMovieLoadState) {
    ZNKMPMovieLoadStateUnknown        = 0,          /**未知状态*/
    ZNKMPMovieLoadStatePlayable       = 1 << 0,     /**可播放*/
    ZNKMPMovieLoadStatePlaythroughOK  = 1 << 1, /**播放将自动启动，在这种状态时，shouldautoplay=YES*/
    ZNKMPMovieLoadStateStalled        = 1 << 2, /**如果处于该状态，将自动暂停播放*/
};

typedef NS_ENUM(NSInteger, ZNKMPMovieFinishReason) {
    ZNKMPMovieFinishReasonPlaybackEnded,        /**播放结束*/
    ZNKMPMovieFinishReasonPlaybackError,        /**播放出错*/
    ZNKMPMovieFinishReasonUserExited            /**退出播放*/
};

// -----------------------------------------------------------------------------
// Thumbnails

typedef NS_ENUM(NSInteger, ZNKMPMovieTimeOption) {
    ZNKMPMovieTimeOptionNearestKeyFrame,        /**最近帧*/
    ZNKMPMovieTimeOptionExact                   /**精准*/
};

@interface ZNKPlayer : ZNKBaseView
/**播放器缩放模式*/
@property (nonatomic, assign) ZNKMPMovieScalingMode scalingMode;

@end
