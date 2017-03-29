//
//  ZNKControlView.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/7.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKControlView.h"
#import "ZNKMasonry.h"
#import "ZNKHeader.h"
#import "ZNKCustomView.h"
#import "ZNKKeyboardManager.h"

@interface ZNKControlView ()<UITextFieldDelegate>
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) ZNKPlayButton           *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ZNKSlider               *videoSlider;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;
/** 快进快退label */
@property (nonatomic, strong) UILabel                 *horizontalLabel;
/** 系统菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;

/** 缓存按钮 */
@property (nonatomic, strong) UIButton                *downLoadBtn;
/** 切换分辨率按钮 */
@property (nonatomic, strong) UIButton                *resolutionBtn;
/**过滤resolutionBtn状态改变*/
@property (nonatomic, assign) BOOL                    resolutionBtnFilter;
/** 分辨率的View */
@property (nonatomic, strong) UIView                  *resolutionView;
/**流畅按钮*/
@property (nonatomic, strong) UIButton                *ldButton;
/**标清按钮*/
@property (nonatomic, strong) UIButton                *sdButton;
/**高清按钮*/
@property (nonatomic, strong) UIButton                *hdButton;
/**蓝光按钮*/
@property (nonatomic, strong) UIButton                *bdButton;
/** 播放按钮 */
@property (nonatomic, strong) UIButton                *playBtn;
/**弹幕输入框*/
@property (nonatomic, strong) ZNKBarrageTextField     *barrageTF;
/**弹幕开关按钮*/
@property (nonatomic, strong) ZNKBarrageButton        *barrageOCButton;

@end

@implementation ZNKControlView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self addSubview:self.topImageView];
        [self.topImageView addSubview:self.downLoadBtn];
        [self.topImageView addSubview:self.resolutionBtn];
        [self.topImageView addSubview:self.titleLabel];
        
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.progressView];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        
        
        [self addSubview:self.lockBtn];
        [self addSubview:self.backBtn];
        [self addSubview:self.activity];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.horizontalLabel];
        [self addSubview:self.playBtn];
        
        [self addSubview:self.resolutionView];
        [self.resolutionView addSubview:self.ldButton];
        [self.resolutionView addSubview:self.sdButton];
        [self.resolutionView addSubview:self.hdButton];
        [self.resolutionView addSubview:self.bdButton];
        
        for (UIView *subview in self.subviews) {
            subview.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        self.hasBarrage = NO;
                
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [self.videoSlider addGestureRecognizer:sliderTap];
        
        UITapGestureRecognizer *viewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        [self addGestureRecognizer:viewSingleTap];
        
        [self originControlView];
        // 初始化时重置controlView
        [self resetControlView];
    }
    return self;
}

