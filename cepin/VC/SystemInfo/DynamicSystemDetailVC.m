//
//  DynamicSystemDetailVC.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemDetailVC.h"
#import "DynamicSystemDetailCell.h"
#import "RTNetworking+DynamicState.h"
#import "NSDictionary+NetworkBean.h"
#import "RTHUDModel.h"
#import "DynamicExamDetailVC.h"
#import "CPCommon.h"
@interface DynamicSystemDetailVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *heightWebView;
@property(nonatomic,retain)DynamicSystemModelDTO *dataBean;
@property(nonatomic,retain)UILabel *lableTitle;
@property(nonatomic,retain)UILabel *lableTime;
@property(nonatomic,retain)UILabel *lableDetail;
@property(nonatomic,retain)UIView  *lineView;
@property(nonatomic)int height;
@property(nonatomic,strong)NSString *mId;
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,strong)TBLoading *load;
@property(nonatomic,strong)id stateCode;
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

-(instancetype)initWithBeanId:(NSString*)beanId
{
    if (self = [super init])
    {
        self.mId = beanId;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.mId) {
        
        NSString *strUser = [[MemoryCacheData shareInstance]userId];
        NSString *strTocken = [[MemoryCacheData shareInstance]userTokenId];
        if (!strUser)
        {
            strUser = @"";
            strTocken = @"";
        }
        
        if (self.isLoad) {
            self.load = [TBLoading new];
            [self.load start];
            self.isLoad = NO;
        }
        
        RACSignal *signal = [[RTNetworking shareInstance]getSystemMessageSingle:strUser MsgId:self.mId tokenId:strTocken];
        @weakify(self);
        [signal subscribeNext:^(RACTuple *tuple){
            if (self.load)
            {
                [self.load stop];
            }
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)tuple.second;
            if ([dic resultSucess])
            {
                self.dataBean = [DynamicSystemModelDTO beanFromDictionary:[dic resultObject]];
                self.stateCode = [RTHUDModel hudWithCode:HUDCodeSucess];
//                NSArray *array = [dic resultObject];
            
            }
           
        } error:^(NSError *error){
            NSLog(@"error..=");
        }];

        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息详情";
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0))];
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
 
    self.heightWebView = [[UIWebView alloc]initWithFrame:CGRectMake(10, 0, self.view.viewWidth - 20, kScreenHeight - ((IsIOS7)?44+20:44) - 10)];
    self.heightWebView.delegate = self;
    self.heightWebView.scrollView.bounces = NO;
    self.heightWebView.backgroundColor = [UIColor whiteColor];
    [self.heightWebView setOpaque:NO];
    [scroll addSubview:self.heightWebView];
    
    [RACObserve(self, stateCode)subscribeNext:^(id stateCode) {
        if ([self requestStateWithStateCode:stateCode]==HUDCodeSucess) {
            NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                                  "<head> \n"
                                  "<style type=\"text/css\"> \n"
                                  "body {font-size: %@; font-family: \"%@\"; color: %@;}\n"
                                  "</style> \n"
                                  "</head> \n"
                                  "<body>%@</body> \n"
                                  "</html>", [[RTAPPUIHelper shareInstance]subTitleFont], @"Helvetica Neue",@"#9d9d9d", self.dataBean.HtmlContent];
            
            [self.heightWebView loadHTMLString:jsString baseURL:nil];
        }
    }];
    
    if (self.dataBean) {
        NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-size: %@; font-family: \"%@\"; color: %@;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", [[RTAPPUIHelper shareInstance]subTitleFont], @"Helvetica Neue",@"#9d9d9d", self.dataBean.HtmlContent];
        
        [self.heightWebView loadHTMLString:jsString baseURL:nil];
    }
    
}

#pragma mark - UITableView Datasource

#pragma mark - UIWebViewDelegate
//点击链接
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL = [request URL];
    
    if ([[requestURL scheme] isEqualToString:@"http"] &&(navigationType == UIWebViewNavigationTypeLinkClicked)) {
        
        //跳转到m端中转页面
        DynamicExamDetailVC  *vc = [[DynamicExamDetailVC alloc] initWithUrl:requestURL.absoluteString examDetail:examDetailFirst];
        vc.title = self.dataBean.Title;
        vc.strTitle = self.dataBean.Title;
        vc.isJiSuCepin = YES;
        vc.isMsgCepin = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
//        [[UIApplication sharedApplication]openURL:requestURL];
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
