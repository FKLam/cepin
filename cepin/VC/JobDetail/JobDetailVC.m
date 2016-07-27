//
//  JobDetailVC.m
//  cepin
//
//  Created by ricky.tang on 14-10-31.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobDetailVC.h"
#import "JobDetailVM.h"
#import "JobDetailLabelCell.h"

#import "JobDetailModelDTO.h"
#import "UIImageView+WebCache.h"
#import "BaseViewController+otherUI.h"
#import "UIViewController+NavicationUI.h"

#import "CompanyDetailNewVC.h"
#import "UMSocial.h"
#import "TBUmengShareConfig.h"
#import "RTNetworking.h"
#import "JobDetailNewTitleCell.h"
#import "LoginVC.h"
#import "UmengView.h"
#import "JobDetailDiscripCell.h"
#import "ResumeSendView.h"
#import "AllResumeVC.h"
#import "NewJobDetialVC.h"
#import "JobSendResumeSucessVC.h"
#import "AllResumeVC.h"
#import "TBTextUnit.h"
#import "ResumeNameVC.h"
#import "LoginAlterView.h"
#import "TBAppDelegate.h"
#import "CPJobInformationFrame.h"
#import "AlertDialogView.h"

@interface JobDetailVC ()<UIWebViewDelegate,ResumeSendViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>
@property(nonatomic, assign) CGFloat height;
@property(nonatomic,strong)UIWebView *heightWebView;
@property(nonatomic,strong)JobDetailVM *viewModel;
@property(nonatomic,assign)CGFloat tagHeight;
@property(nonatomic,assign)FUIButton *sendResumeButton;
@property(nonatomic,retain)ResumeSendView *sendResumeView;
@property(nonatomic,strong)NSString *positionId;
@property(nonatomic,strong)LoginAlterView *loginView;
@property(nonatomic,strong)AlertDialogView *alertView;
@property(nonatomic,strong)AlertDialogView *noResumeView;

@property (nonatomic, strong) CPJobInformationFrame *jobInformationFrame;
@end

@implementation JobDetailVC