- (void)makeSubViewsConstraints
{
    ZNKWeakSelf(self);
    [self.backBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.mas_leading).offset(7);
        make.top.equalTo(weakself.mas_top).offset(5);
        make.width.height.mas_equalTo(@(40));
    }];
    
    [self.topImageView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(weakself);
        make.height.mas_equalTo(@(80));
    }];
    
    [self.titleLabel mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top).offset(5);
        make.width.mas_equalTo(180);
        make.centerX.equalTo(weakself.mas_centerX);
        make.centerY.equalTo(weakself.backBtn.mas_centerY);
        make.height.mas_equalTo(@(15));
    }];
    
    
    [self.downLoadBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(weakself.topImageView.mas_trailing).offset(-20);
        make.centerY.equalTo(weakself.backBtn.mas_centerY);
    }];
    
    [self.resolutionBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
        //-10 到－50 bt需求
        make.trailing.equalTo(weakself.downLoadBtn.mas_leading).offset(-20);
        make.centerY.equalTo(weakself.backBtn.mas_centerY);
    }];
    
    
    
    [self.bottomImageView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(weakself);
        make.height.mas_equalTo(50);
    }];
    
    [self.startBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(weakself.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.startBtn.mas_trailing).offset(-3);
        make.centerY.equalTo(weakself.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(weakself.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(weakself.startBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.trailing.equalTo(weakself.fullScreenBtn.mas_leading).offset(3);
        make.centerY.equalTo(weakself.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.progressView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(weakself.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(weakself.startBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(weakself.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(weakself.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
    
    [self.lockBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.mas_leading).offset(15);
        make.centerY.equalTo(weakself.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.horizontalLabel mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(33);
        make.center.equalTo(weakself);
    }];
    
    [self.activity mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.center.equalTo(weakself);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.center.equalTo(weakself);
    }];
    
    [self.playBtn mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.center.equalTo(weakself);
    }];
    
    
    
    [self.resolutionView mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.mas_trailing).offset(0);
        make.width.mas_equalTo(80);
        make.height.equalTo(weakself.mas_height);
    }];
    
    [self.hdButton mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.resolutionView.mas_leading).offset(20);
        make.trailing.equalTo(weakself.resolutionView.mas_trailing).offset(-20);
        make.centerY.equalTo(weakself.resolutionView.mas_centerY).offset(25);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.resolutionView.mas_centerY);
    }];
    
    [self.sdButton mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.hdButton.mas_leading);
        make.trailing.equalTo(weakself.hdButton);
        make.top.equalTo(weakself.hdButton.mas_top).offset(-40);
        make.width.equalTo(weakself.hdButton);
        make.height.equalTo(weakself.hdButton);
    }];
    
    [self.ldButton mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.sdButton);
        make.top.equalTo(weakself.sdButton).offset(-40);
        make.width.equalTo(weakself.hdButton);
        make.height.equalTo(weakself.hdButton);
    }];
    
    [self.bdButton mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
        make.leading.equalTo(weakself.hdButton);
        make.trailing.equalTo(weakself.hdButton);
        make.top.equalTo(weakself.hdButton).offset(40);
        make.width.equalTo(weakself.hdButton);
        make.height.equalTo(weakself.hdButton);
    }];
}

#pragma mark - Action

- (void)openLockBarrageAction:(UIButton *)btn{
    if (_ZNKBarrageOpenClose) {
        _ZNKBarrageOpenClose(btn);
    }
}

- (void)downloadButtonAction:(UIButton *)btn{
    if (_ZNKDownloadButtonClick) {
        _ZNKDownloadButtonClick(btn);
    }
}

/**
 *  点击topImageView上的按钮
 */
- (void)resolutionAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 99:
        {
            sender.selected = !sender.selected;
            // 显示隐藏分辨率View
            //    self.resolutionView.hidden = !sender.isSelected;
            [UIView animateWithDuration:ZNKPlayerControlBarAutoFadeOutTimeInterval animations:^{
                if (sender.selected) {
                    [self.resolutionView mas_updateConstraints:^(ZNKMASConstraintMaker *make) {
                        make.leading.equalTo(self.mas_trailing).offset(-80);
                    }];
                }else{
                    [self.resolutionView mas_updateConstraints:^(ZNKMASConstraintMaker *make) {
                        make.leading.equalTo(self.mas_trailing).offset(0);
                    }];
                }
            }];
        }
            break;
        case 100:
        {
            [self.resolutionBtn setTitle:@"流畅" forState:UIControlStateNormal];
            if (_ZNKResolusionButtonClick) {
                _ZNKResolusionButtonClick(ZNKResolustionTypeLD);
            }
        }
            break;
        case 101:
        {
            [self.resolutionBtn setTitle:@"标清" forState:UIControlStateNormal];
            if (_ZNKResolusionButtonClick) {
                _ZNKResolusionButtonClick(ZNKResolustionTypeSD);
            }
        }
            break;
        case 102:
        {
            [self.resolutionBtn setTitle:@"高清" forState:UIControlStateNormal];
            if (_ZNKResolusionButtonClick) {
                _ZNKResolusionButtonClick(ZNKResolustionTypeHD);
            }
        }
            break;
        case 103:
        {
            [self.resolutionBtn setTitle:@"蓝光" forState:UIControlStateNormal];
            if (_ZNKResolusionButtonClick) {
                _ZNKResolusionButtonClick(ZNKResolustionTypeBD);
            }
        }
            break;
        default:
            break;
    }
    
}

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender
{
    // 隐藏分辨率View
    self.resolutionView.hidden  = YES;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
//    if (self.resolutionBlock) { self.resolutionBlock(sender); }
    
}

