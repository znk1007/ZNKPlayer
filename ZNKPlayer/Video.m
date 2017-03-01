//
//  Video.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/28.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "Video.h"
#import "HTTPEngine.h"

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

+ (void)videoData:(void(^)(Video *data))completionHandler{
    [[HTTPEngine sharedEngine] getRequestWithURL:@"http://c.m.163.com/nc/video/home/0-10.html" parameters:nil success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
//        NSLog(@"success %@",responseObject);
        if (responseObject) {
            Video *v = [[Video alloc] init];
            if (responseObject[@"videoHomeSid"]) {
                v.videoHomeSid = [ZNKFormat stringFormat:responseObject[@"videoHomeSid"]];
            }
            if (responseObject[@"videoList"] && [responseObject[@"videoList"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *videoList = [NSMutableArray array];
                NSArray *videoListArr = responseObject[@"videoList"];
                for (NSDictionary *videoListDict in videoListArr) {
                    VideoListModel *listModel = [[VideoListModel alloc] init];
                    listModel.cover = [ZNKFormat stringFormat:videoListDict[@"cover"]];
                    listModel.videoDescription = [ZNKFormat stringFormat:videoListDict[@"description"]];
                    listModel.length = [ZNKFormat stringFormat:videoListDict[@"length"]];
                    listModel.m3u8_url = [ZNKFormat stringFormat:videoListDict[@"m3u8_url"]];
                    listModel.m3u8Hd_url = [ZNKFormat stringFormat:videoListDict[@"m3u8Hd_url"]];
                    listModel.mp4_url = [ZNKFormat stringFormat:videoListDict[@"mp4_url"]];
                    listModel.mp4_Hd_url = [ZNKFormat stringFormat:videoListDict[@"mp4Hd_url"]];
                    listModel.playCount = [ZNKFormat stringFormat:videoListDict[@"playCount"]];
                    listModel.playersize = [ZNKFormat stringFormat:videoListDict[@"playersize"]];
                    listModel.ptime = [ZNKFormat stringFormat:videoListDict[@"ptime"]];
                    listModel.replyBoard = [ZNKFormat stringFormat:videoListDict[@"replyBoard"]];
                    listModel.replyid = [ZNKFormat stringFormat:videoListDict[@"replyid"]];
                    listModel.sectiontitle = [ZNKFormat stringFormat:videoListDict[@"sectiontitle"]];
                    listModel.title = [ZNKFormat stringFormat:videoListDict[@"title"]];
                    listModel.topicDesc = [ZNKFormat stringFormat:videoListDict[@"topicDesc"]];
                    listModel.topicImg = [ZNKFormat stringFormat:videoListDict[@"topicImg"]];
                    listModel.topicName = [ZNKFormat stringFormat:videoListDict[@"topicName"]];
                    listModel.topicSid = [ZNKFormat stringFormat:videoListDict[@"topicSid"]];
                    listModel.vid = [ZNKFormat stringFormat:videoListDict[@"vid"]];
                    listModel.videosource = [ZNKFormat stringFormat:videoListDict[@"videosource"]];
                    [videoList addObject:listModel];
                }
                v.videoList = videoList;
            }
            if (responseObject[@"videoSidList"] && [responseObject[@"videoSidList"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *videoSidList = [NSMutableArray array];
                NSArray *videoSidListArr = responseObject[@"videoSidList"];
                for (NSDictionary *videoSidDict in videoSidListArr) {
                    VideoSidListModel *sidListModel = [[VideoSidListModel alloc] init];
                    sidListModel.imgsrc = [ZNKFormat stringFormat:videoSidDict[@"imgsrc"]];
                    sidListModel.sid = [ZNKFormat stringFormat:videoSidDict[@"sid"]];
                    sidListModel.title = [ZNKFormat stringFormat:videoSidDict[@"title"]];
                    [videoSidList addObject:sidListModel];
                }
                v.videoSidList = videoSidList;
            }
            if (completionHandler) {
                completionHandler(v);
            }
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSLog(@"error %@",error.localizedDescription);
        if (completionHandler) {
            completionHandler(nil);
        }
    }];
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
