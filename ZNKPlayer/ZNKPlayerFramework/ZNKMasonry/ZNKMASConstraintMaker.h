//
//  ZNKMASConstraintBuilder.h
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "ZNKMASConstraint.h"
#import "ZNKMASUtilities.h"

typedef NS_OPTIONS(NSInteger, ZNKMASAttribute) {
    ZNKMASAttributeLeft = 1 << NSLayoutAttributeLeft,
    ZNKMASAttributeRight = 1 << NSLayoutAttributeRight,
    ZNKMASAttributeTop = 1 << NSLayoutAttributeTop,
    ZNKMASAttributeBottom = 1 << NSLayoutAttributeBottom,
    ZNKMASAttributeLeading = 1 << NSLayoutAttributeLeading,
    ZNKMASAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    ZNKMASAttributeWidth = 1 << NSLayoutAttributeWidth,
    ZNKMASAttributeHeight = 1 << NSLayoutAttributeHeight,
    ZNKMASAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    ZNKMASAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    ZNKMASAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    ZNKMASAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    ZNKMASAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    ZNKMASAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    ZNKMASAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    ZNKMASAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    ZNKMASAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    ZNKMASAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    ZNKMASAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    ZNKMASAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    ZNKMASAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating ZNKMASConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface ZNKMASConstraintMaker : NSObject

/**
 *	The following properties return a new ZNKMASViewConstraint
 *  with the first item set to the ZNKMAkers associated view and the appropriate ZNKMASViewAttribute
 */
@property (nonatomic, strong, readonly) ZNKMASConstraint *left;
@property (nonatomic, strong, readonly) ZNKMASConstraint *top;
@property (nonatomic, strong, readonly) ZNKMASConstraint *right;
@property (nonatomic, strong, readonly) ZNKMASConstraint *bottom;
@property (nonatomic, strong, readonly) ZNKMASConstraint *leading;
@property (nonatomic, strong, readonly) ZNKMASConstraint *trailing;
@property (nonatomic, strong, readonly) ZNKMASConstraint *width;
@property (nonatomic, strong, readonly) ZNKMASConstraint *height;
@property (nonatomic, strong, readonly) ZNKMASConstraint *centerX;
@property (nonatomic, strong, readonly) ZNKMASConstraint *centerY;
@property (nonatomic, strong, readonly) ZNKMASConstraint *baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) ZNKMASConstraint *firstBaseline;
@property (nonatomic, strong, readonly) ZNKMASConstraint *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) ZNKMASConstraint *leftMargin;
@property (nonatomic, strong, readonly) ZNKMASConstraint *rightMargin;
@property (nonatomic, strong, readonly) ZNKMASConstraint *topMargin;
@property (nonatomic, strong, readonly) ZNKMASConstraint *bottomMargin;
@property (nonatomic, strong, readonly) ZNKMASConstraint *leadingMargin;
@property (nonatomic, strong, readonly) ZNKMASConstraint *trailingMargin;
@property (nonatomic, strong, readonly) ZNKMASConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) ZNKMASConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new ZNKMASCompositeConstraint with the first item set
 *  to the ZNKMAkers associated view and children corresponding to the set bits in the
 *  ZNKMASAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) ZNKMASConstraint *(^attributes)(ZNKMASAttribute attrs);

/**
 *	Creates a ZNKMASCompositeConstraint with type ZNKMASCompositeConstraintTypeEdges
 *  which generates the appropriate ZNKMASViewConstraint children (top, left, bottom, right)
 *  with the first item set to the ZNKMAkers associated view
 */
@property (nonatomic, strong, readonly) ZNKMASConstraint *edges;

/**
 *	Creates a ZNKMASCompositeConstraint with type ZNKMASCompositeConstraintTypeSize
 *  which generates the appropriate ZNKMASViewConstraint children (width, height)
 *  with the first item set to the ZNKMAkers associated view
 */
@property (nonatomic, strong, readonly) ZNKMASConstraint *size;

/**
 *	Creates a ZNKMASCompositeConstraint with type ZNKMASCompositeConstraintTypeCenter
 *  which generates the appropriate ZNKMASViewConstraint children (centerX, centerY)
 *  with the first item set to the ZNKMAkers associated view
 */
@property (nonatomic, strong, readonly) ZNKMASConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the ZNKMAker with a default view
 *
 *	@param	view	any ZNKMASConstrait are created with this view as the first item
 *
 *	@return	a new ZNKMASConstraintMaker
 */
- (id)initWithView:(ZNKMAS_VIEW *)view;

/**
 *	Calls install method on any ZNKMASConstraints which have been created by this ZNKMAker
 *
 *	@return	an array of all the installed ZNKMASConstraints
 */
- (NSArray *)install;

- (ZNKMASConstraint * (^)(dispatch_block_t))group;

@end
