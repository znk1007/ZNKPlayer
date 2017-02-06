//
//  ZNKNetworkListener.m
//  ZNKPlayer
//
//  Created by 黄漫 on 2017/2/5.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKNetworkListener.h"
#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#ifdef HMLOG
#define NSLog(fmt, ...) NSLog((@"Method_%s [Current_Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...) 
#endif

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
extern NSString * const kZNKReachabilityStatusChangeNotifation;
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

/**
 *  是否支持从蜂窝网络接入网络
 */
@property (nonatomic, assign) BOOL reachableOnWWAN;

/**
 *  是否可以链接WiFi
 *
 *  @return 布尔值
 */
- (BOOL)isReachableViaWiFi;
/**
 移动网络
 */
- (BOOL)isReachableViaWWAN;
/**
 *  开始谅连接
 *
 *  @return <#return value description#>
 */
+ (instancetype)reachability;
/**
 *  从本地WiFi链接
 *
 *  @return <#return value description#>
 */
+ (instancetype)reachabilityForLocalWifi;
/**
 * 主机地址 hostName  e.g "https://www.apple.com"
 *
 *  @param hostname host domain
 *
 *  @return <#return value description#>
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostname;
/**
 *  接受一个结构体的ip 地址  e.g 192.168.0.0
 *
 *  @param hostAddress ip 地址
 *
 *  @return <#return value description#>
 */
+ (instancetype)reachabilityWithIPAddress:(const struct sockaddr_in *)hostAddress;
/**
 *  用一个SCNetworkConnectionRef  对象初始化该类
 *
 *  @param ref <#ref description#>
 *
 *  @return <#return value description#>
 */
- (ZNKNetworkStatus *)initWithReachabilityCNNetRef:(SCNetworkReachabilityRef)ref;


@end

NSString * const  kZNKReachabilityStatusChangeNotifation = @"kZNKReachabilityStatusChangeNotifation";
static ZNKNetworkStatus * __netWorkManager = nil;
static CTTelephonyNetworkInfo * ZNKTelphoyNet(){
    static CTTelephonyNetworkInfo * cttel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        cttel = [CTTelephonyNetworkInfo new];
    });
    return cttel;
}
static  ZNKReachabilityStatus  ZNKReachabilityStatusFlags(SCNetworkConnectionFlags flags, BOOL alloWWAN){
    
    if ((flags & kSCNetworkReachabilityFlagsReachable)==0x00) {
        return ZNKReachabilityStatus_None;
    }
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) && (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return ZNKReachabilityStatus_None;
    }
    if ((flags & kSCNetworkReachabilityFlagsIsLocalAddress)) {
        return ZNKReachabilityStatus_None;
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && alloWWAN) {
        
        
        if (!ZNKTelphoyNet().currentRadioAccessTechnology) {
            return ZNKReachabilityStatus_WWAN_None;
        }
        NSString * status = ZNKTelphoyNet().currentRadioAccessTechnology;
        if (!status) {
            return ZNKReachabilityStatus_WWAN_None;
        }
        static NSDictionary * dic;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dic = @{CTRadioAccessTechnologyGPRS:@(ZNKReachabilityStatus_WWAN_2G), // 2.5G 171Kbps
                    CTRadioAccessTechnologyEdge:
                        @(ZNKReachabilityStatus_WWAN_2G),//2.75G 384Kbps
                    CTRadioAccessTechnologyWCDMA:
                        @(ZNKReachabilityStatus_WWAN_3G),//3G 3.6Mbps/384Kbps
                    CTRadioAccessTechnologyHSDPA:
                        @(ZNKReachabilityStatus_WWAN_3G),//3.5G 14.4Mbps/384Kbps
                    CTRadioAccessTechnologyHSUPA:
                        @(ZNKReachabilityStatus_WWAN_3G),
                    // 3.75G 14.4Mbps/ 5.76Mbps
                    CTRadioAccessTechnologyCDMA1x:
                        @(ZNKReachabilityStatus_WWAN_3G),// 2.5G
                    CTRadioAccessTechnologyCDMAEVDORev0:
                        @(ZNKReachabilityStatus_WWAN_3G),
                    CTRadioAccessTechnologyCDMAEVDORevA:
                        @(ZNKReachabilityStatus_WWAN_3G),
                    CTRadioAccessTechnologyCDMAEVDORevB:
                        @(ZNKReachabilityStatus_WWAN_3G),
                    CTRadioAccessTechnologyeHRPD:
                        @(ZNKReachabilityStatus_WWAN_3G),
                    CTRadioAccessTechnologyLTE:
                        @(ZNKReachabilityStatus_WWAN_4G),//LTE :3.9G 150M/75M LTE-advanced:4G 300M/150M
                    
                    };
        });
        NSNumber * number = dic[status];
        if (number) {
            return number.unsignedIntegerValue;
        }
        return ZNKReachabilityStatus_WWAN_None;
    }
    return ZNKReachabilityStatus_WiFi;
}

