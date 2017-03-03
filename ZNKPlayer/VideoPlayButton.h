//
//  VideoPlayButton.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/3/1.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"

@interface VideoPlayButton : UIButton
/**按钮关联的indexPath*/
@property (nonatomic, strong) NSIndexPath *indexPath;
/**按钮关联的model*/
@property (nonatomic, strong) VideoListModel *listModel;

@end
