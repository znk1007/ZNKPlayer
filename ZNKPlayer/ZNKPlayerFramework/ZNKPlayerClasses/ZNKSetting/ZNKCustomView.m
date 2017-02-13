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

- (void)drawPlaceholderInRect:(CGRect)rect{
    UIColor *placeholderColor = [UIColor whiteColor];//设置颜色
    [placeholderColor setFill];
    
    CGRect placeholderRect = CGRectMake(rect.origin.x+20, (rect.size.height- self.font.pointSize)/2, rect.size.width, self.font.pointSize);//设置距离
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = self.textAlignment;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.font, NSFontAttributeName, placeholderColor, NSForegroundColorAttributeName, nil];
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];

}

@end
