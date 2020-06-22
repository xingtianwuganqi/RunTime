//
//  main.m
//  RuntimeDemo
//
//  Created by jingjun on 2020/5/26.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyClass.h"
#import <objc/runtime.h>
#import "TestClass.h"

int main(int argc, char * argv[]) {
//    NSString * appDelegateClassName;
//    @autoreleasepool {
//        // Setup code that might create autoreleased objects goes here.
//        appDelegateClassName = NSStringFromClass([AppDelegate class]);
//    }
    
    TestClass *test = [[TestClass alloc]init];
    [test ex_registerClassPair];
    
    MyClass *myClass = [[MyClass alloc]init];
    unsigned int outCount = 0;
    
    Class cls = myClass.class;
    
    NSLog(@"class name : %s",class_getName(cls));
    
    NSLog(@"super class name: %s",class_getName(class_getSuperclass(cls)));
    
    NSLog(@"MyClass is %s a meta-class",class_isMetaClass(cls) ? "YES" : "NO");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"meta_class is %@",meta_class);
    
    NSLog(@"instance size: %zu",class_getInstanceSize(cls));
    
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name is %s at index: %d",ivar_getName(ivar),i);
    }
    
    free(ivars);
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    
    if (string != NULL) {
        NSLog(@"instace variable %s",ivar_getName(string));
    }
    
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i ++ ) {
        objc_property_t property = properties[i];
        NSLog(@"property name is: %s",property_getName(property));
    }
    
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s",property_getName(array));
    }
    
    // 方法操作
    Method * methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method name is: %s",method_getName(method));
    }
    
    free(methods);
    
    Method meth = class_getInstanceMethod(cls, @selector(method1));
    if (meth != NULL) {
        NSLog(@"method is: %s",method_getName(meth));
    }
    
    Method classMeth = class_getClassMethod(cls, @selector(classMethod1));
    if (classMeth != NULL) {
        NSLog(@"class_method is : %s",method_getName(classMeth));
    }
    
    NSLog(@"MyClass is %@ responsd to selector: method2WithArg1:Arg2:",class_getInstanceMethod(cls, @selector(method3WithArg1:Arg2:)) ? @"" : @" not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol *protocol;
    for (int i = 0; i < outCount;i ++) {
        protocol = CFBridgingRelease(properties[i]);
        NSLog(@"protocol name : %s",protocol_getName(protocol));
    }

    NSLog(@"MyClass is %@ responsed to protocol %s",class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
    // 动态创建一个类
    Class newCls = objc_allocateClassPair(MyClass.class, "MySubClass", 0);
    IMP mysubMethod1 = NULL;
    if( class_addMethod(newCls, @selector(mysubMethod1),(IMP)mysubMethod1, "v@:")){
        
//        class_replaceMethod(newCls, @selector(method1),  (IMP)mysubMethod1,"v@:");
        
    }
    Method *mysubMethods = class_copyMethodList(newCls, &outCount);
    for (int i = 0;i < outCount; i ++ ){
        Method mysubMeth = mysubMethods[i];
        NSLog(@"mysubMeth Name is %s:",method_getName(mysubMeth));
    }
    
    free(mysubMethods);
    
    // 添加成员变量
    class_addIvar(newCls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    Ivar *newIvars = class_copyIvarList(newCls, &outCount);
    for (int i = 0;i < outCount;i++) {
        Ivar newivar = newIvars[i];
        NSLog(@"newivar name is : %s",ivar_getName(newivar));
    }
    
    // 添加属性
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = {"C",""};
    objc_property_attribute_t backimgivar = {"V","_ivar1"};
    objc_property_attribute_t attrs[] = {type,ownership,backimgivar};
    
    class_addProperty(newCls, "property2", attrs, 3);
    objc_registerClassPair(newCls);
    
    // 获取属性
    objc_property_t * newPros = class_copyPropertyList(newCls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t newProperty = newPros[i];
        NSLog(@"newProperty name is %s :",property_getName(newProperty));
    }
    
    free(newPros);
    
    id instance = [[newCls alloc] init];
//    [instance performSelector:@selector(mysubMethod1:)];
    [instance performSelector:@selector(method1)];

    // 动态创建对象
    id theObject = class_createInstance(MyClass.class, 0); // 相当于alloc
    id str1 = [theObject init];
    NSLog(@"str1 的类名：%@",[str1 class]);
    id str2 = [[NSString alloc]initWithString:@"test"];
    NSLog(@"st2 的类型 %@",[str2 class]);
    
    // 实例操作函数
//    NSObject *a = [[NSObject alloc] init];
//    id newB = object_copy(a, class_getInstanceSize(MyClass.class));
    
    // 获取类定义
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
//        classes = malloc(sizeof(Class) * numClasses);
//        numClasses = objc_getClassList(classes, numClasses)
    }

    // 方法和消息
    SEL sell = @selector(method1);
    NSLog(@"sel : %p",sell);
    
    return 0;
}


