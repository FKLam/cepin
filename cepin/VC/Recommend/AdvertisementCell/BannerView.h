//
//  BannerView.h
//  cepin
//
//  Created by dujincai on 15/9/8.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
@end

@interface BannerView : UIView<UIScrollViewDelegate> {
    CGRect viewSize;
    UIScrollView *scrollView;
    NSArray *imageArray;
    UIPageControl *pageControl;
    id<BannerViewDelegate> delegate;
    int currentPageIndex;
    NSTimer *timer;
}
@property(nonatomic,assign) int times;
@property(nonatomic,retain)id<BannerViewDelegate> delegate;

-(instancetype)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr;

- (void)addTimer0;
@end
