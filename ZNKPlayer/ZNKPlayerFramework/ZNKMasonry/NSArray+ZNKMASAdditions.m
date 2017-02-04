//
//  NSArray+ZNKMASAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+ZNKMASAdditions.h"
#import "View+ZNKMASAdditions.h"

@implementation NSArray (ZNKMASAdditions)

- (NSArray *)mas_makeConstraints:(void(^)(ZNKMASConstraintMaker *ZNKMAke))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (ZNKMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[ZNKMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mas_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)mas_updateConstraints:(void(^)(ZNKMASConstraintMaker *ZNKMAke))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (ZNKMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[ZNKMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mas_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)mas_remakeConstraints:(void(^)(ZNKMASConstraintMaker *ZNKMAke))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (ZNKMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[ZNKMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mas_remakeConstraints:block]];
    }
    return constraints;
}

- (void)mas_distributeViewsAlongAxis:(ZNKMASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    ZNKMAS_VIEW *tempSuperView = [self mas_commonSuperviewOfViews];
    if (axisType == ZNKMASAxisTypeHorizontal) {
        ZNKMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            ZNKMAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(ZNKMASConstraintMaker *ZNKMAke) {
                if (prev) {
                    ZNKMAke.width.equalTo(prev);
                    ZNKMAke.left.equalTo(prev.mas_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        ZNKMAke.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    ZNKMAke.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        ZNKMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            ZNKMAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(ZNKMASConstraintMaker *ZNKMAke) {
                if (prev) {
                    ZNKMAke.height.equalTo(prev);
                    ZNKMAke.top.equalTo(prev.mas_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        ZNKMAke.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    ZNKMAke.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)mas_distributeViewsAlongAxis:(ZNKMASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    ZNKMAS_VIEW *tempSuperView = [self mas_commonSuperviewOfViews];
    if (axisType == ZNKMASAxisTypeHorizontal) {
        ZNKMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            ZNKMAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(ZNKMASConstraintMaker *ZNKMAke) {
                ZNKMAke.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        ZNKMAke.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        ZNKMAke.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    ZNKMAke.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        ZNKMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            ZNKMAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(ZNKMASConstraintMaker *ZNKMAke) {
                ZNKMAke.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        ZNKMAke.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        ZNKMAke.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    ZNKMAke.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (ZNKMAS_VIEW *)mas_commonSuperviewOfViews
{
    ZNKMAS_VIEW *commonSuperview = nil;
    ZNKMAS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[ZNKMAS_VIEW class]]) {
            ZNKMAS_VIEW *view = (ZNKMAS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view mas_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. ZNKMAke sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
