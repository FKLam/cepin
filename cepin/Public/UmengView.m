//
//  UmengView.m
//  cepin
//
//  Created by zhu on 15/1/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "UmengView.h"
#import "TBAppDelegate.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "CPCommon.h"
@implementation UmengView

-(instancetype)init
{
    if (self = [super initWithFrame:[[UIScreen mainScreen]bounds]])
    {
        int cellWidth = kScreenWidth / 4.0;
        UIButton *button = [[UIButton alloc]initWithFrame:self.bounds];
        button.backgroundColor = [UIColor clearColor];
        [self addSubview:button];
        @weakify(self)
        [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            [self removeFromSuperview];
        }];
        NSMutableArray  *title = [[NSMutableArray alloc]init];
        NSMutableArray  *imgs = [[NSMutableArray alloc]init];
        if([WXApi isWXAppInstalled])
        {
            [title addObject:@"微信好友"];
            [title addObject:@"朋友圈"];
            [imgs addObject:@"UMS_wechat_icon_c"];
            [imgs addObject:@"UMS_wechat_ricle"];
        }
        [title addObject:@"新浪微博"];
        [imgs addObject:@"UMS_sina_on_c.png"];
        if([QQApiInterface isQQInstalled])
        {
            [title addObject:@"QQ"];
            [title addObject:@"QQ空间"];
            [imgs addObject:@"UMS_qq_icon_c"];
            [imgs addObject:@"UMS_qzone_on_c"];
        }
        UIView *maskView = nil;
        if( [title count] == 3 )
        {
            //阴影层
            maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - cellWidth)];
            maskView.backgroundColor = [UIColor blackColor];
            maskView.alpha = 0.18;
            [self addSubview:maskView];
        }
        else if( title.count == 5 )
        {
            //阴影层
            maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - cellWidth)];
            maskView.backgroundColor = [UIColor blackColor];
            maskView.alpha = 0.18;
            [self addSubview:maskView];
        }
        else
        {
            //阴影层
            maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 0)];
            maskView.backgroundColor = [UIColor blackColor];
            maskView.alpha = 0.18;
            [self addSubview:maskView];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
        [maskView addGestureRecognizer:tapGesture];
        NSInteger titleCount = title.count;
        CGFloat offsetY = kScreenHeight - cellWidth;
        CGFloat viewH = cellWidth;
        if ( titleCount > 4 )
        {
            offsetY -= cellWidth;
            viewH += cellWidth;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, offsetY, kScreenWidth, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        int xOffset = 0;
        int yOffset = 0;
        CGFloat imageW = 102 / CP_GLOBALSCALE;
        CGFloat labelH = 48 / CP_GLOBALSCALE;
        for (int i = 0; i < title.count; i++)
        {
            if ( i > 3 )
                yOffset = cellWidth;
            else
                yOffset = 0;
            xOffset = cellWidth * ( i % 4 );
            UIView *xLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)-1, CGRectGetWidth(view.frame), 1)];
            xLine.backgroundColor = UIColorFromRGB(0xf0f4f8);
            [view addSubview:xLine];
            UIView *yLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(view.frame)-1, 0, 1, CGRectGetHeight(view.frame))];
            yLine.backgroundColor = UIColorFromRGB(0xf0f4f8);
            [view addSubview:yLine];
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset + (cellWidth - imageW)/2, yOffset + (cellWidth - imageW)/2 - 10, imageW, imageW)];
            img.image = UIIMAGE([imgs objectAtIndex:i]);
            img.backgroundColor = [UIColor clearColor];
            [view addSubview:img];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, img.frame.origin.y + imageW, cellWidth, labelH)];
            lable.font = [UIFont systemFontOfSize:30 / CP_GLOBALSCALE];
            lable.text = [title objectAtIndex:i];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
            [view addSubview:lable];
            UIButton *touchBtn = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, cellWidth, cellWidth)];
            touchBtn.backgroundColor = [UIColor clearColor];
            [view addSubview:touchBtn];
            touchBtn.tag = i;
            [touchBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                @strongify(self)
                if ([self.delegate respondsToSelector:@selector(didChooseUmengView:)])
                {
                    UIButton *btn = (UIButton*)sender;
                    [self.delegate didChooseUmengView:(int)btn.tag];
                }
            }];
        }
        [self addSubview:view];
    }
    return self;
}
-(void)show
{
    //这个地方有时间加上弹出动画
    TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
}
-(void)disMiss
{
    //这个地方有时间加上隐藏动画
    [self removeFromSuperview];
}
@end
