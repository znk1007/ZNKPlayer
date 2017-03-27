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

@implementation NSObject (ZNKTool)

- (dispatch_source_t)setTimeCounterUseOrigin:(BOOL)use totalTime:(NSTimeInterval)total completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    if (use) {
        __block NSString *timeString = @"00:00:00";
        __block long long hour = 0;
        __block long long minute = 0;
        __block long long second = 0;
        __block long long tempSecond = 0;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t time_source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(time_source, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(time_source, ^{
            if (second > ULLONG_MAX) {
                dispatch_source_cancel(time_source);
            }
            if (tempSecond > 59) {
                second = tempSecond % 60;
            }else{
                second = tempSecond;
            }
            minute = (tempSecond / 60) % 60;
            hour = second / 3600;
            
            if (hour > 0) {
                timeString = [NSString stringWithFormat:@"%02lld:%02lld:%02lld",hour,minute,second];
            }else{
                timeString = [NSString stringWithFormat:@"%02lld:%02lld",minute,second];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(timeString);
                }
            });
            tempSecond++;
        });
        dispatch_resume(time_source);
        return time_source;
    }else{
        __block NSTimeInterval time = 0;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t time_source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(time_source, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(time_source, ^{
            if (time > total) {
                dispatch_source_cancel(time_source);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(nil);
                }
            });
            time++;
        });
        dispatch_resume(time_source);
        return time_source;
    }
}

- (nullable NSString *)ascendingFormatHHMMSSFromSS:(NSTimeInterval)ss{
    NSString *hour = @"00";
    NSString *minute = @"00";
    NSString *second = @"00";
    NSString *totalTime = [NSString stringWithFormat:@"%lf",ss];
    NSInteger intSecond = [totalTime integerValue];
    if (intSecond < 60) {
        second = [NSString stringWithFormat:@"%02d",intSecond];
    }else if (intSecond >= 60 && intSecond < 60 * 60){
        minute = [NSString stringWithFormat:@"%02d",intSecond / 60];
        second = [NSString stringWithFormat:@"%02d",intSecond % 60];
    }else{
        hour = [NSString stringWithFormat:@"%02d",intSecond / 3600];
        minute = [NSString stringWithFormat:@"%02d",(intSecond % 3600) / 60];
        second = [NSString stringWithFormat:@"%02d",intSecond / 3600];
    }
    if ([hour isEqualToString:@"00"]) {
        return [NSString stringWithFormat:@"%@:%@",minute,second];
    }else{
        return [NSString stringWithFormat:@"%@:%@:%@",hour, minute, second];
    }

}

- (nullable NSString *)formatMMSSFromSS:(NSTimeInterval)ss{
    NSString *totalTime = [NSString stringWithFormat:@"%lf",ss];
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

@end

@implementation NSString (ZNKTool)

/**根据fontSize取得size*/
- (CGSize)sizeForFontSize:(CGFloat)fontSize{
    CGRect txtRect = [self boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return txtRect.size;
}

@end
