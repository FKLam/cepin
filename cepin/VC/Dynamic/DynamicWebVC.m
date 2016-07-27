//
//  DynamicWebVC.m
//  cepin
//
//  Created by zhu on 15/2/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "DynamicWebVC.h"

@interface DynamicWebVC ()<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView   *webView;
@property(nonatomic,retain)NSString    *urlString;
@property(nonatomic,retain)UILabel     *loadLalbe;

@end

@implementation DynamicWebVC

-(instancetype)initWithTitleAndlUrl:(NSString*)title url:(NSString*)urlString
{
    if (self = [super init])
    {
        self.title = title;
        self.urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    
    self.loadLalbe = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.loadLalbe];
    [self.loadLalbe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@(20));
    }];
    
    self.loadLalbe.backgroundColor = [UIColor clearColor];
    self.loadLalbe.textAlignment = NSTextAlignmentCenter;
    self.loadLalbe.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    self.loadLalbe.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.loadLalbe.text = @"加载中......";
    self.webView.hidden = YES;
    
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *urlstr = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *mUrl = [NSString stringWithFormat:@"%@/#/atm?userId=%@&target=%@",kHostMUrl,userId,urlstr];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mUrl]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.webView.hidden = NO;
        self.loadLalbe.hidden = YES;
    });

    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadLalbe.hidden = YES;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
