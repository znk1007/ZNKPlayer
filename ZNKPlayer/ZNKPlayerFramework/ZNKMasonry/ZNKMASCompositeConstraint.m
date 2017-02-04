//
//  ZNKMASCompositeConstraint.m
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "ZNKMASCompositeConstraint.h"
#import "ZNKMASConstraint+Private.h"

@interface ZNKMASCompositeConstraint () <ZNKMASConstraintDelegate>

@property (nonatomic, strong) id mas_key;
@property (nonatomic, strong) NSMutableArray *childConstraints;

@end

@implementation ZNKMASCompositeConstraint

- (id)initWithChildren:(NSArray *)children {
    self = [super init];
    if (!self) return nil;

    _childConstraints = [children mutableCopy];
    for (ZNKMASConstraint *constraint in _childConstraints) {
        constraint.delegate = self;
    }

    return self;
}



#pragma mark - ZNKMASConstraintDelegate

- (void)constraint:(ZNKMASConstraint *)constraint shouldBeReplacedWithConstraint:(ZNKMASConstraint *)replacementConstraint {
    NSUInteger index = [self.childConstraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.childConstraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (ZNKMASConstraint *)constraint:(ZNKMASConstraint __unused *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    id<ZNKMASConstraintDelegate> strongDelegate = self.delegate;
    ZNKMASConstraint *newConstraint = [strongDelegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    newConstraint.delegate = self;
    [self.childConstraints addObject:newConstraint];
    return newConstraint;
}

#pragma mark - NSLayoutConstraint multiplier proxies 

- (ZNKMASConstraint * (^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        for (ZNKMASConstraint *constraint in self.childConstraints) {
            constraint.multipliedBy(multiplier);
        }
        return self;
    };
}

- (ZNKMASConstraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        for (ZNKMASConstraint *constraint in self.childConstraints) {
            constraint.dividedBy(divider);
        }
        return self;
    };
}

#pragma mark - ZNKMASLayoutPriority proxy

- (ZNKMASConstraint * (^)(ZNKMASLayoutPriority))priority {
    return ^id(ZNKMASLayoutPriority priority) {
        for (ZNKMASConstraint *constraint in self.childConstraints) {
            constraint.priority(priority);
        }
        return self;
    };
}

#pragma mark - NSLayoutRelation proxy

- (ZNKMASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attr, NSLayoutRelation relation) {
        for (ZNKMASConstraint *constraint in self.childConstraints.copy) {
            constraint.equalToWithRelation(attr, relation);
        }
        return self;
    };
}

#pragma mark - attribute chaining

- (ZNKMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    [self constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    return self;
}

#pragma mark - AniZNKMAtor proxy

#if TARGET_OS_ZNKMAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (ZNKMASConstraint *)aniZNKMAtor {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        [constraint aniZNKMAtor];
    }
    return self;
}

#endif

#pragma mark - debug helpers

- (ZNKMASConstraint * (^)(id))key {
    return ^id(id key) {
        self.mas_key = key;
        int i = 0;
        for (ZNKMASConstraint *constraint in self.childConstraints) {
            constraint.key([NSString stringWithFormat:@"%@[%d]", key, i++]);
        }
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant setters

- (void)setInsets:(ZNKMASEdgeInsets)insets {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        constraint.insets = insets;
    }
}

- (void)setInset:(CGFloat)inset {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        constraint.inset = inset;
    }
}

- (void)setOffset:(CGFloat)offset {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        constraint.offset = offset;
    }
}

- (void)setSizeOffset:(CGSize)sizeOffset {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        constraint.sizeOffset = sizeOffset;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        constraint.centerOffset = centerOffset;
    }
}

#pragma mark - ZNKMASConstraint

- (void)activate {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        [constraint activate];
    }
}

- (void)deactivate {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        [constraint deactivate];
    }
}

- (void)install {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
}

- (void)uninstall {
    for (ZNKMASConstraint *constraint in self.childConstraints) {
        [constraint uninstall];
    }
}

@end
