//
//  ZNKMASConstraint+Private.h
//  ZNKMAsonry
//
//  Created by Nick Tymchenko on 29/04/14.
//  Copyright (c) 2014 cloudling. All rights reserved.
//

#import "ZNKMASConstraint.h"

@protocol ZNKMASConstraintDelegate;


@interface ZNKMASConstraint ()

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *	Usually ZNKMASConstraintMaker but could be a parent ZNKMASConstraint
 */
@property (nonatomic, weak) id<ZNKMASConstraintDelegate> delegate;

/**
 *  Based on a provided value type, is equal to calling:
 *  NSNumber - setOffset:
 *  NSValue with CGPoint - setPointOffset:
 *  NSValue with CGSize - setSizeOffset:
 *  NSValue with ZNKMASEdgeInsets - setInsets:
 */
- (void)setLayoutConstantWithValue:(NSValue *)value;

@end


@interface ZNKMASConstraint (Abstract)

/**
 *	Sets the constraint relation to given NSLayoutRelation
 *  returns a block which accepts one of the following:
 *    ZNKMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (ZNKMASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation;

/**
 *	Override to set a custom chaining behaviour
 */
- (ZNKMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end


@protocol ZNKMASConstraintDelegate <NSObject>

/**
 *	Notifies the delegate when the constraint needs to be replaced with another constraint. For example
 *  A ZNKMASViewConstraint ZNKMAy turn into a ZNKMASCompositeConstraint when an array is passed to one of the equality blocks
 */
- (void)constraint:(ZNKMASConstraint *)constraint shouldBeReplacedWithConstraint:(ZNKMASConstraint *)replacementConstraint;

- (ZNKMASConstraint *)constraint:(ZNKMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end
