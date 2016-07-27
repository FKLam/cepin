//
//  CPScrollPageView.m
//  cepin
//
//  Created by ceping on 15-11-18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CPScrollPageView.h"

@interface CPScrollPageView ()<UIScrollViewDelegate>
/**
 *  第一个图片视图
 */
@property (nonatomic, weak) UIView *firstView;
/**
 *  第二个图片视图
 */
@property (nonatomic, weak) UIView *middleView;
/**
 *  第三个图片视图
 */
@property (nonatomic, weak) UIView *lastView;
/**
 *  图片视图的宽度
 */
@property (nonatomic, assign) CGFloat viewWidth;
/**
 *  图片视图的高度
 */
@property (nonatomic, assign) CGFloat viewHeight;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *autoScrollTimer;
/**
 *  点击手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation CPScrollPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _viewWidth = self.bounds.size.width;
        _viewHeight = self.bounds.size.height;
        
        // 设置scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        [self addSubview:scrollView];
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(_viewWidth, _viewHeight);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor blackColor];
        _scrollView = scrollView;
        
        // 设置分页
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _viewHeight - 20, _viewWidth, 30)];
        [self addSubview:pageControl];
        pageControl.userInteractionEnabled = YES;
        pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl = pageControl;
        
        // 设置手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_scrollView addGestureRecognizer:tap];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _tap = tap;
    }
    return self;
}

#pragma mark - 单击手势
- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    // 判断是否实现了代理的方法
    if([self.delegate respondsToSelector:@selector(didClickPage:atIndex:)])
    {
        [self.delegate didClickPage:self atIndex:self.currentPage];
    }
}

#pragma mark - 设置imageViewArray
- (void)setImageViewArray:(NSMutableArray *)imageViewArray
{
    if(imageViewArray)
    {
        _imageViewArray = [imageViewArray copy];
        
        // 默认为第0页
        self.currentPage = 0;
        
        self.pageControl.numberOfPages = self.imageViewArray.count;
    }
    
    // 刷新页面
    [self reloadData];
}

#pragma mark - 刷新view页面
- (void)reloadData
{
    // 重新设置数据时，移除图片视图
    [self.firstView removeFromSuperview];
    [self.middleView removeFromSuperview];
    [self.lastView removeFromSuperview];
    
    // 从数组中取到对应的图片view加到已定义的三个view中
    if( 0 == self.currentPage )
    {
        self.firstView = [self.imageViewArray lastObject];
        self.middleView = [self.imageViewArray objectAtIndex:self.currentPage];
        self.lastView = [self.imageViewArray objectAtIndex:self.currentPage + 1];
    }
    else if( self.imageViewArray.count - 1 == self.currentPage )
    {
        self.firstView = [self.imageViewArray objectAtIndex:self.currentPage - 1];
        self.middleView = [self.imageViewArray objectAtIndex:self.currentPage];
        self.lastView = [self.imageViewArray firstObject];
    }
    else
    {
        self.firstView = [self.imageViewArray objectAtIndex:self.currentPage - 1];
        self.middleView = [self.imageViewArray objectAtIndex:self.currentPage];
        self.lastView = [self.imageViewArray objectAtIndex:self.currentPage + 1];
    }
    
    // 设置三个view的frame，加到scrollView上
    self.firstView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    self.middleView.frame = CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight);
    self.lastView.frame = CGRectMake(self.viewWidth * 2, 0, self.viewWidth, self.viewHeight);
    
    // 设置当前的分页
    self.pageControl.currentPage = self.currentPage;
    
    // 显示中间页
    self.scrollView.contentOffset = CGPointMake(self.viewWidth, 0);
}

#pragma mark - scrollView停止滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.autoScrollTimer)
    {
        // 手动滑动时候暂停自动替换
        [self.autoScrollTimer invalidate];
        
        self.autoScrollTimer = nil;
    }
    
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
    
    // 得到当前页数
    CGFloat x = self.scrollView.contentOffset.x;
    
    // 向前翻
    if( x <= 0 )
    {
        if( self.currentPage - 1 < 0 )
            self.currentPage = self.imageViewArray.count - 1;
        else
            self.currentPage--;
    }
    
    // 往后翻
    if( x >= self.viewWidth * 2 )
    {
        if( self.currentPage == self.imageViewArray.count - 1 )
            self.currentPage = 0;
        else
            self.currentPage++;
    }
    
    // 刷新数据
    [self reloadData];
}

#pragma mark - 自动滚动
- (void)shouldAutoShow:(BOOL)shouldStart
{
    if( shouldStart )
    {
        if( !self.autoScrollTimer )
        {
            self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
        }
    }
    else
    {
        if( self.autoScrollTimer.isValid )
        {
            [self.autoScrollTimer invalidate];
            self.autoScrollTimer = nil;
        }
    }
}

#pragma mark - 展示下一页
- (void)autoShowNextImage
{
    if( self.currentPage == self.imageViewArray.count - 1 )
    {
        self.currentPage = 0;
    }
    else
    {
        self.currentPage++;
    }
    
    // 刷新数据
    [self reloadData];
}
@end
