//
//  ZNKNetworkSpeed.h
//  ZNKPlayer
//
//  Created by 黄漫 on 2017/2/5.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

// 88kB/s
extern NSString *const ZNKDownloadNetworkSpeedNotificationKey;
// 2MB/s
extern NSString *const ZNKUploadNetworkSpeedNotificationKey;

@interface ZNKNetworkSpeed : NSObject
@property (nonatomic, copy, readonly) NSString * downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString * uploadNetworkSpeed;

+ (instancetype)sharedNetworkSpeed;
- (void)start;
- (void)stop;
@end
