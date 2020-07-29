//
//  UIScrollView+EmptyDateSet.h
//  RunTimeDemo
//
//  Created by jingjun on 2020/7/29.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EmptyDateSource <NSObject>

@optional

-(NSString *)titleForEmtpyDateSet:(UIScrollView *) scrollView;

@end

@interface UIScrollView (EmptyDateSet)

@property(nonatomic, weak, nullable) id <EmptyDateSource>emptyDataSource;
- (void)emptyText;
@end

NS_ASSUME_NONNULL_END
