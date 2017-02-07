//
//  ZNKHeader.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#ifndef ZNKHeader_h
#define ZNKHeader_h

#define HMLOG
#ifdef HMLOG
#define NSLog(fmt, ...) NSLog((@"Method_%s [Current_Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...) {}
#endif

// 监听TableView的contentOffset
#define kZNKPlayerViewContentOffset          @"contentOffset"

#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 监听TableView的contentOffset
#define kZNKPlayerViewContentOffset          @"contentOffset"
// player的单例
#define ZNKPlayerShared                      [ZNKBrightnessView sharedBrightnessView]
// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define ZNKPlayerSrcName(file)               [@"ZNKPlayer.bundle" stringByAppendingPathComponent:file]

#define ZNKPlayerFrameworkSrcName(file)      [@"Frameworks/ZNKPlayer.framework/ZNKPlayer.bundle" stringByAppendingPathComponent:file]

#define ZNKPlayerImage(file)                 [UIImage imageNamed:ZNKPlayerSrcName(file)] ? :[UIImage imageNamed:ZNKPlayerFrameworkSrcName(file)]

//弱引用 强引用
#define ZNKWeakSelf(type) __weak typeof(type) weak##type = type;
#define ZNKStrongSelf(type) __strong typeof(type) type = weak##type;

#endif /* ZNKHeader_h */
