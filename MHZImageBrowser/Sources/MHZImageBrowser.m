//
//  MHZImageBrowser.m
//  MHZImageBrowser
//
//  Created by muhuai on 4/15/16.
//  Copyright © 2016 MuHuai. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IMAGE_TAG 3469
#import "MHZImageBrowser.h"
#import <objc/runtime.h>

extern NSString *const kScrollViewDelegateKey = @"kScrollViewDelegateKey";
@interface MHZImageBrowser()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end
@implementation MHZImageBrowser
- (void)showImages:(NSArray<UIImage *> *)images {
    
    CGFloat contentWidth = SCREEN_WIDTH * images.count;
    self.scrollView.contentSize = CGSizeMake(contentWidth, SCREEN_HEIGHT);
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageScrollView.maximumZoomScale = 3.f;
        imageScrollView.delegate = self;
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:obj];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = IMAGE_TAG;
        
        CGRect imageFrame = imageView.frame;
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        CGFloat p = imageFrame.size.width / width;
        CGFloat height = CGRectGetHeight(imageFrame) / p;
        imageView.frame = CGRectMake(0, 0, width, height);
        
        imageView.center = self.scrollView.center;
        imageScrollView.scrollsToTop = YES;
        imageScrollView.contentSize = CGSizeMake(width, height);
        [imageScrollView addSubview:imageView];
        [self.scrollView addSubview:imageScrollView];
    }];
    
    UIView *containerView = [UIApplication sharedApplication].keyWindow;
    [containerView addSubview:self.scrollView];
    
    self.pageControl.numberOfPages = images.count;
    [self.pageControl sizeToFit];
    [containerView addSubview:self.pageControl];
    
    NSLayoutConstraint *pageControlCenterXconstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
    NSLayoutConstraint *pageControlYconstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeBottom multiplier:1.f constant:-30.f];
    [containerView addConstraints:@[pageControlCenterXconstraint, pageControlYconstraint]];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return;
    }
    NSInteger currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageControl.currentPage = currentIndex;
}

#pragma mark UIScrollViewDelegate-Zoom
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView *imageView = [scrollView viewWithTag:IMAGE_TAG];
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = 0.0, offsetY = 0.0;
    if (scrollView.bounds.size.width > scrollView.contentSize.width) {
        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    }
    if (scrollView.bounds.size.height > scrollView.contentSize.height) {
        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    }
    [self viewForZoomingInScrollView:scrollView].center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
//    [self viewForZoomingInScrollView:scrollView].center = self.scrollView.center;
}

#pragma mark getter & setter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        objc_setAssociatedObject(_scrollView, kScrollViewDelegateKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
