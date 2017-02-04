//
//  NSLayoutConstraint+ZNKMASDebugAdditions.m
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 3/08/13.
//  Copyright (c) 2013 Jonas BudelZNKMAnn. All rights reserved.
//

#import "NSLayoutConstraint+ZNKMASDebugAdditions.h"
#import "ZNKMASConstraint.h"
#import "ZNKMASLayoutConstraint.h"

@implementation NSLayoutConstraint (ZNKMASDebugAdditions)

#pragma mark - description ZNKMAps



+ (NSDictionary *)layoutRelationDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutRelationEqual)                : @"==",
            @(NSLayoutRelationGreaterThanOrEqual)   : @">=",
            @(NSLayoutRelationLessThanOrEqual)      : @"<=",
        };
    });
    return descriptionMap;
}

+ (NSDictionary *)layoutAttributeDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutAttributeTop)      : @"top",
            @(NSLayoutAttributeLeft)     : @"left",
            @(NSLayoutAttributeBottom)   : @"bottom",
            @(NSLayoutAttributeRight)    : @"right",
            @(NSLayoutAttributeLeading)  : @"leading",
            @(NSLayoutAttributeTrailing) : @"trailing",
            @(NSLayoutAttributeWidth)    : @"width",
            @(NSLayoutAttributeHeight)   : @"height",
            @(NSLayoutAttributeCenterX)  : @"centerX",
            @(NSLayoutAttributeCenterY)  : @"centerY",
            @(NSLayoutAttributeBaseline) : @"baseline",
            
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
            @(NSLayoutAttributeFirstBaseline) : @"firstBaseline",
            @(NSLayoutAttributeLastBaseline) : @"lastBaseline",
#endif
            
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
            @(NSLayoutAttributeLeftMargin)           : @"leftMargin",
            @(NSLayoutAttributeRightMargin)          : @"rightMargin",
            @(NSLayoutAttributeTopMargin)            : @"topMargin",
            @(NSLayoutAttributeBottomMargin)         : @"bottomMargin",
            @(NSLayoutAttributeLeadingMargin)        : @"leadingMargin",
            @(NSLayoutAttributeTrailingMargin)       : @"trailingMargin",
            @(NSLayoutAttributeCenterXWithinMargins) : @"centerXWithinMargins",
            @(NSLayoutAttributeCenterYWithinMargins) : @"centerYWithinMargins",
#endif
            
        };
    
    });
    return descriptionMap;
}


+ (NSDictionary *)layoutPriorityDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
#if TARGET_OS_IPHONE || TARGET_OS_TV
        descriptionMap = @{
            @(ZNKMASLayoutPriorityDefaultHigh)      : @"high",
            @(ZNKMASLayoutPriorityDefaultLow)       : @"low",
            @(ZNKMASLayoutPriorityDefaultMedium)    : @"medium",
            @(ZNKMASLayoutPriorityRequired)         : @"required",
            @(ZNKMASLayoutPriorityFittingSizeLevel) : @"fitting size",
        };
#elif TARGET_OS_ZNKMAC
        descriptionMap = @{
            @(ZNKMASLayoutPriorityDefaultHigh)                 : @"high",
            @(ZNKMASLayoutPriorityDragThatCanResizeWindow)     : @"drag can resize window",
            @(ZNKMASLayoutPriorityDefaultMedium)               : @"medium",
            @(ZNKMASLayoutPriorityWindowSizeStayPut)           : @"window size stay put",
            @(ZNKMASLayoutPriorityDragThatCannotResizeWindow)  : @"drag cannot resize window",
            @(ZNKMASLayoutPriorityDefaultLow)                  : @"low",
            @(ZNKMASLayoutPriorityFittingSizeCompression)      : @"fitting size",
            @(ZNKMASLayoutPriorityRequired)                    : @"required",
        };
#endif
    });
    return descriptionMap;
}

#pragma mark - description override

+ (NSString *)descriptionForObject:(id)obj {
    if ([obj respondsToSelector:@selector(mas_key)] && [obj mas_key]) {
        return [NSString stringWithFormat:@"%@:%@", [obj class], [obj mas_key]];
    }
    return [NSString stringWithFormat:@"%@:%p", [obj class], obj];
}

- (NSString *)description {
    NSMutableString *description = [[NSMutableString alloc] initWithString:@"<"];

    [description appendString:[self.class descriptionForObject:self]];

    [description appendFormat:@" %@", [self.class descriptionForObject:self.firstItem]];
    if (self.firstAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", self.class.layoutAttributeDescriptionsByValue[@(self.firstAttribute)]];
    }

    [description appendFormat:@" %@", self.class.layoutRelationDescriptionsByValue[@(self.relation)]];

    if (self.secondItem) {
        [description appendFormat:@" %@", [self.class descriptionForObject:self.secondItem]];
    }
    if (self.secondAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", self.class.layoutAttributeDescriptionsByValue[@(self.secondAttribute)]];
    }
    
    if (self.multiplier != 1) {
        [description appendFormat:@" * %g", self.multiplier];
    }
    
    if (self.secondAttribute == NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@" %g", self.constant];
    } else {
        if (self.constant) {
            [description appendFormat:@" %@ %g", (self.constant < 0 ? @"-" : @"+"), ABS(self.constant)];
        }
    }

    if (self.priority != ZNKMASLayoutPriorityRequired) {
        [description appendFormat:@" ^%@", self.class.layoutPriorityDescriptionsByValue[@(self.priority)] ?: [NSNumber numberWithDouble:self.priority]];
    }

    [description appendString:@">"];
    return description;
}

@end
