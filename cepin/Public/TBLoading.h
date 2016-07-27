//
//  TBLoading.h
//  cepin
//
//  Created by zhu on 14/12/28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBLoading: UIView
{
    NSTimer  *timer;
    UIView *gifImage;
    UILabel  *loadingLable;
    UIButton  *touchButton;
    int      currentIndex;
    double  angle;

}

@property(nonatomic,strong)UIImageView *images;
@property(nonatomic,strong)CABasicAnimation *animation;
@property (nonatomic, assign) BOOL isWaitFor;
@property (nonatomic, assign) BOOL isCanTouchRemove;

-(void)start;
- (void)startWithView:(UIView *)view;
-(void)stop;

@end
