//
//  UIScrollView+EmptyDateSet.h
//  RunTimeDemo
//
//  Created by jingjun on 2020/7/29.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EmptyDataSource <NSObject>

@optional

-(NSString *)titleForEmtpyDataSet:(UIScrollView *) scrollView;

@end

@protocol EmptyDataDelegate <NSObject>

@optional

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView;
- (void)emptyDataSetDidDisappear: (UIScrollView *)scrollView;


@end

@interface UIScrollView (EmptyDateSet)

@property(nonatomic, weak, nullable) id <EmptyDataSource>emptyDataSource;
@property(nonatomic, weak, nullable) id <EmptyDataDelegate> emptyDataDelegate;
- (void)emptyText;
@end

NS_ASSUME_NONNULL_END
