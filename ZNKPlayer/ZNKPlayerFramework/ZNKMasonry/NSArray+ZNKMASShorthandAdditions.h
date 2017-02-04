//
//  NSArray+ZNKMASShorthandAdditions.h
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 22/07/13.
//  Copyright (c) 2013 Jonas BudelZNKMAnn. All rights reserved.
//

#import "NSArray+ZNKMASAdditions.h"

#ifdef ZNKMAS_SHORTHAND

/**
 *	Shorthand array additions without the 'ZNKMAs_' prefixes,
 *  only enabled if ZNKMAS_SHORTHAND is defined
 */
@interface NSArray (ZNKMASShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(ZNKMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(ZNKMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(ZNKMASConstraintMaker *make))block;

@end

@implementation NSArray (ZNKMASShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(ZNKMASConstraintMaker *))block {
    return [self mas_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(ZNKMASConstraintMaker *))block {
    return [self mas_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(ZNKMASConstraintMaker *))block {
    return [self mas_reZNKMAkeConstraints:block];
}

@end

#endif
