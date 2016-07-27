//
//  CompanyDetailVC.m
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CompanyDetailVC.h"
#import "CompanyDetailVM.h"
#import "LoginVC.h"
#import "UmengView.h"
#import "TBUmengShareConfig.h"

#import "CompanyDetaileOtherJobCell.h"
#import "NewJobDetialVC.h"
#import "CompanyMapVC.h"
#import "CompanyIntroduceCell.h"

#import "CompanyDetailHeadCell.h"
#import "UIViewController+NavicationUI.h"
#import "CompanyFairHeadCell.h"
#import "TheCompanyJobVC.h"
#import "CompanyAddressMapCell.h"
#import "UMSocial.h"

#import "CPRecommendTitleCell.h"
#import "CPRecommendModelFrame.h"
#import "JobSearchModel.h"
#import "CompanyDetailModelDTO.h"
#import "LoginAlterView.h"
#import "TBAppDelegate.h"

@interface CompanyDetailVC ()<CompanyDetaileOtherJobViewDelegate,UmengViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)CompanyDetailVM *viewModel;
@property(nonatomic,retain)UIButton  *collectionButton;
@property(nonatomic,retain)UIButton  *shareButton;
@property(nonatomic,retain)UmengView *umengView;
@property(nonatomic,strong)LoginAlterView *loginView;
@end

@implementation CompanyDetailVC
- (instancetype)initWithCompanyId:(NSString *)CompanyId
{
    self = [super init];
    if (self) {
        self.viewModel = [[CompanyDetailVM alloc] initWithCompanyId:CompanyId];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel allPositionId];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司详情";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.hidden = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    self.umengView = [UmengView new];
    self.umengView.delegate = self;
    
    
    [self.viewModel getCompanyDetail];
    
    int hight = IS_IPHONE_5?21:25;
    self.collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, hight, hight)];
    [self.collectionButton setImage:[UIImage imageNamed:@"tb_position_uncollect_new"] forState:UIControlStateNormal];

    [[self.collectionButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id stateCode) {
        if (![MemoryCacheData shareInstance].isLogin)
        {
            
            self.loginView = [[LoginAlterView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight)];
            TBAppDelegate *app = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:self.loginView];
            self.loginView.hidden = NO;
            [self.loginView ShowLogin];
            
            return;
        }
        if (self.viewModel.data.IsCollection.intValue == 1) {
            [self.viewModel deleteCompany];
        }
        else
        {
            [self.viewModel saveCompany];
        }
    }];
    
    self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, hight, hight)];
    [self.shareButton setImage:[UIImage imageNamed:@"ic_share_white"] forState:UIControlStateNormal];
    [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self.umengView show];
    }];
    
    [self addNavicationCollectionObjectWithImage:self.shareButton share:self.collectionButton];
    
    
    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self resetCollection];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else if (code == HUDCodeNetWork){
            self.tableView.hidden = YES;
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
        }
    }];
    
    [RACObserve(self.viewModel, deleteStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.viewModel.data.IsCollection = [NSNumber numberWithInt:0];
            [self resetCollection];
        }
      
    }];
    [RACObserve(self.viewModel, saveStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.viewModel.data.IsCollection = [NSNumber numberWithInt:1];
            [self resetCollection];
        }
    }];
    
    [self.viewModel getCompanyDetail];
}

- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
 
    self.viewModel.isLoad = YES;
    [self.viewModel getCompanyDetail];

}

