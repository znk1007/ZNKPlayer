//
//  VideoListCell.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/3/1.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "VideoPlayButton.h"

@interface VideoListCell : UITableViewCell

- (void)refreshCell:(VideoListModel *)model atIndexPath:(NSIndexPath *)indexPath playAction:(void(^)(VideoPlayButton *btn))completionHandler;

@end
