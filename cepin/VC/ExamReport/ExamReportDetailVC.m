//
//  ExamReportDetailVC.m
//  cepin
//
//  Created by dujincai on 15/7/1.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExamReportDetailVC.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "TBAppDelegate.h"


@interface ExamReportDetailVC ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,retain)NSString  *urlString;
@property(nonatomic,strong)JSContext *jsContext;
@property(nonatomic,strong)NJKWebViewProgressView *progressView;
@property(nonatomic,strong)NJKWebViewProgress *progressProxy;
@end


@implementation MyBJsObjCModel

- (void)searchOnAndroid:(NSString *)searchKey {
    dispatch_async(dispatch_get_main_queue(), ^{
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        UIWebView *web = [[UIWebView alloc] init];
        NSString *sc = [NSString stringWithFormat:@"decodeURIComponent('%@')",searchKey];
        NSString *st = [web stringByEvaluatingJavaScriptFromString:sc];
        [delegate searchOnAndroid:st];
    });
}

- (void)postOnAndroid:(NSString *)params{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MobClick endEvent:@"web_to_app_job_recommend"];
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate postOnAndroid:params];
    });
    
}

- (void)companyOnAndroid:(NSString *)companyId{
    dispatch_async(dispatch_get_main_queue(), ^{
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate companyOnAndroid:companyId];
    });
    
}


-(void)checkReportOnAndroid{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MobClick endEvent:@"check_report"];
    });
}


-(void)editExamOnAndroid{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MobClick endEvent:@"edit_speed_exam_exercise"];
    });
}


-(void)editUserInfoOnAndroid{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MobClick endEvent:@"edit_speed_exam_userinfo"];
    });
}


-(void)toInviteCepinList{
    dispatch_async(dispatch_get_main_queue(), ^{
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate toInviteCepinListWithMsg:NO];
    });
}

@end

@implementation ExamReportDetailVC
-(instancetype)initWithUrl:(NSString*)url
{
    if (self = [super init])
    {
        self.urlString = url;
        return self;
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:self.progressView];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.progressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
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
    
    NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;

    CFStringRef urlstr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.urlString, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    
    
    NSString *mUrl = [NSString stringWithFormat:@"%@/#/atm?userId=%@&target=%@",kHostMUrl,userId,urlstr];
    CFRelease(urlstr);
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mUrl]]];
    
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

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    // 通过模型调用方法，这种方式更好些。
//    MyBJsObjCModel *model  = [[MyBJsObjCModel alloc] init];
//    self.jsContext[@"jsObj"] = model;
//    model.jsContext = self.jsContext;
//    model.webView = self.webView;
//    
//    
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        NSLog(@"异常信息：%@", exceptionValue);
//    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.absoluteString rangeOfString:@"report"].location != NSNotFound) {
        [self performSelector:@selector(loadJS:) withObject:webView afterDelay:3.f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MobClick endEvent:@"check_report"];
            
        });
    }else if([request.URL.absoluteString rangeOfString:@"Exam/MobileExam"].location != NSNotFound){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MobClick endEvent:@"edit_speed_exam_exercise"];
            NSLog(@"check edit_speed_exam_exercise");
        });
    }else if([request.URL.absoluteString rangeOfString:@"evaluation/confirm"].location != NSNotFound){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MobClick endEvent:@"edit_speed_exam_userinfo"];
            NSLog(@"check edit_speed_exam_userinfo");
        });
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

-(void)loadJS:(UIWebView*)webview{
    self.jsContext = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 通过模型调用方法，这种方式更好些。
    MyBJsObjCModel *model  = [[MyBJsObjCModel alloc] init];
    self.jsContext[@"jsObj"] = model;
    model.jsContext = self.jsContext;
    model.webView = webview;
     NSLog(@"加载js完毕");
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
}
@end
