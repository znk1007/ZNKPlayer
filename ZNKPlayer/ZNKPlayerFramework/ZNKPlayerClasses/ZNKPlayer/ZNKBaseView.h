//
//  ZNKBaseView.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/4.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZNKDragDirectionAny,        /**< 任意方向 */
    ZNKDragDirectionHorizontal, /**< 水平方向 */
    ZNKDragDirectionVertical,   /**< 垂直方向 */
}ZNKDragDirection;

@interface ZNKBaseView : UIView
/**
 是不是能拖曳，
 YES，能拖曳
 NO，不能拖曳
 */
@property (nonatomic,assign) BOOL dragEnable;
/**
 活动范围，默认为父视图的frame范围内（因为拖出父视图后无法点击，也没意义）
 如果设置了，则会在给定的范围内活动
 如果没设置，则会在父视图范围内活动
 注意：设置的frame不要大于父视图范围
 注意：设置的frame为0，0，0，0表示活动的范围为默认的父视图frame，如果想要不能活动，请设置dragEnable这个属性为NO
 */
@property (nonatomic,assign) CGRect freeRect;
/**
 拖曳的方向，默认为any，任意方向
 */
@property (nonatomic,assign) ZNKDragDirection dragDirection;
/**
 内部的一个UIImageView，采用懒加载的方式，开发者用的时候才会创建，不用就为nil
 开发者也可以自定义控件添加到本view中
 注意：最好不要同时使用内部的imageView和button
 */
@property (nonatomic,strong) UIImageView *imageView;

/**
 内部的一个UIButton，采用懒加载的方式，开发者用的时候才会创建，不用就为nil
 开发者也可以自定义控件添加到本view中
 注意：最好不要同时使用内部的imageView和button
 */
@property (nonatomic,strong) UIButton *button;

/**
 内容view，命名为znkDragContentView，因为很多第三方的库继承UIView，里面同样有contentView这个属性
 防止冲突，这里特别命名为contentViewForDrag
 */
@property (nonatomic,strong) UIView *znkDragContentView;

/**
 点击的回调block
 */
@property (nonatomic,copy) void(^ZNKClickDragViewBlock)(ZNKBaseView *dragView);

/**
 开始拖动的回调block
 */
@property (nonatomic,copy) void(^ZNKBeginDragBlock)(ZNKBaseView *dragView);
/**
 拖动中的回调block
 */
@property (nonatomic,copy) void(^ZNKDuringDragBlock)(ZNKBaseView *dragView);
/**
 结束拖动的回调block
 */
@property (nonatomic,copy) void(^ZNKEndDragBlock)(ZNKBaseView *dragView);

/**
 是不是保持在边界，默认为NO,没有黏贴边界效果
 isKeepBounds = YES，它将自动黏贴边界，而且是最近的边界
 isKeepBounds = NO， 它将不会黏贴在边界，它是free(自由)状态，跟随手指到任意位置，但是也不可以拖出规定的范围
 */
@property (nonatomic,assign) BOOL isKeepBounds;
@end
