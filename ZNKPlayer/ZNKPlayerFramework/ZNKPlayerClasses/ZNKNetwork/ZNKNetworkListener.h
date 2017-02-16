//
//  ZNKNetworkListener.h
//  ZNKPlayer
//
//  Created by 黄漫 on 2017/2/5.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <ifaddrs.h>


typedef NS_ENUM(NSInteger , NetWorkSatusType) {
    NetWorkSatusType_None =0x00,
    NetWorkSatusType_WiFi =0x01,
    NetWorkSatusType_2G = 0x02,
    NetWorkSatusType_3G = 0x03,
    NetWorkSatusType_4G = 0x04,
    /**
     *  暂不支持 检测5G类型 ，还未找到支持5G类型的
     */
    NetWorkSatusType_5G = 0x05,
    
};

typedef  void (^NetworkChangeStatusBlock)(NetWorkSatusType status);
//typedef void (^NetworkCallBackBlock)(NetWorkSatusType status,NSString * ssid);

 @interface ZNKNetworkListener : NSObject
/**
 *  创建单利设置管理类，包含网络，基本设置
 *
 *  @return 返回单利对象
 */
+ (instancetype)sharedManager;
/**网络变化回调*/
@property (nonatomic, copy) NetworkChangeStatusBlock netchangeNotifationBlock;
/**网络回调*/
//@property (nonatomic,copy) NetworkCallBackBlock block;
/**
 *  获取当前网络类型
 */
@property (nonatomic, assign) NetWorkSatusType  currentNetStatusType;
/**
 *  是否能够连接到WiFi网络
 *
 *  @return BOOL YES OR NO
 */
- (BOOL)canReachableViaWiFi;

/**
 *  蜂窝网络是否可达
 *
 *  @return 返回一个yes or no
 */
- (BOOL)canReachableViaWWAN;
/**
 *  获取最新的网络状态
 *
 *  @return NetWorkSatusType
 */

- (NetWorkSatusType )getReachablitySttatus;
/**
 * 监听当前网络状态类型 支持block 回调 返回一个 枚举类型的状态
 *
 *  @param complete 网络状态发生改变启用的回调处理
 */
- (void )getReachablityStatusWithChangeBlock:(void (^)(NetWorkSatusType status))complete;
#if 0
/**监听本地WiFi状态*/
- (void)listenLocalWifiBlock:(NetworkCallBackBlock)block;
#endif
@end
