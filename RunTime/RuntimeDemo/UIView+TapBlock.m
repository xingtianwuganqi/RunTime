//
//  UIView+TapBlock.m
//  RuntimeDemo
//
//  Created by jingjun on 2020/7/13.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import "UIView+TapBlock.h"
#import <objc/runtime.h>
#define kDTActionHandlerTapGestureKey "tapkey"
#define kDTActionHandlerTapBlockKey "blockkey"
@implementation UIView (TapBlock)

-(void)setTapActionWithBlock:(void(^)(void))block {
    UITapGestureRecognizer * gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

-(void)__handleActonForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
        if (action) {
            action();
        }
    }
}

@end
