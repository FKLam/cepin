//
//  DynamicSystemDetailVC.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemDetailVC.h"
#import "DynamicSystemDetailCell.h"

@interface DynamicSystemDetailVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *heightWebView;
@property(nonatomic,retain)DynamicSystemModelDTO *dataBean;
@property(nonatomic,retain)UILabel *lableTitle;
@property(nonatomic,retain)UILabel *lableTime;
@property(nonatomic,retain)UILabel *lableDetail;
@property(nonatomic,retain)UIView  *lineView;
@property(nonatomic)int height;
@end

@implementation DynamicSystemDetailVC

-(instancetype)initWithBean:(DynamicSystemModelDTO*)bean
{
    if (self = [super init])
    {
        self.dataBean = bean;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息详情";
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    
    self.lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-30, IS_IPHONE_5?12:14.4)];
    [scroll addSubview:self.lableTitle];
    self.lableTitle.text = self.dataBean.Title;
    self.lableTitle.numberOfLines = 0;
    self.lableTitle.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
     self.lableTitle.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    self.lableTitle.lineBreakMode = NSLineBreakByCharWrapping;
 
    self.lableTime = [[UILabel alloc]initWithFrame:CGRectMake(20, self.lableTitle.viewHeight + self.lableTitle.viewY + 10, kScreenWidth-20, 20)];
    [scroll addSubview:self.lableTime];
    self.lableTime.text = self.dataBean.CreateDate;
    self.lableTime.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
     self.lableTime.font = [[RTAPPUIHelper shareInstance]titleFont];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(20, self.lableTime.viewHeight + self.lableTime.viewY + 10, kScreenWidth-30, 1)];
    [scroll addSubview:self.lineView];
    self.lineView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
    
    self.heightWebView = [[UIWebView alloc]initWithFrame:CGRectMake(10, self.lineView.viewY + self.lineView.viewHeight + 5, self.view.viewWidth - 20, kScreenHeight - 150)];
    self.heightWebView.delegate = self;
    self.heightWebView.scrollView.bounces = NO;
    self.heightWebView.backgroundColor = [UIColor whiteColor];
    [self.heightWebView setOpaque:NO];
    [scroll addSubview:self.heightWebView];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    [mStr appendString:[NSString stringWithFormat:@"<html><body>"]];
    [mStr appendString:self.dataBean.HtmlContent];
    [mStr appendString:[NSString stringWithFormat:@"</body></html>"]];
    [self.heightWebView loadHTMLString:mStr baseURL:nil];
}

#pragma mark - UITableView Datasource

#pragma mark - UIWebViewDelegate
//点击链接
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL = [request URL];
    
    if ([[requestURL scheme] isEqualToString:@"http"] &&(navigationType == UIWebViewNavigationTypeLinkClicked)) {
        
       [[UIApplication sharedApplication]openURL:requestURL];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize size = self.heightWebView.scrollView.contentSize;
    self.height = size.height;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
