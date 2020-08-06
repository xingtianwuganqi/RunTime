//
//  MainViewController.m
//  RunTimeDemo
//
//  Created by jingjun on 2020/7/13.
//  Copyright © 2020 jingjun. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+TapBlock.h"
#import "UIViewController+Tracking.h"
#import "UIScrollView+EmptyDateSet.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,EmptyDataSource>

@property (nonatomic,strong) UITableView * tableview;

@end

@implementation MainViewController

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    [self.view setTapActionWithBlock:^{
        NSLog(@"点击");
    }];
    NSLog(@"未点击");

    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSource = self;
    [self.tableview emptyText];
}
                                
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableviewcell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (NSString *)titleForEmtpyDateSet:(UIScrollView *)scrollView {
    return @"hello world";
}

@end