/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UISlider class]] /*&& self.tapBlock*/) {
        ZNKSlider *slider = (ZNKSlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
//        self.tapBlock(tapValue);
        NSLog(@"tap value%f", tapValue);
        if (_ZNKSliderTap) {
            CGFloat resultValue = _ZNKSliderTap(slider, tapValue);
            if (resultValue == 0) {
                resultValue = slider.value;
            }
            slider.value = resultValue;
        }
    }
}

- (void)gestureAction:(UIGestureRecognizer *)gesture{
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        ZNKWeakSelf(self);
        [self.resolutionView mas_updateConstraints:^(ZNKMASConstraintMaker *make) {
            make.leading.equalTo(weakself.mas_trailing).offset(0);
        }];
        self.resolutionBtn.selected = NO;
        [self endEditing:YES];
    }
}

#pragma mark - Private Method

- (void)disableButton:(UIButton *)btn{
    btn.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    [btn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:normal];
}

- (void)enableButton:(UIButton *)btn{
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - Public Method
/**控制视图最初状态*/
- (void)originControlView{
    [self.activity stopAnimating];
    self.downLoadBtn.hidden = YES;
    self.horizontalLabel.hidden = YES;
    self.repeatBtn.hidden = YES;
    self.hasBarrage = NO;
    self.resolutionBtn.enabled   = NO;
}

/** 重置ControlView */
- (void)resetControlView
{
    self.videoSlider.value      = 0;
    self.progressView.progress  = 0;
    self.currentTimeLabel.text  = @"00:00";
    self.totalTimeLabel.text    = @"00:00";
    self.horizontalLabel.hidden = YES;
    self.repeatBtn.hidden       = YES;
    self.playBtn.hidden         = YES;
    self.backgroundColor        = [UIColor clearColor];
    self.downLoadBtn.enabled    = NO;
}

- (void)resetControlViewForResolution
{
    self.horizontalLabel.hidden = YES;
    self.repeatBtn.hidden       = YES;
    self.playBtn.hidden         = YES;
    self.downLoadBtn.enabled    = NO;
    self.backgroundColor        = [UIColor clearColor];
}

- (void)showControlView
{
    self.topImageView.alpha    = 1;
    self.bottomImageView.alpha = 1;
    self.lockBtn.alpha         = 1;
}

- (void)hideControlView
{
    self.topImageView.alpha    = 0;
    self.bottomImageView.alpha = 0;
    self.lockBtn.alpha         = 0;
    // 隐藏resolutionView
    self.resolutionBtn.selected = YES;
    [self resolutionAction:self.resolutionBtn];
}

#pragma mark - setter


- (void)setIsLandscape:(BOOL)a_isLandscape{
    if (_isLandscape != a_isLandscape) {
        _isLandscape = a_isLandscape;
        if (_isLandscape) {
            self.resolutionBtn.hidden = NO;
        }else{
            self.resolutionBtn.hidden = YES;
        }
    }
}

- (void)setCanDownload:(BOOL)a_canDownload{
    if (_canDownload != a_canDownload) {
        if (self.downLoadBtn) {
            if (_canDownload) {
                self.downLoadBtn.hidden = YES;
            }else{
                self.downLoadBtn.hidden = NO;
            }
        }
    }
}

- (void)setHasBarrage:(BOOL)a_hasBarrage{
    if (_hasBarrage != a_hasBarrage) {
        _hasBarrage = a_hasBarrage;
        if (_hasBarrage) {
            ZNKWeakSelf(self);
            [self.bottomImageView mas_updateConstraints:^(ZNKMASConstraintMaker *make) {
                make.height.mas_equalTo(80);
            }];
            
            [self.currentTimeLabel mas_remakeConstraints:^(ZNKMASConstraintMaker *make) {
                make.leading.equalTo(weakself.bottomImageView.mas_leading).offset(5);
                make.top.equalTo(weakself.startBtn.mas_top).offset(-20);
                make.width.mas_equalTo(43);
            }];
            
            [self.fullScreenBtn mas_updateConstraints:^(ZNKMASConstraintMaker *make) {
                make.width.height.mas_equalTo(30);
                make.trailing.equalTo(weakself.bottomImageView.mas_trailing).offset(-5);
                make.centerY.equalTo(weakself.startBtn.mas_centerY);
            }];
            
            [self.totalTimeLabel mas_remakeConstraints:^(ZNKMASConstraintMaker *make) {
                make.trailing.equalTo(weakself.bottomImageView.mas_trailing).offset(-5);
                make.centerY.equalTo(weakself.currentTimeLabel);
                make.width.mas_equalTo(43);
            }];
            
            [self.progressView mas_remakeConstraints:^(ZNKMASConstraintMaker *make) {
                make.leading.equalTo(weakself.currentTimeLabel.mas_trailing).offset(5);
                make.trailing.equalTo(weakself.totalTimeLabel.mas_leading).offset(-5);
                make.centerY.equalTo(weakself.currentTimeLabel);
            }];
            
            [self.videoSlider mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
                make.leading.equalTo(weakself.currentTimeLabel.mas_trailing).offset(4);
                make.trailing.equalTo(weakself.totalTimeLabel.mas_leading).offset(-4);
                make.centerY.equalTo(weakself.currentTimeLabel.mas_centerY).offset(-1);
                make.height.mas_equalTo(30);
            }];
            
            [self.bottomImageView addSubview:self.barrageOCButton];
            [self.barrageOCButton mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
                make.trailing.equalTo(weakself.fullScreenBtn.mas_leading).offset(-10);
                make.centerY.equalTo(weakself.fullScreenBtn);
                make.width.equalTo(weakself.fullScreenBtn);
                make.height.equalTo(weakself.fullScreenBtn);
            }];
            
            [self.bottomImageView addSubview:self.barrageTF];
            [self.barrageTF mas_makeConstraints:^(ZNKMASConstraintMaker *make) {
                make.leading.equalTo(weakself.progressView);
                make.centerY.equalTo(weakself.startBtn);
                make.trailing.equalTo(weakself.barrageOCButton).offset(-40);
                make.height.mas_equalTo(30);
            }];
        }
    }
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.contentScaleFactor = 0.6;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZNKPlayerImage(@"ZNKPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  = ZNKPlayerImage(@"ZNKPlayer_top_shadow");
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = ZNKPlayerImage(@"ZNKPlayer_bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn
{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZNKPlayerImage(@"ZNKPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZNKPlayerImage(@"ZNKPlayer_lock-nor") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [ZNKPlayButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:ZNKPlayerImage(@"ZNKPlayer_play") forState:UIControlStateNormal];
        [_startBtn setImage:ZNKPlayerImage(@"ZNKPlayer_pause") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (ZNKSlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider                       = [[ZNKSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;
        // 设置slider
        [_videoSlider setThumbImage:ZNKPlayerImage(@"ZNKPlayer_slider") forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:ZNKPlayerImage(@"ZNKPlayer_fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:ZNKPlayerImage(@"ZNKPlayer_shrinkscreen") forState:UIControlStateSelected];
    }
    return _fullScreenBtn;
}

- (UILabel *)horizontalLabel
{
    if (!_horizontalLabel) {
        _horizontalLabel                 = [[UILabel alloc] init];
        _horizontalLabel.textColor       = [UIColor whiteColor];
        _horizontalLabel.textAlignment   = NSTextAlignmentCenter;
        _horizontalLabel.font            = [UIFont systemFontOfSize:15.0];
        _horizontalLabel.backgroundColor = [UIColor colorWithPatternImage:ZNKPlayerImage(@"ZNKPlayer_management_mask")];
    }
    return _horizontalLabel;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activity;
}

- (UIButton *)repeatBtn
{
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:ZNKPlayerImage(@"ZNKPlayer_repeat_video") forState:UIControlStateNormal];
    }
    return _repeatBtn;
}

- (UIButton *)downLoadBtn
{
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _downLoadBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        _downLoadBtn.layer.borderWidth = 0.5;
//        _downLoadBtn.layer.cornerRadius = 1;
        [_downLoadBtn setImage:ZNKPlayerImage(@"ZNKPlayer_download") forState:UIControlStateNormal];
        [_downLoadBtn setImage:ZNKPlayerImage(@"ZNKPlayer_not_download") forState:UIControlStateDisabled];
        [_downLoadBtn addTarget:self action:@selector(downloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}

- (UIButton *)resolutionBtn
{
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_resolutionBtn addTarget:self action:@selector(resolutionAction:) forControlEvents:UIControlEventTouchUpInside];
        _resolutionBtn.tag = 99;
        _resolutionBtn.hidden = YES;
        _resolutionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _resolutionBtn.layer.borderWidth = 0.5;
        _resolutionBtn.layer.cornerRadius = 1;
        [_resolutionBtn setTitle:@"流畅" forState:UIControlStateNormal];
    }
    return _resolutionBtn;
}

- (void)setResolustionType:(ZNKResolustionType)aResolustionType{
    if (_resolustionType != aResolustionType) {
        _resolustionType = aResolustionType;
        switch (_resolustionType) {
            case ZNKResolustionTypeAll:
            {
                self.resolutionBtn.enabled = YES;
                self.ldButton.enabled = YES;
                self.sdButton.enabled = YES;
                self.hdButton.enabled = YES;
                self.bdButton.enabled = YES;
                
                [self enableButton:self.resolutionBtn];
                [self enableButton:self.ldButton];
                [self enableButton:self.sdButton];
                [self enableButton:self.hdButton];
                [self enableButton:self.bdButton];
            }
                break;
            case ZNKResolustionTypeHDAndBD:
            {
                self.resolutionBtn.enabled = YES;
                self.ldButton.enabled = NO;
                self.sdButton.enabled = NO;
                self.hdButton.enabled = YES;
                self.bdButton.enabled = YES;
                
                [self enableButton:self.resolutionBtn];
                [self disableButton:self.ldButton];
                [self disableButton:self.sdButton];
                [self enableButton:self.hdButton];
                [self enableButton:self.bdButton];
             
            }
                break;
            case ZNKResolustionTypeLDAndSD:
            {
                self.resolutionBtn.enabled = YES;
                self.ldButton.enabled = YES;
                self.sdButton.enabled = YES;
                self.hdButton.enabled = NO;
                self.bdButton.enabled = NO;
                
                [self enableButton:self.resolutionBtn];
                [self enableButton:self.ldButton];
                [self enableButton:self.sdButton];
                [self disableButton:self.hdButton];
                [self disableButton:self.bdButton];
            }
                break;
            case ZNKResolustionTypeLDSDAndHD:
            {
                self.resolutionBtn.enabled = YES;
                self.ldButton.enabled = YES;
                self.sdButton.enabled = YES;
                self.hdButton.enabled = YES;
                self.bdButton.enabled = NO;
                
                [self enableButton:self.resolutionBtn];
                [self enableButton:self.ldButton];
                [self enableButton:self.sdButton];
                [self enableButton:self.hdButton];
                [self disableButton:self.bdButton];
            }
                break;
            case ZNKResolustionTypeSDHDAndBD:
            {
                self.resolutionBtn.enabled = YES;
                self.ldButton.enabled = NO;
                self.sdButton.enabled = YES;
                self.hdButton.enabled = YES;
                self.bdButton.enabled = YES;
                
                [self enableButton:self.resolutionBtn];
                [self disableButton:self.ldButton];
                [self enableButton:self.sdButton];
                [self enableButton:self.hdButton];
                [self enableButton:self.bdButton];
            }
                break;
            case ZNKResolustionTypeLD:{
                self.resolutionBtn.enabled = NO;
                [self disableButton:self.resolutionBtn];
            }
                break;
            case ZNKResolustionTypeSD:{
                [self disableButton:self.resolutionBtn];
                self.resolutionBtn.enabled = NO;
            }
                break;
            case ZNKResolustionTypeHD:{
                [self disableButton:self.resolutionBtn];
                self.resolutionBtn.enabled = NO;
            }
                break;
            case ZNKResolustionTypeBD:{
                [self disableButton:self.resolutionBtn];
                self.resolutionBtn.enabled = NO;
            }
                break;
            default:
                break;
        }
    }
}

- (UIView *)resolutionView{
    if (!_resolutionView) {
        _resolutionView = [[UIView alloc] init];
        _resolutionView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    }
    return _resolutionView;
}

- (UIButton *)ldButton{
    if (!_ldButton) {
        _ldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ldButton.tag = 100;
        [_ldButton addTarget:self action:@selector(resolutionAction:) forControlEvents:UIControlEventTouchUpInside];
        _ldButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _ldButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _ldButton.layer.borderWidth = 0.5;
        _ldButton.layer.cornerRadius = 1;
        [_ldButton setTitle:@"流畅" forState:UIControlStateNormal];
    }
    return _ldButton;
}

- (UIButton *)sdButton{
    if (!_sdButton) {
        _sdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sdButton.tag = 101;
        [_sdButton addTarget:self action:@selector(resolutionAction:) forControlEvents:UIControlEventTouchUpInside];
        _sdButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _sdButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _sdButton.layer.borderWidth = 0.5;
        _sdButton.layer.cornerRadius = 1;
        [_sdButton setTitle:@"标清" forState:UIControlStateNormal];
    }
    return _sdButton;
}

- (UIButton *)hdButton{
    if (!_hdButton) {
        _hdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hdButton.tag = 102;
        [_hdButton addTarget:self action:@selector(resolutionAction:) forControlEvents:UIControlEventTouchUpInside];
        _hdButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _hdButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _hdButton.layer.borderWidth = 0.5;
        _hdButton.layer.cornerRadius = 1;
        [_hdButton setTitle:@"高清" forState:UIControlStateNormal];
    }
    return _hdButton;
}

- (UIButton *)bdButton{
    if (!_bdButton) {
        _bdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bdButton.tag = 103;
        [_bdButton addTarget:self action:@selector(resolutionAction:) forControlEvents:UIControlEventTouchUpInside];
        _bdButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _bdButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _bdButton.layer.borderWidth = 0.5;
        _bdButton.layer.cornerRadius = 1;
        [_bdButton setTitle:@"蓝光" forState:UIControlStateNormal];
    }
    return _bdButton;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:ZNKPlayerImage(@"ZNKPlayer_play_btn") forState:UIControlStateNormal];
    }
    return _playBtn;
}

- (UITextField *)barrageTF{
    if (!_barrageTF) {
        _barrageTF = [[ZNKBarrageTextField alloc] init];
        _barrageTF.delegate = self;
        _barrageTF.placeholder = @"发个弹幕吧~!";
        _barrageTF.borderStyle = UITextBorderStyleRoundedRect;
        _barrageTF.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    }
    return _barrageTF;
}

- (ZNKBarrageButton *)barrageOCButton{
    if (!_barrageOCButton) {
        _barrageOCButton = [ZNKBarrageButton buttonWithType:UIButtonTypeCustom];
        [_barrageOCButton setImage:ZNKPlayerImage(@"ZNKPlayer_barrage_normal") forState:UIControlStateNormal];
        [_barrageOCButton setImage:ZNKPlayerImage(@"ZNKPlayer_barrage_lock") forState:UIControlStateSelected];
        [_barrageOCButton addTarget:self action:@selector(openLockBarrageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageOCButton;
}

#pragma mark - 按钮事件

- (void)startButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_ZNKStartPauseButtonClick) {
        _ZNKStartPauseButtonClick(sender);
    }
}

@end
