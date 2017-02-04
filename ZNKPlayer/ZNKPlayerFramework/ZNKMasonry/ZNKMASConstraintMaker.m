//
//  ZNKMASConstraintBuilder.m
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "ZNKMASConstraintmaker.h"
#import "ZNKMASViewConstraint.h"
#import "ZNKMASCompositeConstraint.h"
#import "ZNKMASConstraint+Private.h"
#import "ZNKMASViewAttribute.h"
#import "View+ZNKMASAdditions.h"

@interface ZNKMASConstraintMaker () <ZNKMASConstraintDelegate>

@property (nonatomic, weak) ZNKMAS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation ZNKMASConstraintMaker

- (id)initWithView:(ZNKMAS_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [ZNKMASViewConstraint installedConstraintsForView:self.view];
        for (ZNKMASConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (ZNKMASConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - ZNKMASConstraintDelegate

- (void)constraint:(ZNKMASConstraint *)constraint shouldBeReplacedWithConstraint:(ZNKMASConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (ZNKMASConstraint *)constraint:(ZNKMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    ZNKMASViewAttribute *viewAttribute = [[ZNKMASViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    ZNKMASViewConstraint *newConstraint = [[ZNKMASViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:ZNKMASViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        ZNKMASCompositeConstraint *compositeConstraint = [[ZNKMASCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (ZNKMASConstraint *)addConstraintWithAttributes:(ZNKMASAttribute)attrs {
    __unused ZNKMASAttribute anyAttribute = (ZNKMASAttributeLeft | ZNKMASAttributeRight | ZNKMASAttributeTop | ZNKMASAttributeBottom | ZNKMASAttributeLeading
                                          | ZNKMASAttributeTrailing | ZNKMASAttributeWidth | ZNKMASAttributeHeight | ZNKMASAttributeCenterX
                                          | ZNKMASAttributeCenterY | ZNKMASAttributeBaseline
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
                                          | ZNKMASAttributeFirstBaseline | ZNKMASAttributeLastBaseline
#endif
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
                                          | ZNKMASAttributeLeftMargin | ZNKMASAttributeRightMargin | ZNKMASAttributeTopMargin | ZNKMASAttributeBottomMargin
                                          | ZNKMASAttributeLeadingMargin | ZNKMASAttributeTrailingMargin | ZNKMASAttributeCenterXWithinMargins
                                          | ZNKMASAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & ZNKMASAttributeLeft) [attributes addObject:self.view.mas_left];
    if (attrs & ZNKMASAttributeRight) [attributes addObject:self.view.mas_right];
    if (attrs & ZNKMASAttributeTop) [attributes addObject:self.view.mas_top];
    if (attrs & ZNKMASAttributeBottom) [attributes addObject:self.view.mas_bottom];
    if (attrs & ZNKMASAttributeLeading) [attributes addObject:self.view.mas_leading];
    if (attrs & ZNKMASAttributeTrailing) [attributes addObject:self.view.mas_trailing];
    if (attrs & ZNKMASAttributeWidth) [attributes addObject:self.view.mas_width];
    if (attrs & ZNKMASAttributeHeight) [attributes addObject:self.view.mas_height];
    if (attrs & ZNKMASAttributeCenterX) [attributes addObject:self.view.mas_centerX];
    if (attrs & ZNKMASAttributeCenterY) [attributes addObject:self.view.mas_centerY];
    if (attrs & ZNKMASAttributeBaseline) [attributes addObject:self.view.mas_baseline];
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    if (attrs & ZNKMASAttributeFirstBaseline) [attributes addObject:self.view.mas_firstBaseline];
    if (attrs & ZNKMASAttributeLastBaseline) [attributes addObject:self.view.mas_lastBaseline];
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    if (attrs & ZNKMASAttributeLeftMargin) [attributes addObject:self.view.mas_leftMargin];
    if (attrs & ZNKMASAttributeRightMargin) [attributes addObject:self.view.mas_rightMargin];
    if (attrs & ZNKMASAttributeTopMargin) [attributes addObject:self.view.mas_topMargin];
    if (attrs & ZNKMASAttributeBottomMargin) [attributes addObject:self.view.mas_bottomMargin];
    if (attrs & ZNKMASAttributeLeadingMargin) [attributes addObject:self.view.mas_leadingMargin];
    if (attrs & ZNKMASAttributeTrailingMargin) [attributes addObject:self.view.mas_trailingMargin];
    if (attrs & ZNKMASAttributeCenterXWithinMargins) [attributes addObject:self.view.mas_centerXWithinMargins];
    if (attrs & ZNKMASAttributeCenterYWithinMargins) [attributes addObject:self.view.mas_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (ZNKMASViewAttribute *a in attributes) {
        [children addObject:[[ZNKMASViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    ZNKMASCompositeConstraint *constraint = [[ZNKMASCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (ZNKMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (ZNKMASConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (ZNKMASConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (ZNKMASConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (ZNKMASConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (ZNKMASConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (ZNKMASConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (ZNKMASConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (ZNKMASConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (ZNKMASConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (ZNKMASConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (ZNKMASConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (ZNKMASConstraint *(^)(ZNKMASAttribute))attributes {
    return ^(ZNKMASAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__ZNKMAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (ZNKMASConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (ZNKMASConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif


#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (ZNKMASConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (ZNKMASConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (ZNKMASConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (ZNKMASConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (ZNKMASConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (ZNKMASConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (ZNKMASConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (ZNKMASConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (ZNKMASConstraint *)edges {
    return [self addConstraintWithAttributes:ZNKMASAttributeTop | ZNKMASAttributeLeft | ZNKMASAttributeRight | ZNKMASAttributeBottom];
}

- (ZNKMASConstraint *)size {
    return [self addConstraintWithAttributes:ZNKMASAttributeWidth | ZNKMASAttributeHeight];
}

- (ZNKMASConstraint *)center {
    return [self addConstraintWithAttributes:ZNKMASAttributeCenterX | ZNKMASAttributeCenterY];
}

#pragma mark - grouping

- (ZNKMASConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        ZNKMASCompositeConstraint *constraint = [[ZNKMASCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
