//
//  ZNKMASUtilities.h
//  ZNKMAsonry
//
//  Created by Jonas BudelZNKMAnn on 19/08/13.
//  Copyright (c) 2013 Jonas BudelZNKMAnn. All rights reserved.
//

#import <Foundation/Foundation.h>



#if TARGET_OS_IPHONE || TARGET_OS_TV

    #import <UIKit/UIKit.h>
    #define ZNKMAS_VIEW UIView
    #define ZNKMAS_VIEW_CONTROLLER UIViewController
    #define ZNKMASEdgeInsets UIEdgeInsets

    typedef UILayoutPriority ZNKMASLayoutPriority;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityRequired = UILayoutPriorityRequired;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityDefaultHigh = UILayoutPriorityDefaultHigh;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityDefaultMedium = 500;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityDefaultLow = UILayoutPriorityDefaultLow;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityFittingSizeLevel = UILayoutPriorityFittingSizeLevel;

#elif TARGET_OS_MAC

    #import <AppKit/AppKit.h>
    #define ZNKMAS_VIEW NSView
    #define ZNKMASEdgeInsets NSEdgeInsets

    typedef NSLayoutPriority ZNKMASLayoutPriority;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityRequired = NSLayoutPriorityRequired;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityDefaultHigh = NSLayoutPriorityDefaultHigh;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityDragThatCanResizeWindow = NSLayoutPriorityDragThatCanResizeWindow;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityDefaultMedium = 501;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityWindowSizeStayPut = NSLayoutPriorityWindowSizeStayPut;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityDragThatCannotResizeWindow = NSLayoutPriorityDragThatCannotResizeWindow;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityDefaultLow = NSLayoutPriorityDefaultLow;
    static const ZNKMASLayoutPriority ZNKMASLayoutPriorityFittingSizeCompression = NSLayoutPriorityFittingSizeCompression;

#endif

/**
 *	Allows you to attach keys to objects ZNKMAtching the variable names passed.
 *
 *  view1.mas_key = @"view1", view2.mas_key = @"view2";
 *
 *  is equivalent to:
 *
 *  ZNKMASAttachKeys(view1, view2);
 */
#define ZNKMASAttachKeys(...)                                                        \
    {                                                                             \
        NSDictionary *keyPairs = NSDictionaryOfVariableBindings(__VA_ARGS__);     \
        for (id key in keyPairs.allKeys) {                                        \
            id obj = keyPairs[key];                                               \
            NSAssert([obj respondsToSelector:@selector(setmas_key:)],             \
                     @"Cannot attach mas_key to %@", obj);                        \
            [obj setmas_key:key];                                                 \
        }                                                                         \
    }

/**
 *  Used to create object hashes
 *  Based on http://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
 */
#define ZNKMAS_NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define ZNKMAS_NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (ZNKMAS_NSUINT_BIT - howmuch)))

/**
 *  Given a scalar or struct value, wraps it in NSValue
 *  Based on EXPObjectify: https://github.com/specta/expecta
 */
static inline id _ZNKMASBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(ZNKMASEdgeInsets)) == 0) {
        ZNKMASEdgeInsets actual = (ZNKMASEdgeInsets)va_arg(v, ZNKMASEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define ZNKMASBoxValue(value) _ZNKMASBoxValue(@encode(__typeof__((value))), (value))
