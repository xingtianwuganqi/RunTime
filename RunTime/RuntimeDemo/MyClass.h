//
//  MyClass.h
//  RuntimeDemo
//
//  Created by jingjun on 2020/5/26.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyClass : NSObject

@property(nonatomic ,strong) NSArray *array;

@property(nonatomic,copy) NSString *string;

- (void)method1;
- (void)method2;
+ (void)classMethod1;

@end

NS_ASSUME_NONNULL_END
