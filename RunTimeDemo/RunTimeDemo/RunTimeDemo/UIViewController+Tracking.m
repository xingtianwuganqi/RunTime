//
//  UIViewController+Tracking.m
//  RunTimeDemo
//
//  Created by jingjun on 2020/7/14.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xb_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 添加方法 会覆盖父类的方法实现，但不会取代本类中已存在的实现，如果本类中包含一个同名的实现，则函数会返回NO
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            // 如果不存在添加，如果存在，替换
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            // 交换两个方法的实现
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)xb_viewWillAppear:(BOOL)animated {
    //在swizzling的过程中，方法中的[self xxx_viewWillAppear:animated]已经被重新指定到UIViewController类的-viewWillAppear:中。在这种情况下，不会产生无限循环。不过如果我们调用的是[self viewWillAppear:animated]，则会产生无限循环，因为这个方法的实现在运行时已经被重新指定为xxx_viewWillAppear:了。
    [self xb_viewWillAppear:animated];
    NSLog(@"viewWillAppear:==== %@", self);
}
@end
