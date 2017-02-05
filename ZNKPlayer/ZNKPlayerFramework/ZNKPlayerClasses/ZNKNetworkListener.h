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

typedef NS_ENUM(NSInteger,ZNKReachabilityStatus) {
    /**
     *  Not Reachability
     */
    ZNKReachabilityStatus_None =0x00,
    /**
     *  当前网络状态是WiFi
     */
    ZNKReachabilityStatus_WiFi =0x01,
    /**
     *  当前网络链接的是蜂窝网络 （2G、3G/4G）
     */
    ZNKReachabilityStatus_WWAN =0x06,
    /**
     *  蜂窝网络无连接行为(信号较弱)
     */
    ZNKReachabilityStatus_WWAN_None ,
    /**
     *  当前网络为2G网络 （GPRS/EDGE） 10~100 Kbps
     */
    ZNKReachabilityStatus_WWAN_2G =0x02,
    /**
     *  链接网络为3G 网络 （WCDMA/HSDPA）1~10Mbps
     */
    ZNKReachabilityStatus_WWAN_3G = 0x03,
    /**
     *  当前网络为4G 网络 （HRPD/LTE） 100Mbps
     */
    
    ZNKReachabilityStatus_WWAN_4G = 0x04,
    /**
     *  预留空间，apple API 还未更新 检测5G （蜂窝网络）
     */
    ZNKReachabilityStatus_WWAN_5G = 0x05,
    
};

@class ZNKNetworkStatus;
extern NSString * const kRYReachabilityStatusChangeNotifation;
static NSMutableArray * blockArray1=nil,* blockArray2=nil;
typedef void (^ConnectReachable)(ZNKNetworkStatus * reachable);
typedef void (^NotConnectReachable)(ZNKNetworkStatus * reachable);

@interface ZNKNetworkStatus : NSObject
/**
 *  网路连接类型
 */
@property (nonatomic, assign, readonly) SCNetworkConnectionFlags flags;
@property (nonatomic, assign, readonly) ZNKReachabilityStatus     status NS_AVAILABLE_IOS(7_0);
@property (nonatomic, assign, readonly, getter=isReachable) BOOL reachable;
/**
 *  运营商类型
 */
@property (nonatomic, strong) NSString     * carrierTypeName;
@property (nonatomic, copy) ConnectReachable  reachableBlock;
@property (nonatomic, copy) NotConnectReachable notReachableBlock;
@end

@interface ZNKNetworkListener : NSObject

@end
