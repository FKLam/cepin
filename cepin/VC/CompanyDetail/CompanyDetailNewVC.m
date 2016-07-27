//
//  CompanyDetailNewVC.m
//  cepin
//
//  Created by zhu on 14/12/7.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CompanyDetailNewVC.h"
#import "CompanyDetailVM.h"
#import "CompanyIntroduceCell.h"
#import "UIViewController+NavicationUI.h"
#import "CompanyDetailHeadCell.h"
#import "TheCompanyJobVC.h"
#import "LoginVC.h"
#import "CompanyFairHeadCell.h"

#import "UmengView.h"
#import "TBUmengShareConfig.h"
#import "CompanyDetaileOtherJobCell.h"
#import "NewJobDetialVC.h"
#import "CompanyMapVC.h"
#import "CompanyAddressMapCell.h"

#import "CPRecommendModelFrame.h"
#import "CPRecommendCell.h"
#import "JobSearchModel.h"
#import "CPCompanyInformationFrame.h"
#import "CPCommon.h"


@interface CompanyDetailNewVC ()<CompanyDetaileOtherJobViewDelegate>

@property(nonatomic,strong)CompanyDetailVM *viewModel;

@property (nonatomic, strong) CPCompanyInformationFrame *companyInformationFrame;
@end

@implementation CompanyDetailNewVC

-(void)memoryRelease
{
    [self.viewModel momeryRelease];
    self.viewModel = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}

-(instancetype)initWithCompanyId:(NSString *)CompanyId
{
    if (self = [super init]) {
        self.viewModel = [[CompanyDetailVM alloc] initWithCompanyId:CompanyId];
        
        self.companyInformationFrame = [[CPCompanyInformationFrame alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel allPositionId];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [MobClick event:@"company_detail_launch"];
    
    self.title = @"企业详情";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 108) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.rowHeight = 77.0f;
    
//    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
//    self.tableView.backgroundColor = CPColor(0xf0, 0xef, 0xf5, 1.0);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    self.tableView.clipsToBounds = YES;
    self.tableView.dataSource = self;
    self.tableView.tag = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0);
    
    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            
            self.companyInformationFrame.companyDetail = self.viewModel.data;
            
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else if (code == HUDCodeNetWork){
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
//            return IS_IPHONE_5?80:85;
//            return self.companyInformationFrame.totalHeight;
            return 100.0;
            break;
        case 1:
        {
            return [CompanyAddressMapCell computerCellHeihgt:self.viewModel.data.Address];
        }
        case 2:
        {
            return [CompanyIntroduceCell computerCellHeihgt:(self.viewModel.data?self.viewModel.data.Description:@"")  open:self.viewModel.isOpen];
        }
            break;
        case 3:
//            return IS_IPHONE_5?40:48;
            return 120.0 / 3.0;
            break;
        case 4:
        {
//            return self.viewModel.data.AppPositionInfoList.count * (IS_IPHONE_5?110:130)+2;
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
        
        cell.compaynInformationFrame = self.companyInformationFrame;
        
        [cell configureWithBean:self.viewModel.data];
        return cell;
    }
    if (indexPath.row == 1) {
        CompanyAddressMapCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyAddressMapCell class])];
        if(cell == nil)
        {
            cell = [[CompanyAddressMapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CompanyAddressMapCell class])];
        }
        if ( !self.viewModel.data.Address || self.viewModel.data.Address.length == 0 )
        {
            cell.addressLabel.text = @"没有详细地址";
            cell.addressButton.enabled = NO;
        }
        else
        {
            cell.addressLabel.text = self.viewModel.data.Address;
            cell.addressButton.enabled = YES;
        }
        [cell.addressButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            CompanyMapVC *vc = [[CompanyMapVC alloc]initWithAddress:self.viewModel.data.Address];
            [self.navigationController pushViewController:vc animated:YES];
            
            [MobClick event:@"company_detail_location"];
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
                [cell.buttonMore setImage:[UIImage imageNamed:@"dropdownbox_ic_down"] forState:UIControlStateNormal];
                self.viewModel.isOpen = NO;
                cell.isOpen = self.viewModel.isOpen;
                
                [MobClick event:@"company_detail_view_more"];
            }
            else
            {
                [cell.buttonMore setTitle:@"点击收起" forState:UIControlStateNormal];
                [cell.buttonMore setImage:[UIImage imageNamed:@"dropdownbox_ic_up"] forState:UIControlStateNormal];
                self.viewModel.isOpen = YES;
                cell.isOpen = self.viewModel.isOpen;
                
                [MobClick event:@"company_detail_click_on_the_fold"];
            }
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self.tableView reloadData];
        }
    }
    if (indexPath.row == 3) {
        TheCompanyJobVC *vc = [[TheCompanyJobVC alloc]initWithCompanyId:self.viewModel.data.CustomerId];
        [self.navigationController pushViewController:vc animated:YES];
        
        [MobClick event:@"company_detail_post_all"];
    }
}


- (void)didTouchOtherJob:(CPRecommendModelFrame *)recommendModelFrame
{
    JobSearchModel *model = recommendModelFrame.recommendModel;
    NewJobDetialVC *vc = [[NewJobDetialVC alloc] initWithJobId:model.PositionId companyId:self.viewModel.data.CustomerId pstType:model.PositionType];
    [self.navigationController pushViewController:vc animated:YES];
    
    [MobClick event:@"company_detail_other_post"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