-(instancetype)initWithJobId:(NSString *)jobId resumeType:(NSNumber *)resumeType{
    if (self = [super init]) {
        
        self.viewModel = [[JobDetailVM alloc] initWithJobId:jobId ResumeType:resumeType];
        
        self.jobInformationFrame = [[CPJobInformationFrame alloc] init];
        
        self.positionId = jobId;
    }
    return self;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.viewModel getPositionDetail];
   
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.loginView.hidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MobClick event:@"position_detail_launch"];
    
    self.title = @"职位详情";
    self.view.backgroundColor = [UIColor whiteColor];

    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.jobInformationFrame.jobInformation = self.viewModel.data;
            self.viewModel.data.HtmlJobDescription = [self.viewModel.data.HtmlJobDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"</p><p>"];
            if(!self.heightWebView){
                self.heightWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
                self.heightWebView.delegate = self;
                self.heightWebView.backgroundColor = [UIColor redColor];
                self.heightWebView.hidden = YES;
                [self.view addSubview:self.heightWebView];

                NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                                      "<head> \n"
                                      "<style type=\"text/css\"> \n"
                                      "body {font-size: %@; font-family: \"%@\"; color: %@; line-height : %@} \n"
                                      "p {margin-top : %@; margin-bottom : %@} \n"
                                      "</style> \n"
                                      "</head> \n"
                                      "<body>%@</body> \n"
                                      "</html>", [[RTAPPUIHelper shareInstance] jobInformationPositionDetailContentFont], @"微软雅黑",@"#9d9d9d", [NSNumber numberWithFloat:1.2], [NSNumber numberWithFloat:5.0], [NSNumber numberWithFloat:5.0], self.viewModel.data.HtmlJobDescription];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [self.heightWebView loadHTMLString:jsString baseURL:nil];
                });
                
            }
            if (self.viewModel.data.IsDeliveried.intValue == 1)
            {
                self.sendResumeButton.buttonColor = [[RTAPPUIHelper shareInstance] shadeColor];
                [self.sendResumeButton setTitleColor:[[RTAPPUIHelper shareInstance] mainTitleColor] forState:UIControlStateNormal];
                [self.sendResumeButton setTitle:@"已投递" forState:UIControlStateNormal];
                self.sendResumeButton.userInteractionEnabled = NO;
            }

           
        }else if (code == HUDCodeNetWork){
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
   
    
    [RACObserve(self.viewModel, getResumeStatecode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            if (!self.sendResumeView)
            {
                self.sendResumeView = [[ResumeSendView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, kScreenHeight)];
                self.sendResumeView.delegate = self;
                TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.window addSubview:self.sendResumeView];

                [self.sendResumeView setCurrentDatas:self.viewModel.allResumes];
            }
        }
        if (code == HUDCodeNone)
        {
            if(self.viewModel.resumeType.intValue==2){
                if (self.noResumeView) {
                    self.noResumeView.hidden =NO;
                    [self.noResumeView Show];
                }else{
                    self.noResumeView = [[AlertDialogView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, kScreenHeight) Title:@"提示" content:@"你还没有校园招聘简历，不符合校园招聘投递条件，是否创建校招简历？" selector:@selector(fillResume) target:self];
                    [self.noResumeView Show];
                    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.window addSubview:self.noResumeView];
                    //                [self.view addSubview:self.noResumeView];
                }
            }else{
                if (self.noResumeView) {
                    self.noResumeView.hidden =NO;
                    [self.noResumeView Show];
                }else{
                    self.noResumeView = [[AlertDialogView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, kScreenHeight) Title:@"提示" content:@"你还没有简历可投递，马上创建简历获得好工作？" selector:@selector(fillResume) target:self];
                    [self.noResumeView Show];
                    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.window addSubview:self.noResumeView];
                    //                [self.view addSubview:self.noResumeView];
                }
            }
           
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有简历" message:@"是否去创建简历" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
        }
    }];
    
    [RACObserve(self.viewModel, SendResumeStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.sendResumeButton.buttonColor = [[RTAPPUIHelper shareInstance]shadeColor];
            [self.sendResumeButton setTitleColor:[[RTAPPUIHelper shareInstance] mainTitleColor] forState:UIControlStateNormal];
            [self.sendResumeButton setTitle:@"已投递" forState:UIControlStateNormal];
            self.sendResumeButton.userInteractionEnabled = NO;
            self.changeState = [NSNumber numberWithInt:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendResume" object:nil userInfo:nil];
            
            JobSendResumeSucessVC *vc = [[JobSendResumeSucessVC alloc]initWithPositionId:self.positionId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(code == HUDCodeNone)
        {
            
            if ([self.viewModel.sendMessage rangeOfString:@"简历不完善"].location != NSNotFound) {
                if (self.alertView) {
                    self.alertView.hidden =NO;
                    [self.alertView Show];
                }else{
                    self.alertView = [[AlertDialogView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight) Title:@"简历不完善" content:@"您的简历不完善，是否马上去完善简历?" selector:@selector(fillResume) target:self];
                    [self.view addSubview:self.alertView];
                }
                
            }else{
                UIAlertView *sendAlert =[[UIAlertView alloc]initWithTitle:nil message:self.viewModel.sendMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [sendAlert show];
                
            }
            
           
        }
    }];
    
//    [self.viewModel getPositionDetail];
    
}


-(void)fillResume{
    self.noResumeView.hidden =YES;
    self.alertView.hidden = YES;
    AllResumeVC *vc = [[AllResumeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    if ( [self.noResumeView.content rangeOfString:@"校招"].length > 0 )
        [MobClick event:@"no_school_resume_confirm_click"];
    else
        [MobClick event:@"no_resume_confirm_click"];
}

- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getPositionDetail];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        AllResumeVC *vc = [[AllResumeVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)CreateTable
{
//    [self createNoHeadImageTable];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.viewWidth, self.view.viewHeight - (IS_IPHONE_5?40:50)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    
    self.sendResumeButton = (FUIButton*)[self bottomButtonWithTitle:@"立即投递"];
    [self.sendResumeButton.titleLabel setFont:[[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont]];
    if (self.viewModel.data.IsDeliveried.intValue == 1)
    {
        self.sendResumeButton.buttonColor = [[RTAPPUIHelper shareInstance] shadeColor];
        [self.sendResumeButton setTitleColor:[[RTAPPUIHelper shareInstance] mainTitleColor] forState:UIControlStateNormal];
        [self.sendResumeButton setTitle:@"已投递" forState:UIControlStateNormal];
        self.sendResumeButton.userInteractionEnabled = NO;
    }
    
    
    @weakify(self)
    [[self.sendResumeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        @strongify(self);
        
        [MobClick event:@"job_details_send_resume"];
        
        if (![MemoryCacheData shareInstance].isLogin)
        {
            self.loginView = [[LoginAlterView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, kScreenHeight)];
            TBAppDelegate *app = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
            [app.window addSubview:self.loginView];
            [self.loginView ShowLogin];
            return;
        }
        if (self.viewModel.allResumes.count > 0)
        {
            self.sendResumeView.hidden = NO;
            return;
        }
        [self.viewModel getResume];
    }];
}

-(void)didTouchLalbe
{
    CompanyDetailNewVC *vc = [[CompanyDetailNewVC alloc]initWithCompanyId:self.viewModel.data.CustomerId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
////    CGSize size = self.heightWebView.scrollView.contentSize;
////    self.height = size.height;
//    const CGFloat defaultWebViewHeight = 10.0;
//    //reset webview size
//    CGRect originalFrame = webView.frame;
//    webView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, 320, defaultWebViewHeight);
//    
//    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
//    if (actualSize.height <= defaultWebViewHeight) {
//        actualSize.height = defaultWebViewHeight;
//    }
//    self.height = actualSize.height+20;
    
    
    // 预先设定显示职位内容的高度
    self.height = kScreenHeight - self.jobInformationFrame.totalHeight - 80 - 40 - 64.0;
    
    [self CreateTable];
    
    // 设置字体大小
    // 设置字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='95%'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor='#9d9d9d'"];
    webView.opaque = NO;
    
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect webViewFrame = weakSelf.heightWebView.frame;
        NSString *h = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
        webViewFrame.size.height = [h floatValue];
        weakSelf.heightWebView.frame = webViewFrame;
        
#pragma mark - 和预先设定的高度比较
        if ( weakSelf.height < weakSelf.heightWebView.viewHeight )
            weakSelf.height = weakSelf.heightWebView.viewHeight + 49.0;
        
        [weakSelf.tableView reloadData];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            JobDetailNewTitleCell *item = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JobDetailNewTitleCell class])];
            if(item == nil)
            {
                item = [[JobDetailNewTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JobDetailNewTitleCell class])];
            }
            
            item.informationFrame = self.jobInformationFrame;
            
            [item getModelWith:self.viewModel.data];
            return item;
        }
            break;
        case 1:
        {
            JobDetailLabelCell *item = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JobDetailLabelCell class])];
            if (item == nil)
            {
                item = [[JobDetailLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JobDetailLabelCell class])];
            }
