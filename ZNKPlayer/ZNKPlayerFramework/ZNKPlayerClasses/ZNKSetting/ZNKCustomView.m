//
//  CustomView.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/8.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKCustomView.h"




@implementation ZNKPlayButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat num = 1 / 1.8;
    return CGRectMake((CGRectGetWidth(contentRect) - (CGRectGetWidth(contentRect) * num)) / 2.0, (CGRectGetHeight(contentRect) - (CGRectGetHeight(contentRect) * num)) / 2.0, (CGRectGetWidth(contentRect) * num), (CGRectGetHeight(contentRect) * num));
}

@end
