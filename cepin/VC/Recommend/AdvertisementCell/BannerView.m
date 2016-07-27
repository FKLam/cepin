//
//  BannerView.m
//  cepin
//
//  Created by dujincai on 15/9/8.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BannerView.h"
#import "MobClick.h"

@interface BannerView()
@end

@implementation BannerView
@synthesize delegate;

-(instancetype)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr
{
    if ( (self = [super initWithFrame:rect]) ) {
        
        self.userInteractionEnabled=YES;
        
        imageArray = [NSArray arrayWithArray:imgArr];
        
        viewSize = rect;
       
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
       
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        if (imgArr.count == 1) {
            scrollView.scrollEnabled = NO;
        }else
        {
            scrollView.scrollEnabled = YES;
        }
        for (int i = 0; i < pageCount; i++) {
            UIImageView *imgView = [imageArray objectAtIndex:i];
            [imgView setFrame:CGRectMake(viewSize.size.width * i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag = i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            
            [scrollView addSubview:imgView];
        }
        [self addSubview:scrollView];

        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20 / 3.0 * 2, self.bounds.size.width, 20 / 3.0)];
        
        noteView.backgroundColor = [UIColor clearColor];
        float pageControlWidth = (pageCount - 1) * 50 / 3.0 + pageCount * 20 / 3.0;
        float pagecontrolHeight = 20.0 / 3.0;
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width - pageControlWidth) / 2, 0, pageControlWidth, pagecontrolHeight)];
        pageControl.currentPage = 0;
        pageControl.numberOfPages = pageCount;
        [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"ffffff"]];
        [pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"e1e1e3"]];
        [noteView addSubview:pageControl];
        
        if (imgArr.count == 1) {
            pageControl.hidden = YES;
        }else
        {
            pageControl.hidden = NO;
        }
        [self addSubview:noteView];
        
        [self addTimer0];
    }
    return self;
}

- (void)addTimer0
{
    timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    // 消息循环
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [timer invalidate];
}

- (void)nextImage
{
    // 当前页码
    NSInteger page = pageControl.currentPage;
    
    if ( page == pageControl.numberOfPages - 1 )
        page = 0;
    else
        page++;
    
    CGFloat offsetX = page * scrollView.frame.size.width;
    [UIView animateWithDuration:1.0 animations:^{
        scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //统计图片切换
    [MobClick event:@"banner_change"];
    
    int page = ( scrollView.contentOffset.x + scrollView.frame.size.width / 2 ) / scrollView.frame.size.width;
    pageControl.currentPage = page;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    [self addTimer0];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器
    [self removeTimer];
}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        
        NSInteger index = sender.view.tag + 1;
        
        [delegate EScrollerViewDidClicked:index];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
