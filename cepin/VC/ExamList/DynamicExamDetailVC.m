//
//  DynamicExamDetailVC.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicExamDetailVC.h"
#import "UmengView.h"
#import "TBUmengShareConfig.h"
#import "UIViewController+NavicationUI.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "TBAppDelegate.h"
#import "MobClick.h"
@interface DynamicExamDetailVC ()<UIWebViewDelegate,UmengViewDelegate,UMSocialUIDelegate,NJKWebViewProgressDelegate>
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,retain)NSString  *urlString;
@property(nonatomic,retain)UmengView *umengView;
@property(nonatomic,retain)TBLoading *load;
@property(nonatomic,strong)JSContext *jsContext;
@property(nonatomic,strong)NJKWebViewProgressView *progressView;
@property(nonatomic,strong)NJKWebViewProgress *progressProxy;
@property(nonatomic,assign)Boolean noTarget;//是否需要拼接地址
@property(nonatomic,assign)BOOL end;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *Firsturl;
@property(nonatomic,strong)NSURL *myurl;

@end
@implementation MyHYBJsObjCModel
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
    NSLog(@"sdsdsds = %@",companyId);
    dispatch_async(dispatch_get_main_queue(), ^{
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate companyOnAndroid:companyId];
    });
}
-(void)toInviteCepinList{
    dispatch_async(dispatch_get_main_queue(), ^{
        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate toInviteCepinListWithMsg:self.isMsgCepin];
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
@end
@implementation DynamicExamDetailVC
-(instancetype)initWithUrl:(NSString*)url examDetail:(examDetail)examDetail
{
    if (self = [super init])
    {
        self.noTarget = NO;
        self.urlString = url;
        self.examDetail = examDetail;
        return self;
    }
    return nil;
}
//直接打开不需要拼接链接
-(instancetype)initWithUrl:(NSString *)url examDetail:(examDetail)examDetail noTarget:(Boolean)noTarget{
    if (self = [super init])
    {
        self.urlString = url;
        self.examDetail = examDetail;
        self.noTarget = YES;
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

-(void)clickedBack:(id)sender{
    if (self.url && ([self.url rangeOfString:@"examcenter/finish"].location != NSNotFound||[self.url rangeOfString:@"examcenter/end"].location != NSNotFound || [self.url rangeOfString:@"Exam/MobileExam/Index"].location != NSNotFound)) {
        [self.webView loadHTMLString:[NSString string] baseURL:nil];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.myurl];
        [self.webView loadRequest:requestObj];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    // 寻找URL为HOST的相关cookie，不用担心，步骤2已经自动为cookie设置好了相关的URL信息
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:HOST]]; // 这里的HOST是你web服务器的域名地址
    // 比如你之前登录的网站地址是abc.com（当然前面要加http://，如果你服务器需要端口号也可以加上端口号），那么这里的HOST就是http://abc.com
    
    // 设置header，通过遍历cookies来一个一个的设置header
    for (NSHTTPCookie *cookie in cookies){
        
        // cookiesWithResponseHeaderFields方法，需要为URL设置一个cookie为NSDictionary类型的header，注意NSDictionary里面的forKey需要是@"Set-Cookie"
        NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:
                                    [NSDictionary dictionaryWithObject:
                                     [[NSString alloc] initWithFormat:@"%@=%@",[cookie name],[cookie value]]
                                                                forKey:@"Set-Cookie"]
                                                                          forURL:[NSURL URLWithString:HOST]];
        
        // 通过setCookies方法，完成设置，这样只要一访问URL为HOST的网页时，会自动附带上设置好的header
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie
                                                           forURL:[NSURL URLWithString:HOST]
                                                  mainDocumentURL:nil];
    }
     */
    //重写返回的方法
    self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(clickedBack:)];
    if (self.examDetail == examDetailOther) {
        @weakify(self);
        [[self addNavicationObjectWithType:NavcationBarObjectTypeShare] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender){
            @strongify(self)
            
            self.strTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.title"];
            self.contentText = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.desc"];
            self.urlLogo = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.img"];
            self.urlPath = [self.webView stringByEvaluatingJavaScriptFromString:@"window.dataForWeixin.url"];
            NSLog(@"测试分享title=%@",self.strTitle);
            NSLog(@"测试分享content=%@",self.contentText);
            NSLog(@"测试分享urlLogo=%@",self.urlLogo);
            NSLog(@"测试分享urlPath=%@",self.urlPath);
            [self.umengView show];
        }];
    }
    self.umengView = [UmengView new];
    self.umengView .delegate = self;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
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
    NSString *userId = [[MemoryCacheData shareInstance] userId];
//    NSString *urlstr = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *urlstr = self.urlString;
    if ([self.urlString rangeOfString:@"?"].location !=NSNotFound ) {
            self.urlString = [self.urlString stringByAppendingString:@"&isApp=1"];
    }else{
            self.urlString = [self.urlString stringByAppendingString:@"?isApp=1"];
    }
//    CFStringRef urlstr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.urlString, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
//    CFStringRef tempUrlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)kHostMUrl, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
//    NSString *mUrl = [NSString stringWithFormat:@"%@/atm?userId=%@&target=%@", kHostMUrl, userId, urlstr];
//=======
////    NSString *mUrl = [NSString stringWithFormat:@"%@/#/atm?userId=%@&target=%@", kHostMUrl, userId, urlstr];

