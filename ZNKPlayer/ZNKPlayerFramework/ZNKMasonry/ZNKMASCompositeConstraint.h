//
//  ZNKMASCompositeConstraint.h
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "ZNKMASConstraint.h"
#import "ZNKMASUtilities.h"

/**
 *	A group of ZNKMASConstraint objects
 */
@interface ZNKMASCompositeConstraint : ZNKMASConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child ZNKMASConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
