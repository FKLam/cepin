//
//  NOQQVC.m
//  cepin
//
//  Created by dujincai on 15/8/24.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "NOQQVC.h"

@interface NOQQVC ()
@property(nonatomic ,strong)NSString *QQurl;
@end

@implementation NOQQVC

- (instancetype)initWithStrQQ:(NSString *)QQurl
{
    self = [super init];
    if (self) {
        self.QQurl = QQurl;
    }
    return self;
}
-(void)clickedBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)backBarButtonWith:(id)target selector:(SEL)selector
{
    int hight = IS_IPHONE_5?50:65;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-10, 0, hight, hight);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [button setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    button.titleLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIButton *btn = (UIButton *)[item customView];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return item;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self backBarButtonWith:self selector:@selector(clickedBackBtn:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *qqImage = [[UIImageView alloc]init];
    qqImage.image = [UIImage imageNamed:@"logo_qq"];
    [self.view addSubview:qqImage];
    [qqImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(54));
        make.height.equalTo(@(54));
        
    }];
    
    UILabel *QQLabel = [[UILabel alloc]init];
    QQLabel.text = @"QQ";
    QQLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    QQLabel.font = [[RTAPPUIHelper shareInstance]bigTitleFont];
    QQLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:QQLabel];
    [QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqImage.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(50));
        make.height.equalTo(@(20));
    }];
    
    UILabel *subLabel = [[UILabel alloc]init];
    subLabel.text = @"您没有安装最新版本QQ,请先下载并安装,登录更快更安全.";
    subLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    subLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.numberOfLines = 0;
    [self.view addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QQLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.equalTo(@(40));
    }];
     int texthight = IS_IPHONE_5?40:48;
    UIButton *QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [QQButton setTitle:@"下载" forState:UIControlStateNormal];
    QQButton.titleLabel.font = [[RTAPPUIHelper shareInstance]bigTitleFont];
    QQButton.backgroundColor = RGBCOLOR(246, 140, 77);
    QQButton.layer.cornerRadius = 8;
    QQButton.layer.masksToBounds = YES;
    [self.view addSubview:QQButton];
    
    [QQButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@(texthight));
    }];
    
    [QQButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.QQurl]];
    }];
    
    UIButton *retroaction = [UIButton buttonWithType:UIButtonTypeCustom];
    [retroaction setTitle:@"反馈建议" forState:UIControlStateNormal];
    retroaction.titleLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    [retroaction setTitleColor:[[RTAPPUIHelper shareInstance]labelColorGreen] forState:UIControlStateNormal];
    retroaction.backgroundColor = [UIColor clearColor];
    [self.view addSubview:retroaction];
    
    [retroaction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QQButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(280));
        make.height.equalTo(@(30));
    }];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"Copyright @ 2010-2016 Tencent. All Right Resverved";
    timeLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    timeLabel.font = [[RTAPPUIHelper shareInstance]titleFont];
    timeLabel.textAlignment = NSTextAlignmentCenter;
   
    timeLabel.numberOfLines = 0;
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(retroaction.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(280));
        make.height.equalTo(@(40));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