//            [item.tagListView removeAllTag];
            
            if ( self.viewModel.data && [item.tagListView.tags count] == 0 ) {
                NSUInteger count = self.viewModel.data.Tags.count;
                if (count > 5)
                {
                    count = 5;
                }
                
                
                for (NSInteger i = 0; i < count; i++)
                {
                    [item.tagListView addTagWithTitle:[self.viewModel.data.Tags objectAtIndex:i] labelColor:[UIColor whiteColor] backgroundColor:[[RTAPPUIHelper shareInstance] labelColorGreen]];
                }
            }
            return item;
        }
            break;
  
        case 2:
        {
            JobDetailDiscripCell *item = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JobDetailDiscripCell class])];
            if (item == nil)
            {
                item = [[JobDetailDiscripCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JobDetailDiscripCell class])];
            }
            item.titleLabel.text = @"职位描述";
            [item loadHtmlString:self.viewModel.data.HtmlJobDescription];
            return item;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
//            return 130;
//            return 150.0;
            return self.jobInformationFrame.totalHeight;
            break;
        case 1:
        {
            if (self.viewModel.data.Tags.count > 0) {
                NSString *str = [TBTextUnit configWithTag:self.viewModel.data.Tags];
                if (str.length>19) {
                    return 80;
                }
                else {
                    return 40;
                }
            }else{
                return 0;
            }
        }
            break;
        case 2:
        {
            return self.height;
        }
            break;
        default:
            break;
    }
    return 0;
}



-(void)clickManager
{
    AllResumeVC *vc = [AllResumeVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickLevelEnsureButton:(NSString *)str IsComplete:(BOOL)canSend
{
    self.viewModel.chooseResumeId = str;
    if (canSend) {
         [self.viewModel sendResume];
        
        [MobClick event:@"choose_resume_perfect"];
    }else{
        ResumeNameVC *vc = [[ResumeNameVC alloc]initWithResumeId:str JobId:self.viewModel.jobId];
        [self.navigationController pushViewController:vc animated:YES];
        
        [MobClick event:@"choose_resume_not_perfect"];
    }
    
}

@end
