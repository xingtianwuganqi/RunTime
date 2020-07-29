//
//  UIScrollView+EmptyDateSet.m
//  RunTimeDemo
//
//  Created by jingjun on 2020/7/29.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import "UIScrollView+EmptyDateSet.h"
#import <objc/runtime.h>

@interface EmptyDataWeakObjectContainer : NSObject

@property (nonatomic,readonly,weak) id weakObject;

- (instancetype)initWithWeakObject: (id) object;

@end

#pragma mark - DZNWeakObjectContainer

@implementation EmptyDataWeakObjectContainer

- (instancetype)initWithWeakObject:(id)object
{
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}

@end

static char const * const kEmptyDataSetSource = "emptyDataSetSource";

@implementation UIScrollView (EmptyDateSet)

- (void)setEmptyDataSource:(id<EmptyDateSource>)dataSource {
        
    objc_setAssociatedObject(self, kEmptyDataSetSource, [[EmptyDataWeakObjectContainer alloc]initWithWeakObject:dataSource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id<EmptyDateSource>)emptyDataSource {
    EmptyDataWeakObjectContainer * objec = objc_getAssociatedObject(self, kEmptyDataSetSource);
    return objec.weakObject;
}

- (void)emptyText {
    if (self.emptyDataSource && [self.emptyDataSource respondsToSelector:@selector(titleForEmtpyDateSet:)]) {
        NSString * string = [self.emptyDataSource titleForEmtpyDateSet:self];
        NSLog(@"%@",string);
    }else{
        NSLog(@"emptyDataSource 为空");
    }
}

@end
