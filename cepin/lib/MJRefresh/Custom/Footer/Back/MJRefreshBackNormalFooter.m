//
//  MJRefreshBackNormalFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshBackNormalFooter.h"
#import "NSString+Extension.h"

@interface MJRefreshBackNormalFooter()
{
    __unsafe_unretained UIImageView *_arrowView;
    
    __weak UIImageView *_customLoadingView;
    
    __weak UIImageView *_nomoreDataView;
}
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation MJRefreshBackNormalFooter
#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImage *image = [UIImage imageNamed:MJRefreshSrcName(@"ic_arrow_up.png")] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(@"ic_arrow_up.png")];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (UIImageView *)customLoadingView
{
    if( !_customLoadingView )
    {
        UIImage *image = [UIImage imageNamed:MJRefreshSrcName(@"ic_loading.png")] ? : [UIImage imageNamed:MJRefreshFrameworkSrcName(@"ic_loading.png")];
        UIImageView *customLoadingView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_customLoadingView = customLoadingView];
        
        [self addAnimation];
    }
    return _customLoadingView;
}

- (UIImageView *)nomoreDataView
{
    if ( !_nomoreDataView )
    {
        UIImage *image = [UIImage imageNamed:MJRefreshSrcName(@"ic_radio_null.png")] ? : [UIImage imageNamed:MJRefreshFrameworkSrcName(@"ic_radio_null.png")];
        UIImageView *nomoreDataView = [[UIImageView alloc] initWithImage:image];
        nomoreDataView.hidden = YES;
        [self addSubview:_nomoreDataView = nomoreDataView];
    }
    return _nomoreDataView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}

- (void)addAnimation
{
    [self.customLoadingView.layer removeAllAnimations];
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation.toValue = [NSNumber numberWithFloat:50 * M_PI];
    rotation.duration = 10;
    rotation.repeatCount = CGFLOAT_MAX;
    
    [self.customLoadingView.layer addAnimation:rotation forKey:@"rotation"];
}

#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头
    self.arrowView.mj_size = self.arrowView.image.size;
    CGFloat arrowCenterX = self.mj_w * 0.5;
    CGSize stateSize = [NSString caculateTextSize:self.stateLabel];
    if (!self.stateLabel.hidden) {
        arrowCenterX -= (stateSize.width + self.arrowView.mj_w) / 2.0 + 18.0;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    self.arrowView.center = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 圈圈
    self.loadingView.frame = self.arrowView.frame;
    
    self.customLoadingView.frame = self.arrowView.frame;

    self.nomoreDataView.frame = self.arrowView.frame;
    
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                
                self.customLoadingView.alpha = 0.0;
                
                self.nomoreDataView.alpha = 0.0;
                
            } completion:^(BOOL finished) {

                self.customLoadingView.alpha = 1.0;
                [self stopCustomLoading];
                
                self.arrowView.hidden = NO;
            }];
        } else {
            self.arrowView.hidden = NO;
            
            [self stopCustomLoading];
            
            self.nomoreDataView.hidden = YES;
            
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    }
    else if (state == MJRefreshStatePulling) {
        self.arrowView.hidden = NO;
        
        [self stopCustomLoading];
        
        self.nomoreDataView.hidden = YES;
        
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformIdentity;
        }];
    }
    else if (state == MJRefreshStateRefreshing) {
        self.arrowView.hidden = YES;
        
        [self startCustomLoading];
        
        self.nomoreDataView.hidden = YES;
    }
    else if (state == MJRefreshStateNoMoreData) {
        self.arrowView.hidden = YES;
        self.loadingView.hidden = YES;
        [self placeSubviews];
        
        [self stopCustomLoading];
    }
}

- (void)startCustomLoading
{
    self.customLoadingView.hidden = NO;
    
    [self addAnimation];
}

- (void)stopCustomLoading
{
    self.customLoadingView.hidden = YES;
    [self.customLoadingView.layer removeAllAnimations];
}

@end
