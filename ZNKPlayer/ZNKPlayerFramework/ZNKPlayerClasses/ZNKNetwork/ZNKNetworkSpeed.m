//
//  ZNKNetworkSpeed.m
//  ZNKPlayer
//
//  Created by 黄漫 on 2017/2/5.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKNetworkSpeed.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface ZNKNetworkSpeed ()
{
    //总网速
    uint32_t _iBytes;
    uint32_t _oBytes;
    uint32_t _allFlow;
    
    //wifi网速
    uint32_t _wifiIBytes;
    uint32_t _wifiOBytes;
    uint32_t _wifiFlow;
    
    //3G网速
    uint32_t _wwanIBytes;
    uint32_t _wwanOBytes;
    uint32_t _wwanFlow;
}
@property (nonatomic, strong) NSTimer* timer;
/**下载速度block*/
@property (nonatomic, copy) void(^ZNKDownloadSpeedBlock)(NSString *speed);
/**上传速度block*/
@property (nonatomic, copy) void(^ZNKUploadSpeedBlock)(NSString *speed);
/**下载速度*/
@property (nonatomic, copy) NSString * downloadNetworkSpeed;
/**上传速度*/
@property (nonatomic, copy) NSString * uploadNetworkSpeed;
@end

@implementation ZNKNetworkSpeed
static ZNKNetworkSpeed* instance = nil;

+ (instancetype)sharedNetworkSpeed
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone*)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _iBytes = _oBytes = _allFlow = _wifiIBytes = _wifiOBytes = _wifiFlow = _wwanIBytes = _wwanOBytes = _wwanFlow = 0;
    }
    return self;
}

- (void)downloadNetworkSpeed:(void (^)(NSString *))downloadNetworkSpeedBlock{
    _ZNKDownloadSpeedBlock = downloadNetworkSpeedBlock;
}

- (void)uploadNetworkSpeed:(void (^)(NSString *))uploadNetworkSpeedBlock{
    _ZNKUploadSpeedBlock = uploadNetworkSpeedBlock;
}

#pragma mark - 开始监听网速
- (void)start
{
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkNetworkSpeed) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

//停止监听网速
- (void)stop
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    _ZNKUploadSpeedBlock = nil;
    _ZNKDownloadSpeedBlock = nil;
}

- (NSString*)stringWithbytes:(int)bytes
{
    if (bytes < 1024) // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if (bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if (bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) // MB
    {
        return [NSString stringWithFormat:@"%.1fMB", (double)bytes / (1024 * 1024)];
    }
    else // GB
    {
        return [NSString stringWithFormat:@"%.1fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

- (void)checkNetworkSpeed
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    uint32_t allFlow = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        // network
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
        
        //wifi
        if (!strcmp(ifa->ifa_name, "en0")) {
            
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow = wifiIBytes + wifiOBytes;
        }
        
        //3G or gprs
        if (!strcmp(ifa->ifa_name, "pdp_ip0")) {
            
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
    
    if (_iBytes != 0) {
        _downloadNetworkSpeed = [[self stringWithbytes:iBytes - _iBytes] stringByAppendingString:@"/s"];
        if (_ZNKDownloadSpeedBlock) {
            _ZNKDownloadSpeedBlock(_downloadNetworkSpeed);
        }
    }
    _iBytes = iBytes;
    
    if (_oBytes != 0) {
        _uploadNetworkSpeed = [[self stringWithbytes:oBytes - _oBytes] stringByAppendingString:@"/s"];
        if (_ZNKUploadSpeedBlock) {
            _ZNKUploadSpeedBlock(_uploadNetworkSpeed);
        }
    }
    _oBytes = oBytes;
}
@end
