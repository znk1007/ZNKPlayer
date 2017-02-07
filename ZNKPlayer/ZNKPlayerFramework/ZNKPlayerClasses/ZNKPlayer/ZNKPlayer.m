//
//  ZNKPlayer.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/4.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKPlayer.h"
#import "ZNKMasonry.h"
#import "ZNKHeader.h"
#import <IJKMediaFramework/IJKMediaFramework.h>



static const CGFloat ZNKPlayerAnimationTimeInterval             = 7.0f;
// 枚举值，包含水平移动方向和垂直移动方向
static const CGFloat ZNKPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

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

@interface ZNKPlayer ()
/**播放器*/
@property (nonatomic, strong) id<IJKMediaPlayback> player;
/**加载状态*/
@property (nonatomic, assign) ZNKMPMovieLoadState loadState;
/**播放状态*/
@property (nonatomic, assign) ZNKMPMoviePlaybackState playbacState;
/**播放完成原因*/
@property (nonatomic, assign) ZNKMPMovieFinishReason finishReason;
/**如果用户未设置，则使用临时父视图管理视图*/
@property (nonatomic, strong) UIView *tempContainView;
/**播放视图*/
@property (nonatomic, strong) UIView *playerView;
/**播放地址*/
@property (nonatomic, strong) NSURL *videoUrl;
/**是否是本地视频*/
@property (nonatomic, assign) BOOL isLocaleVideo;

@end

@implementation ZNKPlayer
/**单例设计模式*/
+ (ZNKPlayer *)sharedManager:(BOOL)kill{
    static ZNKPlayer *player = nil;
    @synchronized ([self class]) {
        if (kill) {
            NSLog(@"kill player manager");
            player = nil;
        }else{
            if (!player) {
                player = [[ZNKPlayer alloc] init];
            }
        }
    }
    return player;
}

- (void)initializePlayer{
    if ([self.videoUrl.scheme isEqualToString:@"file"]) {
        self.isLocaleVideo = YES;
    }else{
        self.isLocaleVideo = NO;
    }
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:_videoUrl withOptions:options];
    self.scalingMode = self.scalingMode == ZNKMPMovieScalingModeNone ? ZNKMPMovieScalingModeAspectFit : self.scalingMode;
    [_player setScalingMode:(IJKMPMovieScalingMode)self.scalingMode];
    
    self.playerView = [_player view];
    [self.playerView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(0);
    }];
    
}

#pragma mark - Setter / Getter

- (UIView *)tempContainView{
    if (!self.player) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    if (!_tempContainView) {
        _tempContainView = [[UIView alloc] initWithFrame:[self.player view].bounds];
    }
    return _tempContainView;
}


#pragma mark - 通知

/**添加通知*/
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayFirstVideoFrameRendered:)
                                                 name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification
                                               object:_player];
}

/**移除通知*/
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

- (void)moviePlayFirstVideoFrameRendered:(NSNotification*)notification{
    
}

@end