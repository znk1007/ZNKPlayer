//
//  ZNKNetworkSpeed.h
//  ZNKPlayer
//
//  Created by 黄漫 on 2017/2/5.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZNKNetworkSpeed : NSObject
/**单例模式*/
+ (ZNKNetworkSpeed *)sharedNetworkSpeed;
/**开始监听*/
- (void)start;
/**停止监听*/
- (void)stop;
/**下载速度block*/
- (void)downloadNetworkSpeed:(void(^)(NSString *speed))downloadNetworkSpeedBlock;
/**上传速度block*/
- (void)uploadNetworkSpeed:(void(^)(NSString *speed))uploadNetworkSpeedBlock;
@end
