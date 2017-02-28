//
//  Video.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/28.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "Video.h"

@implementation ZNKFormat

+ (NSString *)stringFormat:(id)obj{
    return [NSString stringWithFormat:@"%@",obj];
}

@end

@implementation Video

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoList = [NSArray array];
        self.videoSidList = [NSArray array];
    }
    return self;
}

@end

@implementation VideoSidListModel



@end

@implementation VideoListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.videoDescription = value;
    }
}
@end
