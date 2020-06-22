//
//  TestClass.m
//  RuntimeDemo
//
//  Created by jingjun on 2020/6/22.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import "TestClass.h"
#import <objc/runtime.h>

@implementation TestClass

- (void) ex_registerClassPair {
    Class newClass = objc_allocateClassPair([NSError class], "TestClassly", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMateClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)]; // 执行
}

void TestMateClass(id self,SEL _cmd) {
    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}

@end
