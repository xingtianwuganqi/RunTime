//
//  UIView+TapBlock.m
//  RuntimeDemo
//
//  Created by jingjun on 2020/7/13.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import "UIView+TapBlock.h"
#import <objc/runtime.h>
static char kDTActionHandlerTapGestureKey ;
static char kDTActionHandlerTapBlockKey ;

@implementation UIView (TapBlock)

-(void)setTapActionWithBlock:(void(^)(void))block {
    UITapGestureRecognizer * gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

-(void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        if (action) {
            action();
        }
    }
}

@end
