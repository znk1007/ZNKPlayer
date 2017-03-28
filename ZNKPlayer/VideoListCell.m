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
#import "UIButton+WebCache.h"


@interface VideoListCell ()

@property (nonatomic, copy) void(^ZNKVideoPlayHandler)(VideoPlayButton *btn);

@end

@implementation VideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCell:(VideoListModel *)model atIndexPath:(NSIndexPath *)indexPath playAction:(void(^)(VideoPlayButton *btn))completionHandler{
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    CGFloat height = [model.title sizeForFontSize:15].height;
    titleLabel.text = model.title;
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).offset(5);
        make.trailing.equalTo(weakSelf.contentView).offset(-5);
        make.height.mas_equalTo(height);
    }];
    if (![model.videoDescription isEqualToString:@""]) {
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.numberOfLines = 0;
        descLabel.font = [UIFont systemFontOfSize:12];
        height = [model.videoDescription sizeForFontSize:14].height;
        [self.contentView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
            make.leading.equalTo(titleLabel);
            make.trailing.equalTo(titleLabel);
            make.height.mas_equalTo(height);
        }];
    }
    if (![model.cover isEqualToString:@""]) {
        self.videoImageView = [[UIImageView alloc] init];
//        videoImageView.userInteractionEnabled = YES;
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default_video"]];
        [self.contentView addSubview:self.videoImageView];
        self.videoImageView.userInteractionEnabled = YES;
        [self.videoImageView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(2);
            make.leading.equalTo(titleLabel);
            make.trailing.equalTo(titleLabel);
            make.height.mas_equalTo(150);
        }];
        
        if (_ZNKVideoPlayHandler) {
            _ZNKVideoPlayHandler = nil;
        }
        _ZNKVideoPlayHandler = completionHandler;
        
        self.playBtn = [VideoPlayButton buttonWithType:UIButtonTypeCustom];
        [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.playBtn setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        self.playBtn.indexPath = indexPath;
        self.playBtn.listModel = model;
        self.playBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.playBtn];
        
        [self.playBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
            make.center.equalTo(weakSelf.videoImageView);
            make.width.height.mas_equalTo(60);
        }];
    }
    
}

- (void)playAction:(VideoPlayButton *)sender{
    if (_ZNKVideoPlayHandler) {
        _ZNKVideoPlayHandler(sender);
    }
}

@end
