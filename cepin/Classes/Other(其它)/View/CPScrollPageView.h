//
//  CPScrollPageView.h
//  cepin
//
//  Created by ceping on 15-11-18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//  图片轮滚

#import <UIKit/UIKit.h>
@class CPScrollPageView;

/**
 *  自定义CPScrollPageView的协议
 */
@protocol CPScrollPageViewDelegate <NSObject>
@optional
/**
 *  点击一个imageView
 *
 *  @param view  滚动视图
 *  @param index 图片下标
 */
- (void)didClickPage:(CPScrollPageView *)view atIndex:(NSInteger)index;

@end

@interface CPScrollPageView : UIView
/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageViewArray;
/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  页码控件
 */
@property (nonatomic, weak) UIPageControl *pageControl;
/**
 *  CPScrollPageView的协议
 */
@property (nonatomic, weak) id<CPScrollPageViewDelegate> delegate;

/**
 *  是否自动展示图片
 *
 *  @param shouldStart 是否自动展示的参数
 */
- (void)shouldAutoShow:(BOOL)shouldStart;


@end
