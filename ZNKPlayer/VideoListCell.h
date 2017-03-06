//
//  VideoListCell.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/3/1.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "VideoExtension.h"

#define ImageViewStartIndex 1000

@interface VideoListCell : UITableViewCell
/**封面*/
@property (nonatomic, strong) UIImageView *videoImageView;
/**播放按钮*/
@property (nonatomic, strong) VideoPlayButton *playBtn;
/**更新数据*/
- (void)refreshCell:(VideoListModel *)model atIndexPath:(NSIndexPath *)indexPath playAction:(void(^)(VideoPlayButton *btn))completionHandler;

@end
