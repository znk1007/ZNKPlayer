//
//  ZNKBrightnessView.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNKBrightnessView : UIView
/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL     isLockScreen;
/** cell上添加player时候，不允许横屏,只运行竖屏状态状态*/
@property (nonatomic, assign) BOOL     isAllowLandscape;

+ (instancetype)sharedBrightnessView;
@end