static void ZNKReachablityCallback(SCNetworkReachabilityRef target,SCNetworkReachabilityFlags flags, void * info){
    ZNKNetworkStatus * self = ((__bridge ZNKNetworkStatus *)info);
    
    for (ConnectReachable blockcon in blockArray1) {
        if (blockcon) {
            dispatch_async(dispatch_get_main_queue(), ^{
                blockcon(self);
            });
            
        }
    }
    for (NotConnectReachable nonBlock in blockArray2) {
        if (nonBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                nonBlock(self);
            });
            
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kZNKReachabilityStatusChangeNotifation object:self];
    });
}

@interface ZNKNetworkStatus ()
{
    NSRecursiveLock  * _netLock;
    NSLock * _lock;
    
}
@property (nonatomic, assign) SCNetworkReachabilityRef ref;

@property (nonatomic, assign) BOOL schedule;

@property (nonatomic, strong) CTTelephonyNetworkInfo * netWorkInfo;

@property (nonatomic, strong) NSRecursiveLock   * netLock;

@end

@implementation ZNKNetworkStatus

+ (dispatch_queue_t)shareSerialQueue{
    static dispatch_queue_t serialQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue  = dispatch_queue_create("www.znk.com.ZNKReachability", NULL);
        
    });
    return serialQueue;
}
- (NSString *)getCurrentCarrier{
    
    return ZNKTelphoyNet().subscriberCellularProvider.carrierName;
    
}
- (NSString *)carrierTypeName{
    return [self getCurrentCarrier];
    
}
- (NSRecursiveLock *)netLock{
    if (_netLock==nil) {
        _netLock = [[NSRecursiveLock alloc]init];
        
    }
    return _netLock;
}
- (instancetype)init{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    struct sockaddr_in6 localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin6_len = sizeof(localWifiAddress);
    localWifiAddress.sin6_family = AF_INET6;
    //    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
#else
    
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
#endif
    
    //    struct sockaddr_in zero_addr;
    //    bzero(&zero_addr, sizeof(zero_addr));
    //    zero_addr.sin_len = sizeof(zero_addr);
    //    zero_addr.sin_family =AF_INET;
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&localWifiAddress);
    return [self initWithReachabilityCNNetRef:ref];
    
}
- (ZNKNetworkStatus *)initWithReachabilityCNNetRef:(SCNetworkReachabilityRef)ref{
    if (!ref) {
        return nil;
    }
    self = super.init;
    if (!self) {
        return nil;
    }
    _ref = ref;
    _reachableOnWWAN=YES;
    
    //    self.schedule = YES;
    if (NSFoundationVersionNumber >=NSFoundationVersionNumber_iOS_7_0) {
        _netWorkInfo = ZNKTelphoyNet();
        
        
    }
    return self;
    
}
- (void)setSchedule:(BOOL)schedule{
    if (_schedule==schedule) {
        return;
    }
    _schedule = schedule;
    
    if (schedule) {
        SCNetworkReachabilityContext context = {0,(__bridge void *)self,NULL,NULL,NULL};
        if (SCNetworkReachabilitySetCallback(self.ref, ZNKReachablityCallback, &context)) {
            NSLog(@"设置回调成功");
            //            CFRunLoopRef runloop  = CFRunLoopGetMain();
            //
            //            if(SCNetworkReachabilityScheduleWithRunLoop(self.ref, runloop, kCFRunLoopCommonModes)) {
            ////                SCNetworkReachabilitySetCallback(self.ref, NULL, NULL);
            //                NSLog(@"设置成功");
            //            }else{
            //                NSLog(@"设置runloop 失败");
            //                SCNetworkReachabilitySetCallback(self.ref, NULL, NULL);
            //            }
        }
        else{
            NSLog(@"回调设置失败");
        }
        
        SCNetworkReachabilitySetDispatchQueue(self.ref, [self.class shareSerialQueue]);
        
    }else{
        SCNetworkReachabilitySetDispatchQueue(self.ref, NULL);
    }
}
- (BOOL)isReachableViaWiFi{
    SCNetworkConnectionFlags flags;
    if (SCNetworkReachabilityGetFlags(self.ref, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable)) {
            
#if TARGET_OS_IPHONE
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                return NO;
            }
#endif
            return YES;
        }
    }
    return NO;
}
- (BOOL)isReachableViaWWAN{
#if TARGET_OS_IPHONE
    SCNetworkReachabilityFlags flags =0;
    if (SCNetworkReachabilityGetFlags(self.ref, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable)) {
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                return YES;
            }
        }
    }
