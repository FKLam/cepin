//
//  TBLoading.m
//  cepin
//
//  Created by zhu on 14/12/28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "TBLoading.h"
#import "TBAppDelegate.h"

@implementation TBLoading

-(instancetype)init
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]])
    {
        gifImage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        gifImage.center = self.center;
        [self addSubview:gifImage];
        self.images = [[UIImageView alloc]initWithFrame:gifImage.bounds];
        self.images.image = [UIImage imageNamed:@"index_load"];
        [gifImage addSubview:self.images];
        self.animation = [ CABasicAnimation animationWithKeyPath: @"transform"];
        self.animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        //围绕Z轴旋转，垂直与屏幕
        self.animation.toValue = [ NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0)];
        self.animation.duration = 0.5;
        //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
        self.animation.cumulative = YES;
        self.animation.repeatCount = 1000;
        //在图片边缘添加一个像素的透明区域，去图片锯齿
        CGRect imageRrect = CGRectMake(0, 0,self.images.frame.size.width, self.images.frame.size.height);
        UIGraphicsBeginImageContext(imageRrect.size);
        [self.images.image drawInRect:CGRectMake(1,1,self.images.frame.size.width-2,self.images.frame.size.height-2)];
        self.images.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        loadingLable = [[UILabel alloc]initWithFrame:CGRectZero];
        loadingLable.textAlignment = NSTextAlignmentCenter;
        loadingLable.backgroundColor = [UIColor clearColor];
        loadingLable.text = @"正在加载中...";
        loadingLable.font = [UIFont systemFontOfSize:14];
        loadingLable.textColor = [UIColor whiteColor];
        [self addSubview:loadingLable];
        @weakify(self)
        [loadingLable mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(gifImage.mas_bottom).offset(4);
            make.height.equalTo(@(21));
        }];
        touchButton = [[UIButton alloc]initWithFrame:self.bounds];
        [self addSubview:touchButton];
        touchButton.backgroundColor = [UIColor clearColor];
        [touchButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            if ( !self.isCanTouchRemove )
                [self clear];
        }];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
    }
    return self;
}
-(void)start
{
    TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
    BOOL isExist = NO;
    for ( UIView *subView in delegate.window.subviews )
    {
        if ( [subView isKindOfClass:[TBLoading class]] )
        {
            isExist = YES;
            break;
        }
    }
    if ( !isExist )
        [delegate.window addSubview:self];
    else
    {
        if ( self.isWaitFor )
            [delegate.window addSubview:self];
    }
    [self.images.layer addAnimation:self.animation forKey:nil];
}
- (void)startWithView:(UIView *)view
{
    if ( view )
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self.images.layer addAnimation:self.animation forKey:nil];
    }
}
-(void)stop
{
    [self clear];
}
-(void)Run
{
}
-(void)clear
{
    [self.images.layer removeAllAnimations];
    if (gifImage)
    {
        [gifImage removeFromSuperview];
        gifImage = nil;
    }
    if (loadingLable)
    {
        [loadingLable removeFromSuperview];
        loadingLable = nil;
    }
    if (touchButton)
    {
        [touchButton removeFromSuperview];
        touchButton = nil;
    }
    [self removeFromSuperview];
}
@end
