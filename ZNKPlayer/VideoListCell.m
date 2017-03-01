//
//  VideoListCell.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/3/1.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "VideoListCell.h"
#import "ZNKMasonry.h"
#import "ZNKTool.h"
#import "UIImageView+WebCache.h"

@implementation VideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCell:(VideoListModel *)model atIndexPath:(NSIndexPath *)indexPath{
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    CGFloat height = [model.title sizeForFontSize:15].height;
    titleLabel.text = model.title;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView);
        make.trailing.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(height);
    }];
    if (![model.videoDescription isEqualToString:@""]) {
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.font = [UIFont systemFontOfSize:12];
        height = [model.videoDescription sizeForFontSize:14].height;
        [self.contentView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
            make.leading.equalTo(titleLabel);
            make.trailing.equalTo(titleLabel);
            make.height.mas_equalTo(height);
        }];
    }
    UIImageView *videoImageView = [[UIImageView alloc] init];
    
}

@end
