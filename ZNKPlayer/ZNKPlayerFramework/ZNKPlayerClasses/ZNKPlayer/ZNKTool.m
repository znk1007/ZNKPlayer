//
//  ZNKTool.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/3/1.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKTool.h"

@interface ZNKTool ()
/**旋转方向block*/
@property (nonatomic, copy) void(^ZNKOrientationHandler)(UIInterfaceOrientation orientation);

@end

@implementation ZNKTool
+ (ZNKTool *)sharedInstance:(BOOL)kill{
    static ZNKTool *tool = nil;
    @synchronized ([self class]) {
        if (kill) {
            NSLog(@"kill player manager");
            tool = nil;
        }else{
            if (!tool) {
                tool = [[ZNKTool alloc] init];
            }
        }
    }
    return tool;
}

- (void)startNotifyDeviceOrientation:(void(^)(UIInterfaceOrientation orientation))completionHandler{
     _ZNKOrientationHandler = completionHandler;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

- (void)endNotifyDeviceOrientation{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}



- (void)cleanCache{
    if (_ZNKOrientationHandler) {
        _ZNKOrientationHandler = nil;
    }
}

- (void)onDeviceOrientationChange:(NSNotification *)notification{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (_ZNKOrientationHandler) {
        _ZNKOrientationHandler(interfaceOrientation);
    }
}

@end

@implementation NSString (ZNKTool)

/**根据fontSize取得size*/
- (CGSize)sizeForFontSize:(CGFloat)fontSize{
    CGRect txtRect = [self boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return txtRect.size;
}

@end
