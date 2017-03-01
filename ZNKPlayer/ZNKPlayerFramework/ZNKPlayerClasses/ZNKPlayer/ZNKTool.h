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
+ (ZNKTool *)sharedInstance:(BOOL)kill;
/**获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向*/
/**获取旋转方向*/
+ (void)startNotifyDeviceOrientation:(void(^)(UIInterfaceOrientation orientation))completionHandler;
/**停止监听设备旋转*/
+ (void)endNotifyDeviceOrientation;
/**类清除缓存*/
- (void)cleanCache;

@end

@interface NSString (ZNKTool)
/**根据fontSize取得size*/
- (CGSize)sizeForFontSize:(CGFloat)fontSize;
@end
