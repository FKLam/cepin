//
//  BaseWebVC.m
//  cepin
//
//  Created by ceping on 15-1-16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseWebVC.h"

@interface BaseWebVC ()<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView   *webView;
@property(nonatomic,retain)NSString    *urlString;
@property(nonatomic,retain)UILabel     *loadLalbe;

@end

@implementation BaseWebVC

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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    self.loadLalbe.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    self.loadLalbe.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
