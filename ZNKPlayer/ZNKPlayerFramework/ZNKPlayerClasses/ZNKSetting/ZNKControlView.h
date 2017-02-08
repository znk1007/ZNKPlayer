//
//ZNKControlView.h
//ZNKPlayer
//
//CreatedbyHuangSamon2017/2/7.
//Copyright©2017年HM.Allrightsreserved.
//

#import<UIKit/UIKit.h>
#import"ZNKSlider.h"

typedef enum {
    ZNKResolustionTypeLD,                   /**流畅*/
    ZNKResolustionTypeSD,                   /**标清*/
    ZNKResolustionTypeHD,                   /**高清*/
    ZNKResolustionTypeBD,                   /**蓝光*/
    ZNKResolustionTypeLDAndSD,              /**流畅和标清*/
    ZNKResolustionTypeLDSDAndHD,            /**流畅,标清和高清*/
    ZNKResolustionTypeSDHDAndBD,            /**标清,高清和蓝光*/
    ZNKResolustionTypeHDAndBD,              /**高清和蓝光*/
    ZNKResolustionTypeAll,                  /**所有分辨率*/
}ZNKResolustionType;

@interface ZNKControlView : UIView
/**标题 */
@property (nonatomic, readonly) UILabel *titleLabel;
/**开始播放按钮 */
@property (nonatomic, readonly) UIButton *startBtn;
/**当前播放时长label */
@property (nonatomic, readonly) UILabel *currentTimeLabel;
/**视频总时长label */
@property (nonatomic, readonly) UILabel *totalTimeLabel;
/**缓冲进度条 */
@property (nonatomic, readonly) UIProgressView *progressView;
/**滑杆 */
@property (nonatomic, readonly) ZNKSlider *videoSlider;
/**全屏按钮 */
@property (nonatomic, readonly) UIButton *fullScreenBtn;
/**锁定屏幕方向按钮 */
@property (nonatomic, readonly) UIButton *lockBtn;
/**快进快退label */
@property (nonatomic, readonly) UILabel *horizontalLabel;
/**系统菊花 */
@property (nonatomic, readonly) UIActivityIndicatorView *activity;
/**返回按钮 */
@property (nonatomic, readonly) UIButton *backBtn;
/**重播按钮 */
@property (nonatomic, readonly) UIButton *repeatBtn;
/**bottomView */
@property (nonatomic, readonly) UIImageView *bottomImageView;
/**topView */
@property (nonatomic, readonly) UIImageView *topImageView;
/**缓存按钮 */
@property (nonatomic, readonly) UIButton *downLoadBtn;
/**切换分辨率按钮 */
@property (nonatomic, readonly) UIButton *resolutionBtn;
/**播放按钮 */
@property (nonatomic, readonly) UIButton *playBtn;
/**分辨率的名称 */
@property (nonatomic, strong)   NSArray *resolutionArray;
/**是否横屏 */
@property (nonatomic, assign)   BOOL isLandscape;
/**是否有弹幕*/
@property (nonatomic, assign)   BOOL hasBarrage;
/**视频分辨率*/
@property (nonatomic, assign) ZNKResolustionType resolustionType;
/**切换分辨率的block */
//@property (nonatomic,copy) ChangeResolutionBlockresolutionBlock;
///**slidertap事件Block */
//@property (nonatomic,copy) SliderTapBlocktapBlock;

/**重置ControlView */
- (void)resetControlView;
/**切换分辨率时候调用此方法 */
- (void)resetControlViewForResolution;
/**显示top、bottom、lockBtn */
- (void)showControlView;
/**隐藏top、bottom、lockBtn */
- (void)hideControlView;
@end