#endif
    return NO;
}
- (SCNetworkConnectionFlags)flags{
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(self.ref, &flags);
    return flags;
}
- (ZNKReachabilityStatus)status{
    
    ZNKReachabilityStatus status =ZNKReachabilityStatusFlags(self.flags, self.reachableOnWWAN);
    
    
    return status;
}
- (BOOL)isReachable{
    return self.status !=ZNKReachabilityStatus_None;
}
+ (instancetype)reachability{
    return [self shareInstance];
    
}
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __netWorkManager = [[self alloc]init];
        blockArray1 = [NSMutableArray array];
        blockArray2 = [NSMutableArray array];
        
    });
    return __netWorkManager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __netWorkManager = [super allocWithZone:zone];
    });
    return __netWorkManager;
}
+ (instancetype)reachabilityWithHostName:(NSString *)hostname{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    if (ref) {
        id reachability = [[self shareInstance]initWithReachabilityCNNetRef:ref];
        return reachability;
    }
    return nil;
    
}
+ (instancetype)reachabilityForLocalWifi{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    struct sockaddr_in6 localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin6_len = sizeof(localWifiAddress);
    localWifiAddress.sin6_family = AF_INET6;
    //    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
#else
    
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
#endif
    ZNKNetworkStatus *net = [self reachabilityWithIPAddress:&localWifiAddress];
    net.reachableOnWWAN = NO;
    return net;
}
+ (instancetype)reachabilityWithIPAddress:(const struct sockaddr_in *)hostAddress{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    return [[self shareInstance] initWithReachabilityCNNetRef:ref];
}
- (void)setReachableBlock:(ConnectReachable)reachableBlock{
    if (_reachableBlock!=reachableBlock) {
        _reachableBlock = reachableBlock;
    }
    [blockArray1 addObject:_reachableBlock];
    NSLog(@"count1 = %d",blockArray1.count);
    self.schedule = (self.reachableBlock!=nil);
}
- (void)setNotReachableBlock:(NotConnectReachable)notReachableBlock{
    //    _notReachableBlock = [notReachableBlock copy];
    if (_notReachableBlock != notReachableBlock) {
        _notReachableBlock = notReachableBlock;
    }
    [blockArray2 addObject:_notReachableBlock];
    NSLog(@"count2 = %d",blockArray2.count);
    self.schedule = (self.notReachableBlock!=nil);
    
}

