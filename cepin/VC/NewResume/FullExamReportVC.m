//
//  FullExamReportVC.m
//  cepin
//
//  Created by dujincai on 15/7/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullExamReportVC.h"
#import "FullExamReportVM.h"
#import "DynamicExamModelDTO.h"

@interface FullExamReportVC ()<UIWebViewDelegate>
@property(nonatomic,strong)FullExamReportVM *viewModel;
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,retain)NSString  *urlString;

@end

@implementation FullExamReportVC
- (instancetype)initWithString:(NSString *)str
{
    self = [super init];
    if (self) {
        self.urlString = str;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"测评报告";

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    self.webView.delegate = self;
    
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
    
    CFStringRef urlstr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.urlString, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    NSString *mUrl = [NSString stringWithFormat:@"%@/#/atm?userId=%@&target=%@&Status=1",kHostMUrl,userId,urlstr];
    CFRelease(urlstr);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mUrl]]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
}
@end
