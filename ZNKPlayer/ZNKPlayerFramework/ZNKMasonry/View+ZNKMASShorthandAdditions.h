//
//  UIView+ZNKMASShorthandAdditions.h
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 22/07/13.
//  Copyright (c) 2013 Jonas BudelZNKMAnn. All rights reserved.
//

#import "View+ZNKMASAdditions.h"

#ifdef ZNKMAS_SHORTHAND

/**
 *	Shorthand view additions without the 'ZNKMAs_' prefixes,
 *  only enabled if ZNKMAS_SHORTHAND is defined
 */
@interface ZNKMAS_VIEW (ZNKMASShorthandAdditions)

@property (nonatomic, strong, readonly) ZNKMASViewAttribute *left;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *top;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *right;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *bottom;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *leading;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *trailing;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *width;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *height;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *centerX;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *centerY;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *baseline;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *(^attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) ZNKMASViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) ZNKMASViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *topMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *centerYWithinMargins;

#endif

- (NSArray *)ZNKMAkeConstraints:(void(^)(ZNKMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(ZNKMASConstraintMaker *make))block;
- (NSArray *)reZNKMAkeConstraints:(void(^)(ZNKMASConstraintMaker *make))block;

@end

#define ZNKMAS_ATTR_FORWARD(attr)  \
- (ZNKMASViewAttribute *)attr {    \
    return [self mas_##attr];   \
}

@implementation ZNKMAS_VIEW (ZNKMASShorthandAdditions)

ZNKMAS_ATTR_FORWARD(top);
ZNKMAS_ATTR_FORWARD(left);
ZNKMAS_ATTR_FORWARD(bottom);
ZNKMAS_ATTR_FORWARD(right);
ZNKMAS_ATTR_FORWARD(leading);
ZNKMAS_ATTR_FORWARD(trailing);
ZNKMAS_ATTR_FORWARD(width);
ZNKMAS_ATTR_FORWARD(height);
ZNKMAS_ATTR_FORWARD(centerX);
ZNKMAS_ATTR_FORWARD(centerY);
ZNKMAS_ATTR_FORWARD(baseline);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

ZNKMAS_ATTR_FORWARD(firstBaseline);
ZNKMAS_ATTR_FORWARD(lastBaseline);

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

ZNKMAS_ATTR_FORWARD(leftMargin);
ZNKMAS_ATTR_FORWARD(rightMargin);
ZNKMAS_ATTR_FORWARD(topMargin);
ZNKMAS_ATTR_FORWARD(bottomMargin);
ZNKMAS_ATTR_FORWARD(leadingMargin);
ZNKMAS_ATTR_FORWARD(trailingMargin);
ZNKMAS_ATTR_FORWARD(centerXWithinMargins);
ZNKMAS_ATTR_FORWARD(centerYWithinMargins);

#endif

- (ZNKMASViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self mas_attribute];
}

- (NSArray *)ZNKMAkeConstraints:(void(NS_NOESCAPE ^)(ZNKMASConstraintMaker *))block {
    return [self mas_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(NS_NOESCAPE ^)(ZNKMASConstraintMaker *))block {
    return [self mas_updateConstraints:block];
}

- (NSArray *)reZNKMAkeConstraints:(void(NS_NOESCAPE ^)(ZNKMASConstraintMaker *))block {
    return [self mas_remakeConstraints:block];
}

@end

#endif