- (void)dealloc{
    
    CFRelease(self.ref);
    self.reachableBlock = nil;
    self.notReachableBlock = nil;
    self.schedule = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

@interface ZNKNetworkListener ()
@property (nonatomic, strong) ZNKNetworkStatus * netstatusManager;
@property (nonatomic,strong ) NSNumber * currentNumberType;
@property (nonatomic,strong) ZNKNetworkStatus * netManager;
@end

@implementation ZNKNetworkListener
+ (instancetype)sharedManager{
    static ZNKNetworkListener * __preferance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __preferance = [[self.class alloc]init];
    });
    return __preferance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [super allocWithZone:zone];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        
        self.netManager = [ZNKNetworkStatus reachabilityForLocalWifi];
        self.netManager.reachableBlock= ^(ZNKNetworkStatus * man){
            NSLog(@"======dfdfdfd");
            weakSelf.currentNumberType = [NSNumber numberWithInteger:man.status];
            NetWorkSatusType stat =   [weakSelf getReachablitySttatus];
            if (weakSelf.block) {
                weakSelf.block(stat,@"ddd");
            }
            
        };
        self.netstatusManager  = [ZNKNetworkStatus reachabilityWithHostName:@"https://www.baidu.com"];
        self.netstatusManager.reachableBlock = ^(ZNKNetworkStatus * manager){
            if (manager.status==ZNKReachabilityStatus_WiFi) {
                NSLog(@"current sttus is wifi");
            }else {
                NSLog(@"无网络");
                
            }
            weakSelf.currentNumberType = [NSNumber numberWithInteger:manager.status];
            NetWorkSatusType stat =   [weakSelf getReachablitySttatus];
            if (weakSelf.netchangeNotifationBlock) {
                weakSelf.netchangeNotifationBlock(stat);
            }
        };
    }
    return self;
}

- (BOOL)canReachableViaWiFi{
    
    if ([self.netstatusManager isReachableViaWiFi]) {
        return YES;
    }
    return NO;
}
- (BOOL)canReachableViaWWAN{
    if ([self.netstatusManager isReachableViaWWAN]) {
        return YES;
    }
    return NO;
}

//- (ZNKNetStatusManager *)netstatusManager{
//    if (!_netstatusManager) {
//        _netstatusManager  = [ZNKNetStatusManager reachabilityWithHostName:@"http://www.baidu.com"];
//
//
//    }
//    return _netstatusManager;
//}
- (NetWorkSatusType )getReachablitySttatus{
    ZNKReachabilityStatus  status = self.currentNumberType.unsignedIntegerValue;
    if ([self canReachableViaWiFi] || [self canReachableViaWWAN]) {
        status = self.netstatusManager.status;
        
    }
    switch (status) {
        case ZNKReachabilityStatus_None:
            return NetWorkSatusType_None;
            
        case ZNKReachabilityStatus_WiFi:
            return NetWorkSatusType_WiFi;
            
        case ZNKReachabilityStatus_WWAN:
            return NetWorkSatusType_WiFi;
            
        case ZNKReachabilityStatus_WWAN_2G:
            return NetWorkSatusType_2G;
            
        case ZNKReachabilityStatus_WWAN_3G:
            return NetWorkSatusType_3G;
            
        case ZNKReachabilityStatus_WWAN_4G:
            return NetWorkSatusType_4G;
            
        case ZNKReachabilityStatus_WWAN_5G:
            return NetWorkSatusType_5G;
            
        default:
            return NetWorkSatusType_None;
    }
    
}

- (void)getReachablityStatusWithChangeBlock:(void (^)(NetWorkSatusType))complete{
    self.netchangeNotifationBlock = nil;
    self.netchangeNotifationBlock =[complete copy];
    
}
- (void)listenLocalWifiBlock:(NetworkCallBackBlock)block{
    self.block = nil;
    self.block = [block copy];
    
}
- (NetWorkSatusType)currentNetStatusType{
    
    ZNKReachabilityStatus  status = self.currentNumberType.unsignedIntegerValue;
    if ([self canReachableViaWiFi] || [self canReachableViaWWAN]) {
        status = self.netstatusManager.status;
        
    }
    switch (status) {
        case ZNKReachabilityStatus_None:
            return NetWorkSatusType_None;
            
        case ZNKReachabilityStatus_WiFi:
            return NetWorkSatusType_WiFi;
            
        case ZNKReachabilityStatus_WWAN:
            return NetWorkSatusType_WiFi;
            
        case ZNKReachabilityStatus_WWAN_2G:
            return NetWorkSatusType_2G;
            
        case ZNKReachabilityStatus_WWAN_3G:
            return NetWorkSatusType_3G;
            
        case ZNKReachabilityStatus_WWAN_4G:
            return NetWorkSatusType_4G;
            
        case ZNKReachabilityStatus_WWAN_5G:
            return NetWorkSatusType_5G;
            
        default:
            return NetWorkSatusType_None;
    }
}

@end
