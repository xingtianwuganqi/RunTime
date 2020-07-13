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

    // 动态创建对象, 在指定的位置(bytes)创建类实例。
    id theObject = class_createInstance(MyClass.class, 0); // 相当于alloc
    id str1 = [theObject init];
    NSLog(@"str1 的类名：%@",[str1 class]);
    id str2 = [[NSString alloc]initWithString:@"test"];
    NSLog(@"st2 的类型 %@",[str2 class]);
    
    /*
     实例操作函数
     实例操作函数主要是针对我们创建的实例对象的一系列操作函数，我们可以使用这组函数来从实例对象中获取我们想要的一些信息，如实例对象中变量的值
     */
    //1.针对整个对象进行操作的函数，这类函数包含
//    NSObject *a = [[NSObject alloc] init];
    //'object_copy'不可用:在自动引用计数模式下不可用
//    id newB = object_copy(a, class_getInstanceSize(MyClass.class));
    
    //2针对对象实例变量进行操作的函数
    
    // 返回指向给定对象分配的任何额外字节的指针
    object_getIndexedIvars(theObject);

    
    
    Ivar theStr = class_getInstanceVariable(cls, "_string");

    // 设置对象中实例变量的值
    object_setIvar(theObject,theStr , @"hello");
    // 返回对象中实例变量的值
    id strValue = object_getIvar(theObject, theStr);
    NSLog(@"theObject 的 value 是 %@",strValue);
    
    // 3.针对对象的类进行操作的函数
    // 返回给定对象的类名
    char *name = object_getClassName(theObject);
    NSLog(@"theObject class name is %s",name);
    
    // 返回对象的类
    Class className = object_getClass(theObject);
    NSLog(@"theOBject class's name %s",class_getName(className));
    
    // 返回对象的类
    Class nCls = object_setClass(theObject, newCls);
    NSLog(@"set theOBject class's name %s",class_getName(nCls));

    
    
    // 获取类定义
    /*
     Objective-C动态运行库会自动注册我们代码中定义的所有的类。我们也可以在运行时创建类定义并使用objc_addClass函数来注册它们
     */
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        //ARC不允许将非objective - c指针类型‘void *’隐式转换为‘剩余的unsafe_unretained类*’
//        classes = malloc(sizeof(Class) * numClasses);
//        numClasses = objc_getClassList(classes, numClasses)
    }
    
    // 类型编码
    /*
     作为对Runtime的补充，编译器将每个方法的返回值和参数类型编码为一个字符串，并将其与方法的selector关联在一起。这种编码方案在其它情况下也是非常有用的，因此我们可以使用@encode编译器指令来获取它。当给定一个类型时，@encode返回这个类型的字符串编码。这些类型可以是诸如int、指针这样的基本类型，也可以是结构体、类等类型。事实上，任何可以作为sizeof()操作参数的类型都可以用于@encode()。
     */
    float a[] = {1.0,2.0,3.0};
    NSLog(@"array encoding type is: %s",@encode(typeof(a)));

   // 成员变量和属性
    /*
     Ivar : Ivar是表示实例变量的类型，其实际是一个指向objc_ivar结构体的指针
     objc_property_t: objc_property_t是表示Objective-C声明的属性的类型，其实际是指向objc_property结构体的指针
     objc_property_attribute_t: objc_property_attribute_t定义了属性的特性(attribute)，它是一个结构体
     
     */
    
    /*
    关联对象
     
     内存管理策略，以告诉Runtime如何管理这个对象的内存。这个内存管理的策略可以由以下值指定：
     OBJC_ASSOCIATION_ASSIGN
     OBJC_ASSOCIATION_RETAIN_NONATOMIC
     OBJC_ASSOCIATION_COPY_NONATOMIC
     OBJC_ASSOCIATION_RETAIN
     OBJC_ASSOCIATION_COPY
     当宿主对象被释放时，会根据指定的内存管理策略来处理关联对象。如果指定的策略是assign，则宿主释放时，关联对象不会被释放；而如果指定的是retain或者是copy，则宿主释放时，关联对象会被释放。我们甚至可以选择是否是自动retain/copy。当我们需要在多个线程中处理访问关联对象的多线程代码时，这就非常有用了。
     
     */

    // 将一个对象连接到其他对象
//    static char myKey;
//
//    objc_setAssociatedObject(self, &myKey, anObject, OBJC_ASSOCIATION_RETAIN);
    
    /*
     方法和消息：
     //方法的selector用于表示运行时方 法的名字。Objective-C在编译时，会依据每一个方法的名字、参数序列，生成一个唯一的整型标识(Int类型的地址)，这个标识就是SEL
     
     两个类之间，不管它们是父类与子类的关系，还是之间没有这种关系，只要方法名相同，那么方法的SEL就是一样的。每一个方法都对应着一个SEL
     当然，不同的类可以拥有相同的selector，这个没有问题。不同类的实例对象执行相同的selector时，会在各自的方法列表中去根据selector去寻找自己对应的IMP。
     
     工程中的所有的SEL组成一个Set集合，Set的特点就是唯一，因此SEL是唯一的。因此，如果我们想到这个方法集合中查找某个方法时，只需要去 找到这个方法对应的SEL就行了，SEL实际上就是根据方法名hash化了的一个字符串，而对于字符串的比较仅仅需要比较他们的地址就可以了，可以说速度 上无语伦比！！但是，有一个问题，就是数量增多会增大hash冲突而导致的性能下降（或是没有冲突，因为也可能用的是perfect hash）。但是不管使用什么样的方法加速，如果能够将总量减少（多个方法可能对应同一个SEL），那将是最犀利的方法。那么，我们就不难理解，为什么 SEL仅仅是函数名了。

本质上，SEL只是一个指向方法的指针（准确的说，只是一个根据方法名hash化了的KEY值，能唯一代表一个方法），它的存在只是为了加快方法的查询速度
     
     我们可以在运行时添加新的selector，也可以在运行时获取已存在的selector，我们可以通过下面三种方法来获取SEL:

     sel_registerName函数

     Objective-C编译器提供的@selector()

     NSSelectorFromString()方法
     
     IMP实际上是一个函数指针，指向方法实现的首地址
     */
    
    
    
    return 0;
}