//    CFStringRef tempUrlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)mUrl, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
//    stringByAddingPercentEncodingWithAllowedCharacters
//    mUrl = [mUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    CFRelease( tempUrlString );
//    NSString *mUrl = [NSString stringWithFormat:@"%@/#/atm?userId=%@&target=%@", kHostMUrl, userId, urlstr];
    CFStringRef urlstr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.urlString, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    NSString *mUrl = [NSString stringWithFormat:@"%@/atm?userId=%@&target=%@",kHostMUrl,userId,urlstr];
//    CFRelease(urlstr);
//    NSString *mUrl = [NSString stringWithFormat:@"%@/#/atm?userId=%@&target=%@",kHostMUrl,userId,urlstr];
    /*
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cook in [cookies cookies]) {
        RTLog(@"cookies 000 %@",cook);
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cook];
    }
     */
//    NSString *mUrl = [NSString stringWithFormat:@"%@/#/atm?userId=%@&target=%@",kHostMUrl, userId, urlstr];
//    CFStringRef tempUrlString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)mUrl, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
//    mUrl = (__bridge NSString *)tempUrlString;
//    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cook in [cookies cookies]) {
//        RTLog(@"cookies 000 %@",cook);
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cook];
//    }
//    NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:mUrl]];
//    for (NSHTTPCookie *cookie in cookiesArray)
//    {
//        NSArray *headArray = [NSHTTPCookie cookiesWithResponseHeaderFields:
//                                    [NSDictionary dictionaryWithObject:
//                                     [[NSString alloc] initWithFormat:@"%@=%@",[cookie name],[cookie value]]
//                                                                forKey:@"Set-Cookie"]
//                                                                forURL:[NSURL URLWithString:kHostMUrl]];
//     
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:headArray forURL:[NSURL URLWithString:kHostMUrl] mainDocumentURL:nil];
//    }
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
    //检测是否需要拼接用户信息
    if (self.noTarget)
    {
        self.myurl = [NSURL URLWithString:self.urlString];
    }
    else
    {
        self.myurl = [NSURL URLWithString:mUrl];
    }
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.myurl];
    [self.webView loadRequest:requestObj];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mUrl]]];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (!self.Firsturl )
    {
        self.Firsturl  = request.URL.absoluteString;
    }
    self.webView = webView;
    self.url  = request.URL.absoluteString;
    //做题时把分享按钮隐藏
    if (self.examDetail == examDetailOther && self.isJiSuCepin)
    {
        if([self.url rangeOfString:kHostMUrl].location == NSNotFound)
        {
            self.navigationItem.rightBarButtonItem.customView.hidden=YES;
        }
        else
        {
            self.navigationItem.rightBarButtonItem.customView.hidden=NO;
        }
    }
    if ([request.URL.absoluteString rangeOfString:@"report"].location != NSNotFound)
    {
        [self performSelector:@selector(loadJS:) withObject:webView afterDelay:3.f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MobClick event:@"web_to_app_job_recommend"];
            [MobClick event:@"check_report"];
        });
    }
    else if([request.URL.absoluteString rangeOfString:@"Exam/MobileExam/Guide"].location != NSNotFound)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MobClick event:@"edit_speed_exam_exercise"];
        });
    }
    else if([request.URL.absoluteString rangeOfString:@"evaluation/confirm"].location != NSNotFound)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MobClick event:@"edit_speed_exam_userinfo"];
        });
    }
    else if([self.url rangeOfString:@"/examcenter/finish"].location != NSNotFound)
    {
        //判断是不是邀请测评结果页面
        //加载js的方法
        [self performSelector:@selector(loadJS:) withObject:webView afterDelay:1.f];
    }
    else if(self.isMsgCepin && [self.url rangeOfString:@"/examcenter/end"].location != NSNotFound)
    {
        self.isMsgCepin = YES;
        //加载js的方法
        [self performSelector:@selector(loadJS:) withObject:webView afterDelay:1.f];
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
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    // 通过模型调用方法，这种方式更好些。
//    MyHYBJsObjCModel *model  = [[MyHYBJsObjCModel alloc] init];
//    self.jsContext[@"jsObj"] = model;
//    model.jsContext = self.jsContext;
//    model.webView = webView;
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        NSLog(@"异常信息：%@", exceptionValue);
//    };
//    if ([self.url rangeOfString:@"report"].location != NSNotFound)
//    {
//        [self performSelector:@selector(loadJS:) withObject:webView afterDelay:2.f];
//    }
}
-(void)loadJS:(UIWebView*)webview
{
    self.jsContext = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 通过模型调用方法，这种方式更好些。
    MyHYBJsObjCModel *model  = [[MyHYBJsObjCModel alloc] init];
    self.jsContext[@"jsObj"] = model;
    model.jsContext = self.jsContext;
    model.isMsgCepin = self.isMsgCepin;
    model.webView = webview;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //移除进度条，并弹出提示信息
    if (self.load)
    {
        [self.load stop];
    }
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
    NSString *titleStr = @"参与极速精准的职业测评，让好工作随手可得－测聘网";
    if ( !self.isJiSuCepin )
        titleStr = [NSString stringWithFormat:@"%@－测聘网", self.strTitle];
    NSString *descriptStr = @"5分钟测一测，了解自己的性格特点与优劣，为您找到最合适的岗位和企业！";
    if ( !self.isJiSuCepin )
        descriptStr = self.contentText;
    if ( [platformName isEqualToString:@"sina"] )
    {
        NSString *content = [NSString stringWithFormat:@"%@%@", titleStr, self.urlPath];
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
        [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:titleStr content:descriptStr url:self.urlPath imageUrl:self.urlLogo completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess)
            {
                [OMGToast showWithText:@"分享成功" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
            else
            {
                [OMGToast showWithText:@"分享失败" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }
        }];
    }
}
@end
