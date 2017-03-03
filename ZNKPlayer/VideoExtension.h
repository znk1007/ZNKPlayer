//
//  VideoExtension.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/3/3.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"

@interface VideoExtension : UIView

@end

@interface VideoPlayButton : UIButton
/**按钮关联的indexPath*/
@property (nonatomic, strong) NSIndexPath *indexPath;
/**按钮关联的model*/
@property (nonatomic, strong) VideoListModel *listModel;
@end

@interface VideoImageView : UIImageView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

