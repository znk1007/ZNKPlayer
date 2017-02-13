//
//  KeyboardManager.m
//  ZNKPlayer
//
//  Created by HuangSam on 2017/2/13.
//  Copyright © 2017年 HM. All rights reserved.
//

#import "ZNKKeyboardManager.h"

#define znk_screenWidth [UIScreen mainScreen].bounds.size.width
#define znk_screenHeight [UIScreen mainScreen].bounds.size.height
#define znk_navigationBarHeight 64

@interface ZNKKeyboardManager ()

@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) CGRect targetViewOriginFrame;
@property (nonatomic, assign) CGRect containerViewOriginFrame;
@property (nonatomic, assign) CGFloat contentOffset;
@property (nonatomic, assign) BOOL hasNav;
@property (nonatomic, copy) void(^keyboardShowHandler)(CGRect keyboardFrame, NSNotification *notification);
@property (nonatomic, copy) void(^keyboardHideHandler)(CGRect keyboardFrame, NSNotification *notification);

@end

@implementation ZNKKeyboardManager

- (void)dealloc{
    self.keyboardShowHandler = nil;
    self.keyboardHideHandler = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTargetView:(UIView *)targetView containerView:(UIView *)containView hasNav:(BOOL)has contentOffset:(CGFloat)offset showBlock:(void(^)(CGRect keyboardFrame, NSNotification *notification))show hideBlock:(void(^)(CGRect keyboardFrame, NSNotification *notification))hide{
    self = [super init];
    if (self) {
        if (!targetView || !containView) {
            self.targetView = [[UIView alloc] init];
            self.containerView = [[UIView alloc] init];
        }
        self.targetView = targetView;
        self.targetViewOriginFrame = self.targetView.frame;
        self.containerView = containView;
        self.containerViewOriginFrame = self.containerView.frame;
        self.keyboardHideHandler = hide;
        self.keyboardShowHandler = show;
        self.contentOffset = offset;
        self.hasNav = has;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardShowNotification:(NSNotification *)note{
    CGRect keyboardFrame = CGRectZero;
    NSDictionary *userInfo = note.userInfo;
    keyboardFrame = ((NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    NSNumber *durationNumber = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:durationNumber.doubleValue delay:0 options:curveNumber.unsignedIntegerValue animations:^{
        
        CGFloat navHeight = self.hasNav == YES ? 64 : 0;
        CGFloat keyboardMinY = znk_screenHeight - CGRectGetHeight(keyboardFrame);
        CGFloat targetMinY = CGRectGetMinY(self.containerView.frame) - navHeight + CGRectGetMinY(self.targetView.frame);
        CGFloat targetMaxY = CGRectGetMinY(self.containerView.frame) - navHeight + CGRectGetMaxY(self.targetView.frame) + self.contentOffset;
        if (targetMaxY > keyboardMinY) {
            CGFloat viewKeyboardDistance = targetMinY - keyboardMinY;
            CGFloat resultDistance = CGRectGetHeight(self.targetView.frame) + viewKeyboardDistance + self.contentOffset + navHeight;
            self.containerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMinY(self.containerView.frame) - resultDistance, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
        }else{
            //            self.containerView.frame = self.containerViewOriginFrame;
            self.containerView.frame = CGRectMake(CGRectGetMinX(self.containerView.frame), CGRectGetMinY(self.containerView.frame), CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
        }
        
        if (_keyboardShowHandler) {
            _keyboardShowHandler(keyboardFrame, note);
        }
    } completion:nil];
}

- (void)keyboardHideNotification:(NSNotification *)note{
    CGRect keyboardFrame = CGRectZero;
    NSDictionary *userInfo = note.userInfo;
    keyboardFrame = ((NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    NSNumber *durationNumber = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:durationNumber.doubleValue delay:0 options:curveNumber.unsignedIntegerValue animations:^{
        self.containerView.frame = self.containerViewOriginFrame;
        self.targetView.frame = self.targetViewOriginFrame;
        if (_keyboardHideHandler) {
            _keyboardHideHandler(CGRectZero, note);
        }
    } completion:nil];
}


@end
