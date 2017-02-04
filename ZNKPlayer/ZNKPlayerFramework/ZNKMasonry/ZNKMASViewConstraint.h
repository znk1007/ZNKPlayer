//
//  ZNKMASConstraint.h
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "ZNKMASViewAttribute.h"
#import "ZNKMASConstraint.h"
#import "ZNKMASLayoutConstraint.h"
#import "ZNKMASUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface ZNKMASViewConstraint : ZNKMASConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) ZNKMASViewAttribute *secondViewAttribute;

/**
 *	initialises the ZNKMASViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.mas_left, view.mas_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(ZNKMASViewAttribute *)firstViewAttribute;

/**
 *  Returns all ZNKMASViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of ZNKMASViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(ZNKMAS_VIEW *)view;

@end
