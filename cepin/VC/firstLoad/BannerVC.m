//
//  BannerVC.m
//  cepin
//
//  Created by ceping on 15-1-15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BannerVC.h"
#import "TBAppDelegate.h"
#import "DynamicWebVC.h"
#import "CPCommon.h"
@interface BannerVC ()
@property (nonatomic, assign) int secondsCountDown; // 倒计时总时厂
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) BOOL isClickedButton;
@end
@implementation BannerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:image];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"CepinBannerOne.png"];
    NSData *data=[NSData dataWithContentsOfFile:uniquePath];
    //直接把该图片读出来
    image.image=[UIImage imageWithData:data];
    NSString *isShow = [[NSUserDefaults standardUserDefaults]objectForKey:@"isShow"];
    if (isShow && [isShow isEqualToString:@"1"])
    {
        //跳到专题详情页面
        UIButton *jumpBannerDedaail = [UIButton buttonWithType:UIButtonTypeCustom];
        jumpBannerDedaail.frame = self.view.bounds;
        [self.view addSubview:jumpBannerDedaail];
        [jumpBannerDedaail handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"btn_skip"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:1] forKey:@"isFirstLaunch"];
            if ([self.delegate respondsToSelector:@selector(cancelAutoLogin:)])
            {
                [self.delegate cancelAutoLogin:@""];
                [MobClick event:@"start_AD_click"];
            }
        }];
    }
    // 跳过按钮
    self.jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jumpButton.frame = CGRectMake( kScreenWidth - 120 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE, 30, 120 / CP_GLOBALSCALE, 120 / CP_GLOBALSCALE );
    self.jumpButton.layer.cornerRadius = 120 / CP_GLOBALSCALE / 2.0;
    self.jumpButton.layer.masksToBounds = YES;
    self.jumpButton.backgroundColor = [UIColor whiteColor];
    self.jumpButton.titleLabel.font = [[RTAPPUIHelper shareInstance] mainTitleFont];
    [self.jumpButton setTitleColor:[[RTAPPUIHelper shareInstance] labelColorGreen] forState:UIControlStateNormal];
    [self.view addSubview:self.jumpButton];
    [self.jumpButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [MobClick event:@"btn_skip"];
        if ([self.delegate respondsToSelector:@selector(jumpAdvertisement)]) {
            [self.delegate jumpAdvertisement];
            self.isClickedButton = YES;
        }
    }];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.jumpButton.viewX, self.jumpButton.viewY + ( 120 - 48 ) / CP_GLOBALSCALE / 2.0 - 48 / CP_GLOBALSCALE / 4.0, 120 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE)];
    label.text = @"跳过";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"288add"];
    label.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    [self.view addSubview:label];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.viewX, CGRectGetMaxY( label.frame ), 120 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.timeLabel];
//    [self startTime];
    self.secondsCountDown = 5;
    NSString *strTime = [NSString stringWithFormat:@"%ds", self.secondsCountDown];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strTime];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, 1)];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:NSMakeRange(1, 1)];
    //设置界面的按钮显示 根据自己需求设置
    [self.timeLabel setAttributedText:attString];
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
//    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    NSRunLoop *currentRunLoop = currentRunLoop = [[NSRunLoop alloc] init];
    [currentRunLoop addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
}
//倒计时
- (void)startTime
{
    __block int timeout = 5; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if( timeout <= 0 ){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"0s"];
                [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, 1)];
                [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:NSMakeRange(1, 1)];
               [self.timeLabel setAttributedText:attString];
                if ( [self.delegate respondsToSelector:@selector(bannerVC:isFinishTime:)] && !self.isClickedButton )
                {
                    [self.delegate bannerVC:self isFinishTime:!self.isClickedButton];
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *strTime = [NSString stringWithFormat:@"%ds", timeout];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strTime];
                [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, 1)];
                [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:NSMakeRange(1, 1)];
                //设置界面的按钮显示 根据自己需求设置
                [self.timeLabel setAttributedText:attString];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)timeFireMethod
{
    if( self.secondsCountDown <= 0 )
    {
        //倒计时结束，关闭
        [self.countDownTimer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置界面的按钮显示 根据自己需求设置
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"0s"];
            [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, 1)];
            [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:NSMakeRange(1, 1)];
            [self.timeLabel setAttributedText:attString];
            if ( [self.delegate respondsToSelector:@selector(bannerVC:isFinishTime:)] && !self.isClickedButton )
            {
                [self.delegate bannerVC:self isFinishTime:!self.isClickedButton];
            }
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *strTime = [NSString stringWithFormat:@"%ds", self.secondsCountDown];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strTime];
            [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, 1)];
            [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:NSMakeRange(1, 1)];
            //设置界面的按钮显示 根据自己需求设置
            [self.timeLabel setAttributedText:attString];
        });
        self.secondsCountDown--;
    }
}
@end
