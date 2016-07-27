//
//  TBViewController.m
//  cepin
//
//  Created by dujincai on 15/4/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "TBViewController.h"

@interface TBViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *heightWebView;
@property(nonatomic,retain)DynamicSystemModelDTO *dataBean;
@property(nonatomic)int height;

@end

@implementation TBViewController
-(instancetype)initWithBean:(DynamicSystemModelDTO*)bean
{
    if (self = [super init])
    {
        self.dataBean = bean;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    [self createNoHeadImageTable];
    self.heightWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 00, 320, 1000)];
    self.heightWebView.delegate = self;
//    self.heightWebView.hidden = YES;
    self.heightWebView.scrollView.bounces = NO;
//    self.heightWebView.scrollView.bounds = CGRectMake(0, 0, 320, 1000);
    self.heightWebView.userInteractionEnabled = YES;
    self.heightWebView.scalesPageToFit = YES;
    self.heightWebView.scrollView.alwaysBounceHorizontal = YES;
    [self.tableView addSubview:self.heightWebView];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    [mStr appendString:[NSString stringWithFormat:@"<html><body>"]];
    [mStr appendString:self.dataBean.HtmlContent];
    [mStr appendString:[NSString stringWithFormat:@"</body></html>"]];
    [self.heightWebView loadHTMLString:mStr baseURL:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize size = self.heightWebView.scrollView.contentSize;
    self.height = size.height;
    self.heightWebView.frame = CGRectMake(0, 0, 320, self.height);

}


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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
