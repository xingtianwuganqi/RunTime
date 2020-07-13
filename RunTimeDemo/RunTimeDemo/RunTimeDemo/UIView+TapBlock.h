//
//  UIView+TapBlock.h
//  RuntimeDemo
//
//  Created by jingjun on 2020/7/13.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TapBlock)
-(void)setTapActionWithBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
