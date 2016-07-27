//
//  DynamicWebVC.m
//  cepin
//
//  Created by zhu on 15/2/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "DynamicWebVC.h"
#import "UmengView.h"
#import "TBUmengShareConfig.h"
#import "UIViewController+NavicationUI.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "TBAppDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ForgetPasswordVC.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "CompanyDetailVC.h"
#import "NewJobDetialVC.h"
#import "ExamReportVC.h"

@interface DynamicWebVC ()<UIWebViewDelegate,UmengViewDelegate,UMSocialUIDelegate,NJKWebViewProgressDelegate>

@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) NSString *urlString;
@property(nonatomic, retain) UILabel *loadLalbe;
@property(nonatomic, retain) UmengView *umengView;
@property(nonatomic, assign) Boolean isAppendUrl;
@property(nonatomic, strong) JSContext *jsContext;
@property(nonatomic, strong) NJKWebViewProgressView *progressView;
@property(nonatomic, strong) NJKWebViewProgress *progressProxy;

@end

@implementation HYBJsObjCModel

- (void)searchOnAndroid:(NSString *)searchKey {
    NSLog(@"Js调用了OC11的方法，参数为：%@", searchKey);
    dispatch_async(dispatch_get_main_queue(), ^{
           TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        UIWebView *web = [[UIWebView alloc] init];
        NSString *sc = [NSString stringWithFormat:@"decodeURIComponent('%@')",searchKey];
        NSString *st = [web stringByEvaluatingJavaScriptFromString:sc];
        [delegate searchOnAndroid:st];
    });
}

- (void)postOnAndroid:(NSString *)params{
    NSLog(@"Js调用了OC11的方法，参数为：%@",params);
    dispatch_async(dispatch_get_main_queue(), ^{
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate postOnAndroid:params];
    });
  }

- (void)companyOnAndroid:(NSString *)companyId{
     NSLog(@"Js调用了OC11的方法，参数为：%@",companyId);
    dispatch_async(dispatch_get_main_queue(), ^{
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate companyOnAndroid:companyId];
    });
    
}

-(void)toInviteCepinList{
    dispatch_async(dispatch_get_main_queue(), ^{
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate toInviteCepinListWithMsg:NO];
    });
}

@end

