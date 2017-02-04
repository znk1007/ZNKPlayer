//
//  UIViewController+ZNKMASAdditions.m
//  ZNKMAsonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+ZNKMASAdditions.h"

#ifdef ZNKMAS_VIEW_CONTROLLER

@implementation ZNKMAS_VIEW_CONTROLLER (ZNKMASAdditions)

- (ZNKMASViewAttribute *)mas_topLayoutGuide {
    return [[ZNKMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (ZNKMASViewAttribute *)mas_topLayoutGuideTop {
    return [[ZNKMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (ZNKMASViewAttribute *)mas_topLayoutGuideBottom {
    return [[ZNKMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (ZNKMASViewAttribute *)mas_bottomLayoutGuide {
    return [[ZNKMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (ZNKMASViewAttribute *)mas_bottomLayoutGuideTop {
    return [[ZNKMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (ZNKMASViewAttribute *)mas_bottomLayoutGuideBottom {
    return [[ZNKMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
