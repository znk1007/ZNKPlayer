//
//  KeyboardManager.h
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/13.
//  Copyright © 2017年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNKKeyboardManager : NSObject

- (instancetype)initWithTargetView:(UIView *)targetView containerView:(UIView *)containView hasNav:(BOOL)has contentOffset:(CGFloat)offset showBlock:(void(^)(CGRect keyboardFrame, NSNotification *notification))show hideBlock:(void(^)(CGRect keyboardFrame, NSNotification *notification))hide;

@end
