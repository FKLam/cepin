//
//  LoginAlterView.m
//  cepin
//
//  Created by dujincai on 15/11/23.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "LoginAlterView.h"
#import "TBAppDelegate.h"
#import "NSString+Extension.h"

@implementation LoginAlterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}



-(void)ShowLogin{
    if (self.accountExitsBg) {
        self.hidden  = NO;
        self.accountExitsBg.hidden = NO;
        self.bgView.hidden = NO;
        
    }else{
        self.accountExitsBg = [[UIButton alloc]initWithFrame:self.bounds];
        self.accountExitsBg.backgroundColor = [UIColor blackColor];
        self.accountExitsBg.alpha = 0.75;
        [self addSubview: self.accountExitsBg];
        //背景
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(20, self.viewCenterY - 100, self.viewWidth - 40, 150)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        //CGPointMake(self.viewCenterX, self.viewCenterY - 40);
        [self addSubview:self.bgView];
        
        @weakify(self)
        [ self.accountExitsBg handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            self.hidden  = YES;
            self.bgView.hidden = YES;
            self.accountExitsBg.hidden = YES;
            
        }];
        
        UILabel *titleLabel =  [[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.font = [[RTAPPUIHelper shareInstance] jobInformationSaleFont];
        titleLabel.text = @"提示";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.bgView.mas_top).offset(10);
            make.height.equalTo(@(45));
            make.width.equalTo(@(150));
        }];
        
        UILabel *accountExistLabel =  [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.viewHeight+titleLabel.viewY+10, self.viewWidth-50, 40)];
        accountExistLabel.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
        accountExistLabel.text = @"您还没登录,请登录才能使用此功能!";
        accountExistLabel.textAlignment = NSTextAlignmentLeft;
        accountExistLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
//        CGSize labelSize = {0, 0};
//        labelSize = [accountExistLabel.text sizeWithFont:[UIFont systemFontOfSize:14]
//                         constrainedToSize:CGSizeMake(self.viewWidth - 40, 5000)
//                             lineBreakMode:UILineBreakModeWordWrap];
//        //14 为UILabel的字体大小
//        //200为UILabel的宽度，5000是预设的一个高度，表示在这个范围内
//        accountExistLabel.numberOfLines = 0;//表示label可以多行显示
//        accountExistLabel.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
//        accountExistLabel.frame = CGRectMake(accountExistLabel.frame.origin.x, accountExistLabel.frame.origin.y, accountExistLabel.frame.size.width, labelSize.height);//保持原来Label的位置和宽度，只是改变高度。
        [self.bgView addSubview:accountExistLabel];
        [accountExistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.equalTo(@(40));
            make.width.equalTo(self.bgView.mas_width);
        }];
        
        UIView *endlineView = [[UIView alloc]initWithFrame:CGRectZero];
        endlineView.backgroundColor =[[RTAPPUIHelper shareInstance]lineColor];
        [self.bgView addSubview:endlineView];
        [endlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left);
            make.height.equalTo(@(1));
            make.width.equalTo(self.bgView.mas_width);
            make.top.equalTo(accountExistLabel.mas_bottom).offset(10);
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectZero;
        [cancelBtn setTitle:@"暂不登录" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[[RTAPPUIHelper shareInstance]subTitleColor] forState:UIControlStateNormal];
        [self.bgView addSubview:cancelBtn];
        [cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.accountExitsBg.hidden = YES;
            self.bgView.hidden = YES;
            self.hidden  = YES;
        }];
        
        UIView *centerlineView = [[UIView alloc]initWithFrame:CGRectZero];
        centerlineView.backgroundColor =[[RTAPPUIHelper shareInstance]lineColor];
        [self.bgView addSubview:centerlineView];
        [centerlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView.mas_centerX);
            make.height.equalTo(@(40));
            make.width.equalTo(@(1));
            make.top.equalTo(endlineView.mas_bottom);
        }];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectZero;
        [loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[[RTAPPUIHelper shareInstance]labelColorGreen] forState:UIControlStateNormal];
        [loginBtn setTitleColor:[[RTAPPUIHelper shareInstance]labelColorGreen] forState:UIControlStateSelected];
        [self.bgView addSubview:loginBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(20);
            make.width.equalTo(@(100));
            make.bottom.equalTo(centerlineView.mas_bottom);
            make.height.equalTo(centerlineView.mas_height);
        }];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-20);
            make.width.equalTo(@(100));
            make.bottom.equalTo(centerlineView.mas_bottom);
            make.height.equalTo(centerlineView.mas_height);
        }];
        [loginBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.accountExitsBg.hidden = YES;
            self.bgView.hidden = YES;
            self.hidden  = YES;
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate ChangeToLogin];
        }];
        
    }
    
}


@end
