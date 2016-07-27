//
//  CepinProtoVC.m
//  cepin
//
//  Created by ceping on 15-1-4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CepinProtoVC.h"

@interface CepinProtoVC ()<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView *webView;

@end

@implementation CepinProtoVC
-(void)clickedBackBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"服务条款";
    [RTAPPUIHelper initTitleWith:self selector:@selector(clickedBackBtn:) parentView:self.view title:@"服务条款"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, (IsIOS7)?44+20:44, self.view.viewWidth - 20, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"TermsOfService" ofType:@"htm"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   
}
@end
