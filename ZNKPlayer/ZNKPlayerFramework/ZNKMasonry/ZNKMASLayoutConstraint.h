//
//  ZNKMASLayoutConstraint.h
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 3/08/13.
//  Copyright (c) 2013 Jonas BudelZNKMAnn. All rights reserved.
//

#import "ZNKMASUtilities.h"

/**
 *	When you are debugging or printing the constraints attached to a view this subclass
 *  ZNKMAkes it easier to identify which constraints have been created via ZNKMAsonry
 */
@interface ZNKMASLayoutConstraint : NSLayoutConstraint

/**
 *	a key to associate with this constraint
 */
@property (nonatomic, strong) id mas_key;

@end
