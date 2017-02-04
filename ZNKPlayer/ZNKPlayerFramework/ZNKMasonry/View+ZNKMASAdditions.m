//
//  UIView+ZNKMASAdditions.m
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+ZNKMASAdditions.h"
#import <objc/runtime.h>

@implementation ZNKMAS_VIEW (ZNKMASAdditions)

- (NSArray *)mas_makeConstraints:(void(^)(ZNKMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    ZNKMASConstraintMaker *constraintMaker = [[ZNKMASConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)mas_updateConstraints:(void(^)(ZNKMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    ZNKMASConstraintMaker *constraintMaker = [[ZNKMASConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)mas_remakeConstraints:(void(^)(ZNKMASConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    ZNKMASConstraintMaker *constraintMaker = [[ZNKMASConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (ZNKMASViewAttribute *)mas_left {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (ZNKMASViewAttribute *)mas_top {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (ZNKMASViewAttribute *)mas_right {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (ZNKMASViewAttribute *)mas_bottom {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (ZNKMASViewAttribute *)mas_leading {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (ZNKMASViewAttribute *)mas_trailing {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (ZNKMASViewAttribute *)mas_width {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (ZNKMASViewAttribute *)mas_height {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (ZNKMASViewAttribute *)mas_centerX {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (ZNKMASViewAttribute *)mas_centerY {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (ZNKMASViewAttribute *)mas_baseline {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (ZNKMASViewAttribute *(^)(NSLayoutAttribute))mas_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (ZNKMASViewAttribute *)mas_firstBaseline {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (ZNKMASViewAttribute *)mas_lastBaseline {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (ZNKMASViewAttribute *)mas_leftMargin {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (ZNKMASViewAttribute *)mas_rightMargin {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (ZNKMASViewAttribute *)mas_topMargin {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (ZNKMASViewAttribute *)mas_bottomMargin {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (ZNKMASViewAttribute *)mas_leadingMargin {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (ZNKMASViewAttribute *)mas_trailingMargin {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (ZNKMASViewAttribute *)mas_centerXWithinMargins {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (ZNKMASViewAttribute *)mas_centerYWithinMargins {
    return [[ZNKMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - associated properties

- (id)mas_key {
    return objc_getAssociatedObject(self, @selector(mas_key));
}

- (void)setMas_key:(id)key {
    objc_setAssociatedObject(self, @selector(mas_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)mas_closestCommonSuperview:(ZNKMAS_VIEW *)view {
    ZNKMAS_VIEW *closestCommonSuperview = nil;

    ZNKMAS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        ZNKMAS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
