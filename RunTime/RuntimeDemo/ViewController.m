//
//  ViewController.m
//  RuntimeDemo
//
//  Created by jingjun on 2020/5/26.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import "ViewController.h"
#import "UIView+TapBlock.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    [self.view setTapActionWithBlock:^{
        NSLog(@"点击");
    }];
}


@end
