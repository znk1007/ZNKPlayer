//
//  ZNKTool.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/3/1.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNKTool : NSObject
/**单例模式*/
+ (ZNKTool * _Nonnull )sharedInstance:(BOOL)kill;
/**获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向*/
/**获取旋转方向*/
- (void)startNotifyDeviceOrientation:(void(^_Nullable)(UIInterfaceOrientation orientation))completionHandler;
/**停止监听设备旋转*/
- (void)endNotifyDeviceOrientation;
/**类清除缓存*/
- (void)cleanCache;

@end

@interface NSObject (ZNKTool)

- (nullable dispatch_source_t)setTimeCounterUseOrigin:(BOOL)use totalTime:(NSTimeInterval)total completionHandler:(void (^_Nullable)(NSString * _Nullable))completionHandler;

- (nullable NSString *)ascendingFormatHHMMSSFromSS:(NSTimeInterval)ss;

- (nullable NSString *)formatMMSSFromSS:(NSTimeInterval)ss;

@end

@interface NSString (ZNKTool)
/**根据fontSize取得size*/
- (CGSize)sizeForFontSize:(CGFloat)fontSize;
@end