@interface DynamicWebVC ()
@property (nonatomic, copy) NSString *originURL;
@property (nonatomic, copy) NSString *currentURL;
@property (nonatomic, assign) BOOL isBigADCome;
@end
@implementation DynamicWebVC
-(void)clickedBackBtn:(id)sender
{
    if (self.webView.canGoBack)
    {
        if ( ![self.originURL isEqualToString:self.currentURL] )
            [self.webView goBack];
        else
            [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(instancetype)initWithTitleAndlUrl:(NSString*)title url:(NSString*)urlString
{
    if (self = [super init])
    {
        self.isAppendUrl = true;
        self.title = title;
        self.urlString = urlString;
    }
    return self;
}
-(instancetype)initWithFullUrl:(NSString*)urlString title:(NSString*)title
{
    if (self = [super init])
    {
        self.title = title;
        self.isAppendUrl = false;
        self.urlString = urlString;
        self.navigationController.navigationBarHidden = NO;
    }
    return self;
}
- (instancetype)initWithFullUrl:(NSString *)url title:(NSString *)title isBigADCome:(BOOL)isBigADCome
{
    self = [self initWithFullUrl:url title:title];
    if ( self )
    {
        self.isBigADCome = isBigADCome;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar addSubview:_progressView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( self.isBigADCome )
    {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[RTAPPUIHelper shareInstance] labelColorGreen] cornerRadius:0] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.umengView = [UmengView new];
    self.umengView .delegate = self;
    if(!self.isAppendUrl){
         self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(myclickedBackBtn:)];
    }
    @weakify(self);
    [[self addNavicationObjectWithType:NavcationBarObjectTypeShare] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender){
        @strongify(self)
        
        self.strTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.title"];
        self.contentText = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.desc"];
        self.urlLogo = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.img"];
        self.urlPath = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.url"];
        
        if ( !self.strTitle || 0 == self.strTitle.length )
        {
            self.strTitle = self.title;
        }
        
        if ( !self.contentText || 0 == self.contentText.length )
        {
            self.contentText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('description')[0].content"];
            
            if ( !self.contentText || 0 == self.contentText.length )
            {
                self.contentText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('keywords')[0].content"];
            }
        }
        
        if ( !self.urlPath || 0 == self.urlPath.length )
        {
            self.urlPath = self.urlString;
        }
        
        [self.umengView show];
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    if ( self.isBigADCome )
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
    else
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
    }
    [self.webView setScalesPageToFit:YES];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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
    self.loadLalbe.text = @"加载中...";
    self.webView.hidden = YES;
    
    NSString *urlstr = self.urlString;
    if ([urlstr rangeOfString:@"?"].location !=NSNotFound ) {
        urlstr = [urlstr stringByAppendingString:@"&isapp=1"];
    }else{
        urlstr = [urlstr stringByAppendingString:@"?isapp=1"];
    }
    
    urlstr = [self encodeToPercentEscapeString:urlstr];
    urlstr = [self decodeFromPercentEscapeString:urlstr];
    NSString *mUrl = urlstr;
    
    NSURL *cookieHost = [NSURL URLWithString:mUrl];
    
    // 设定 cookie
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [cookieHost host], NSHTTPCookieDomain,
                             [cookieHost path], NSHTTPCookiePath,
                             @"isApp",  NSHTTPCookieName,
                             @"true", NSHTTPCookieValue,
                             nil]];
    // 设定 cookie 到 storage 中
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    // 建立 NSURLRequest 连到 cookie.php，连线的时候会自动加入上面设定的 Cookie
    NSURL *myurl = [NSURL URLWithString:mUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:myurl];
    [self.webView loadRequest:requestObj];
}
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    // ()
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}
- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSString *)webScriptNameForSelector:(SEL)selector
{
    return nil;
}
+(void)postOnAndroid:(NSString*)postId positionType:(NSString*)positionType companyId:(NSString*)companyId{

}
-(void)myclickedBackBtn:(id)sender
{
    TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate jumpAdvertisement];
   
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( ![self.urlString isEqualToString:request.URL.absoluteString] && request.URL.absoluteString )
        self.urlString = request.URL.absoluteString;
    if ( self.currentURL )
    {
        self.originURL = self.currentURL;
    }
    NSString *backupURLString = [self.urlString copy];
    NSRange range = [backupURLString rangeOfString:@"#\\W*\\w*\\W*\\d+$" options:NSRegularExpressionSearch];
    if ( range.location != NSNotFound )
    {
        self.currentURL = [self.urlString substringWithRange:NSMakeRange(0, range.location)];
    }
    NSURL *cookieHost = [NSURL URLWithString:request.URL.absoluteString];
    
    // 设定 cookie
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                            [NSDictionary dictionaryWithObjectsAndKeys:
               
                             [cookieHost host], NSHTTPCookieDomain,
                             [cookieHost path], NSHTTPCookiePath,
                             @"isApp",  NSHTTPCookieName,
                             @"true", NSHTTPCookieValue,
                             nil]];
    // 设定 cookie 到 storage 中
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.strTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.title"];
    if(!self.strTitle || [@"" isEqualToString:self.strTitle]){
    }
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        // 通过模型调用方法，这种方式更好些。
        HYBJsObjCModel *model  = [[HYBJsObjCModel alloc] init];
        self.jsContext[@"jsObj"] = model;
        model.jsContext = self.jsContext;
        model.webView = self.webView;
        
        self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
        };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.webView.hidden = NO;
        self.loadLalbe.hidden = YES;
    });
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadLalbe.hidden = YES;
}
-(void)didChooseUmengView:(int)tag
{
    [self.umengView disMiss];
    NSMutableArray  *title = [[NSMutableArray alloc]init];
    if([WXApi isWXAppInstalled])
    {
        [title addObject:@"微信好友"];
        [title addObject:@"朋友圈"];
    }
    [title addObject:@"新浪微博"];
    if([QQApiInterface isQQInstalled])
    {
        [title addObject:@"QQ"];
        [title addObject:@"QQ空间"];
    }
    NSString *platformName = nil;
    NSString *selectedTitle = [title objectAtIndex:tag];
    if ( [selectedTitle isEqualToString:@"新浪微博"] )
    {
        platformName = @"sina";
    }
    else if ( [selectedTitle isEqualToString:@"微信好友"] )
    {
        platformName = @"wxsession";
    }
    else if ( [selectedTitle isEqualToString:@"朋友圈"] )
    {
        platformName = @"wxfriend";
    }
    else if ( [selectedTitle isEqualToString:@"QQ"] )
    {
        platformName = @"qq";
    }
    else if ( [selectedTitle isEqualToString:@"QQ空间"] )
    {
        platformName = @"qzone";
    }
    if ([platformName isEqualToString:@"sina"]) {
        
        NSString *content = [NSString stringWithFormat:@"%@\n %@ ",self.strTitle,self.urlPath];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlLogo]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:image socialUIDelegate:self];        //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            });
        });
    }
    else
    {
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:self.strTitle content:self.contentText url:self.urlPath imageUrl:self.urlLogo completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess)
            {
            }
            else
            {
            }
            
        }];
    }
}
@end
