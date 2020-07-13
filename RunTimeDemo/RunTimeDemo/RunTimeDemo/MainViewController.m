//
//  MainViewController.m
//  RunTimeDemo
//
//  Created by jingjun on 2020/7/13.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+TapBlock.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    [self.view setTapActionWithBlock:^{
        NSLog(@"点击");
    }];
    NSLog(@"未点击");

    
}
                                
                    

@end
