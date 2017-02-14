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

@implementation ZNKBarrageButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat num = 1 / 1.5;
    return CGRectMake((CGRectGetWidth(contentRect) - (CGRectGetWidth(contentRect) * num)) / 2.0, (CGRectGetHeight(contentRect) - (CGRectGetHeight(contentRect) * num)) / 2.0, (CGRectGetWidth(contentRect) * num), (CGRectGetHeight(contentRect) * num));
}

@end

@implementation ZNKBarrageTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.font = [UIFont systemFontOfSize:13];
//        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect{
    UIColor *placeholderColor = [UIColor whiteColor];//设置颜色
    [placeholderColor setFill];
    
    CGRect placeholderRect = CGRectMake((rect.size.width - (rect.size.width / 2)) / 2, (rect.size.height - self.font.pointSize) / 2, (rect.size.width / 2), self.font.pointSize);//设置距离
    
    self.font = [UIFont systemFontOfSize:13];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.font, NSFontAttributeName, placeholderColor, NSForegroundColorAttributeName, nil];
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];

}



@end
