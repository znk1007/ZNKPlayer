//
//  Video.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/28.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNKFormat : NSObject

+ (NSString *)stringFormat:(id)obj;

@end

@class VideoSidListModel;
@class VideoListModel;
@interface Video : NSObject
@property (nonatomic, copy) NSString *videoHomeSid;
@property (nonatomic, strong) NSArray <VideoListModel *> *videoList;
@property (nonatomic, strong) NSArray <VideoSidListModel *> *videoSidList;
/**视频数据*/
+ (void)videoData:(void(^)(Video *data))completionHandler;



@end

@interface VideoSidListModel : NSObject
@property (nonatomic, copy) NSString *imgsrc;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *title;
@end


@interface VideoListModel : NSObject
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *videoDescription;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *m3u8_url;
@property (nonatomic, copy) NSString *m3u8Hd_url;
@property (nonatomic, copy) NSString *mp4_url;
@property (nonatomic, copy) NSString *mp4_Hd_url;
@property (nonatomic, copy) NSString *playCount;
@property (nonatomic, copy) NSString *playersize;
@property (nonatomic, copy) NSString *ptime;
@property (nonatomic, copy) NSString *replyBoard;
@property (nonatomic, copy) NSString *replyCount;
@property (nonatomic, copy) NSString *replyid;
@property (nonatomic, copy) NSString *sectiontitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *topicDesc;
@property (nonatomic, copy) NSString *topicImg;
@property (nonatomic, copy) NSString *topicName;
@property (nonatomic, copy) NSString *topicSid;
@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSString *videosource;
@end
