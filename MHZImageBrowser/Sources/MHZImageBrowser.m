//
//  MHZImageBrowser.m
//  MHZImageBrowser
//
//  Created by muhuai on 4/15/16.
//  Copyright © 2016 MuHuai. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "MHZImageBrowser.h"
#import <objc/runtime.h>

@interface MHZImageBrowser()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end
@implementation MHZImageBrowser
- (void)showImages:(NSArray<UIImage *> *)images {
    
    CGFloat contentWidth = SCREEN_WIDTH * images.count;
    self.scrollView.contentSize = CGSizeMake(contentWidth, SCREEN_HEIGHT);
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = obj;
        [self.scrollView addSubview:imageView];
    }];
    
    UIView *containerView = [UIApplication sharedApplication].keyWindow;
    [containerView addSubview:self.scrollView];
    
    self.pageControl.numberOfPages = images.count;
    [self.pageControl sizeToFit];
    [containerView addSubview:self.pageControl];
    
    NSLayoutConstraint *pageControlCenterXconstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
    NSLayoutConstraint *pageControlYconstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeBottom multiplier:1.f constant:-50.f];
    [containerView addConstraints:@[pageControlCenterXconstraint, pageControlYconstraint]];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageControl.currentPage = currentIndex;
}
#pragma mark getter & setter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        objc_setAssociatedObject(_scrollView, @"1", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _scrollView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _pageControl;
}
@end
