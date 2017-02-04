//
//  UIView+ZNKMASAdditions.h
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "ZNKMASUtilities.h"
#import "ZNKMASConstraintmaker.h"
#import "ZNKMASViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating ZNKMASViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface ZNKMAS_VIEW (ZNKMASAdditions)

/**
 *	following properties return a new ZNKMASViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_left;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_top;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_right;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_bottom;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_leading;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_trailing;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_width;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_height;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_centerX;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_centerY;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_baseline;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *(^mas_attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_firstBaseline;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_leftMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_rightMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_topMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_bottomMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_leadingMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_trailingMargin;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_centerXWithinMargins;
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *mas_centerYWithinMargins;

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id mas_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)mas_closestCommonSuperview:(ZNKMAS_VIEW *)view;

/**
 *  Creates a ZNKMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created ZNKMASConstraints
 */
- (NSArray *)mas_makeConstraints:(void(NS_NOESCAPE ^)(ZNKMASConstraintMaker *make))block;

/**
 *  Creates a ZNKMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated ZNKMASConstraints
 */
- (NSArray *)mas_updateConstraints:(void(NS_NOESCAPE ^)(ZNKMASConstraintMaker *make))block;

/**
 *  Creates a ZNKMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated ZNKMASConstraints
 */
- (NSArray *)mas_remakeConstraints:(void(NS_NOESCAPE ^)(ZNKMASConstraintMaker *make))block;

@end