-(void)resetCollection
{
    if (self.viewModel.data.IsCollection.intValue == 1)
    {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"tb_position_collected_new"] forState:UIControlStateNormal];
    }
    else
    {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"tb_position_uncollect_new"] forState:UIControlStateNormal];
    }
}
-(void)didChooseUmengView:(int)tag
{
    [self.umengView disMiss];
    
    NSString *platformName = nil;
    
    switch (tag)
    {
        case 0:platformName = @"wxsession";
            break;
        case 1:platformName = @"wxfriend";
            break;
        case 2: platformName = @"qq";
            break;
        case 3: platformName = @"qzone";
            break;
        case 4:platformName = @"sina";
            break;
        case 5:platformName = @"sms";
            break;
        case 6:platformName = @"email";
            break;
        default:
            break;
    }
    
    
    if ([platformName isEqualToString:@"sina"]) {
        
        NSString *strTitle = [NSString stringWithFormat:@"%@ %@",self.viewModel.data.CompanyName,@"招聘"];
        
        NSString *url = [NSString stringWithFormat:@"%@/Customer/CompanyInfo?customerId=%@",kHostShareUrl,self.viewModel.data.CustomerId];
        NSString *content = [NSString stringWithFormat:@"%@,%@",strTitle,url];
        [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:[UIImage imageNamed:@"cepin_icon_share"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else{
    
    NSString *strTitle = [NSString stringWithFormat:@"%@ %@",self.viewModel.data.CompanyName,@"招聘"];
    
    NSString *url = [NSString stringWithFormat:@"%@/Customer/CompanyInfo?customerId=%@",kHostShareUrl,self.viewModel.data.CustomerId];
    
    [TBUmengShareConfig didSelectSocialPlatform:platformName vCtrl:self title:strTitle content:self.viewModel.data.Introduction url:url imageUrl:self.viewModel.data.Logo completion:^(UMSocialResponseEntity *response) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
//            return IS_IPHONE_5?80:100;
            return 100.0;
            break;
        case 1:
        {
            return [CompanyAddressMapCell computerCellHeihgt:self.viewModel.data.Address];
        }
            break;
        case 2:
        {
            return [CompanyIntroduceCell computerCellHeihgt:self.viewModel.data?self.viewModel.data.Description:@"" open:self.viewModel.isOpen]+20;
        }
            break;
        case 3:
            return IS_IPHONE_5?40:48;
            break;
        case 4:
        {
//            return self.viewModel.data.AppPositionInfoList.count * (IS_IPHONE_5?110:130)+70;
            return self.viewModel.data.AppPositionInfoList.count * 130;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CompanyDetailHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyDetailHeadCell class])];
        if(cell == nil)
        {
            cell = [[CompanyDetailHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CompanyDetailHeadCell class])];
        }
        
        [cell configureWithBean:self.viewModel.data];
        return cell;
    }
    if (indexPath.row == 1) {
        CompanyAddressMapCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyAddressMapCell class])];
        if(cell == nil)
        {
            cell = [[CompanyAddressMapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CompanyAddressMapCell class])];
        }
        cell.addressLabel.text = self.viewModel.data.Address;
        [cell.addressButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            CompanyMapVC *vc = [[CompanyMapVC alloc]initWithAddress:self.viewModel.data.Address];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        return cell;
    }
    if (indexPath.row == 2) {
        CompanyIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyIntroduceCell class])];
        if (cell == nil)
        {
            cell = [[CompanyIntroduceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CompanyIntroduceCell class])];
        }
        cell.introduction.text = @"公司简介";
        [cell configureWithBean:self.viewModel.data];
        return cell;
    }
    if (indexPath.row == 3) {
        CompanyFairHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyFairHeadCell class])];
        if (cell == nil) {
            cell = [[CompanyFairHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CompanyFairHeadCell class])];
        }
        return cell;
    }
    if (indexPath.row == 4) {
        CompanyDetaileOtherJobCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyDetaileOtherJobCell class])];
        if (cell == nil) {
            cell = [[CompanyDetaileOtherJobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CompanyDetaileOtherJobCell class])];
        }
        [cell createOtherJobCellWith:self.viewModel.data positionIds:self.viewModel.positionIdArray];
        cell.companyOtherJobView.delegate = self;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        CompanyIntroduceCell *cell = (CompanyIntroduceCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (!cell.buttonMore.hidden)
        {
            if (self.viewModel.isOpen)
            {
                [cell.buttonMore setTitle:@"点击查看更多" forState:UIControlStateNormal];
                self.viewModel.isOpen = NO;
                cell.isOpen = self.viewModel.isOpen;
            }
            else
            {
                [cell.buttonMore setTitle:@"点击收起" forState:UIControlStateNormal];
                self.viewModel.isOpen = YES;
                cell.isOpen = self.viewModel.isOpen;
            }
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self.tableView reloadData];
        }
    }
    if (indexPath.row == 3) {
        TheCompanyJobVC *vc = [[TheCompanyJobVC alloc]initWithCompanyId:self.viewModel.data.CustomerId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didTouchOtherJob:(CPRecommendModelFrame *)recommendModelFrame
{
//    JobSearchModel *model = recommendModelFrame.recommendModel;
//    NewJobDetialVC *vc = [[NewJobDetialVC alloc] initWithJobId:model.PositionId companyId:self.viewModel.data.CustomerId pstType:model.PositionType];
    
    JobSearchModel *model;
    if ( [recommendModelFrame.recommendModel isKindOfClass:[JobSearchModel class]] )
        model = (JobSearchModel *)recommendModelFrame.recommendModel;
    else
        return;
    
    NewJobDetialVC *vc = [[NewJobDetialVC alloc]initWithJobId:model.PositionId companyId:self.viewModel.data.CustomerId pstType:model.PositionType];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
