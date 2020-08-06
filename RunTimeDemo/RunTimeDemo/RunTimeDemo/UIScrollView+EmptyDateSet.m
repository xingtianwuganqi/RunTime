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


#pragma mark - EmptyView
@interface EmptyDataView: UIView

@property (nonatomic,readonly) UIView *contentView;
@property (nonatomic,readonly) UILabel *titleLabel;
@property (nonatomic,readonly) UILabel *detailLabel;
@property (nonatomic,readonly) UIImageView *imageView;

@property (nonatomic, strong) UIView *customView;


@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

- (void)setupConstraints;
- (void)prepareForReuse;

@end

@interface EmptyDataView ()
@end

@implementation EmptyDataView

@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel,detailLabel = _detailLabel,imageView = _imageView;


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:27.0];

        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"empty set title";
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:17.0];

        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.accessibilityIdentifier = @"empty set title";
        [_contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        _imageView.accessibilityIdentifier = @"empty set background image";
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void)setCustomView:(UIView *)customView {
    if (!customView) {
        return;
    }
    
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    _customView = customView;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}

#pragma mark 方法实现
- (instancetype) init{
    self = [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)prepareForReuse {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    
}

- (void)setupConstraints {
    
}

- (BOOL)canShowImage {
    return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle {
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetailLab {
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (void)removeAllConstraints {
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

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
static char const * const kEmptyDataSetDelegate = "emptyDataSetDelegate";
static char const * const kEmptyDataView  = "emptyDataView";
@interface UIScrollView () <UIGestureRecognizerDelegate>
// 添加属性
@property (nonatomic,readonly) EmptyDataView *emptyDataView;

@end

@implementation UIScrollView (EmptyDateSet)

#pragma mark set方法
- (void)setEmptyDataSource:(id<EmptyDataSource>)dataSource {
    
    if (!dataSource || ![self canDisplay]) {
        [self invalidate];
    }
    
    objc_setAssociatedObject(self, kEmptyDataSetSource, [[EmptyDataWeakObjectContainer alloc]initWithWeakObject:dataSource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 方法互换
    
}

- (void)setEmptyDataDelegate:(id<EmptyDataDelegate>)emptyDataDelegate {
    
    if (!emptyDataDelegate) {
        [self invalidate];
    }
    
    objc_setAssociatedObject(self, kEmptyDataSetDelegate, [[EmptyDataWeakObjectContainer alloc] initWithWeakObject:emptyDataDelegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark get方法
- (id<EmptyDataSource>)emptyDataSource {
    EmptyDataWeakObjectContainer * objec = objc_getAssociatedObject(self, kEmptyDataSetSource);
    return objec.weakObject;
}

- (id<EmptyDataDelegate>)emptyDataDelegate {
    EmptyDataWeakObjectContainer * objc = objc_getAssociatedObject(self, kEmptyDataSetDelegate);
    return objc.weakObject;
}

#pragma mark emptyDataView set方法
- (void)setEmptyDataView:(EmptyDataView *)emptyDataView {
    objc_setAssociatedObject(self, kEmptyDataView, emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EmptyDataView *)emptyDataView {
    EmptyDataView *view = objc_getAssociatedObject(self, kEmptyDataView);
    if (!view) {
        view = [EmptyDataView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        view.tapGesture.delegate = self;
        [view addGestureRecognizer:view.tapGesture];
        
        [self setEmptyDataView:view];
    }
    return view;
}

- (void)didTapContentView:(id)sender{
    NSLog(@"didTapContentView");
}

- (void)emptyText {
    if (self.emptyDataSource && [self.emptyDataSource respondsToSelector:@selector(titleForEmtpyDateSet:)]) {
        NSString * string = [self.emptyDataSource titleForEmtpyDataSet:self];
        NSLog(@"%@",string);
    }else{
        NSLog(@"emptyDataSource 为空");
    }
}

// 是否可以显示，判断是否有这个属性，是否遵守了这个协议
- (BOOL)canDisplay {
    if (self.emptyDataSource && [self.emptyDataSource conformsToProtocol:@protocol(EmptyDataSource)]) {
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]]) {
            return YES;
        }
    }
    return NO;
}

// 判断是否有数据
- (NSInteger)itemsCount {
    NSInteger items = 0;
    // 如果UIScrollView 没有响应 datasource 方法，直接退出
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        id<UITableViewDataSource> dataSource = tableView.dataSource;
        NSInteger sections = 1;
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section ++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        id<UICollectionViewDataSource> dataSource = collectionView.dataSource;
        NSInteger sections = 1;
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section ++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    return items;
}

// 获取DataSource 返回的字符串
- (NSString *) titleLabelString {
    if (self.emptyDataSource && [self.emptyDataSource respondsToSelector:@selector(titleForEmtpyDataSet:)]) {
        NSString *string = [self.emptyDataSource titleForEmtpyDataSet:self];
        if (string) NSAssert([string isKindOfClass:[NSString class]], @"You must return a valid NSAttributedString object for -titleForEmptyDataSet:");
        return string;
    }
    return nil;
}

- (void)invalidate {
    [self dzn_willDisappear];
    
    if (self.emptyDataView) {
        [self.emptyDataView prepareForReuse];
        [self.emptyDataView removeFromSuperview];
        [self setEmptyDataView:nil];
    }
    self.scrollEnabled = YES;
    
    [self dzn_didDisappear];
}

- (void)dzn_willDisappear {
    if (self.emptyDataDelegate && [self.emptyDataDelegate respondsToSelector:@selector(emptyDataSetWillDisappear:)]) {
        [self.emptyDataDelegate emptyDataSetWillDisappear:self];
    
    }
}

- (void)dzn_didDisappear {
    if (self.emptyDataDelegate && [self.emptyDataDelegate respondsToSelector:@selector(emptyDataSetDidDisappear:)]) {
        [self.emptyDataDelegate emptyDataSetDidDisappear:self];
    }
}

@end
