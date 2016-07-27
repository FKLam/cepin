//
//  SaveCompanyVC.m
//  cepin
//  关注企业
//  Created by ricky.tang on 14-10-29.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SaveCompanyVC.h"
#import "CompanyCell.h"
#import "SaveCompanyVM.h"
#import "RTNetworking+Company.h"
#import "SaveCompanyModel.h"
#import "CompanyDetailNewVC.h"
#import "CompanyDetailVC.h"
#import "CPRecommendModelFrame.h"


@interface SaveCompanyVC ()
@property(nonatomic,strong)SaveCompanyVM *viewModel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,assign)BOOL isSelect;

@end

@implementation SaveCompanyVC

-(void)memoryRelease
{
    [self.viewModel momeryRelease];
    self.viewModel = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.viewModel = [SaveCompanyVM new];
        self.isSelect = NO;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收藏企业";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - (IsIOS7?108:88)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    self.tableView.rowHeight = 200 / 3.0;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
   
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
    self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.hidden = YES;
    self.titleLabel.text = @"抱歉！你还没有收藏企业";
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(40));
        make.width.equalTo(@(250));
    }];
    
    self.subLabel = [[UILabel alloc]init];
    self.subLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    self.subLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    self.subLabel.text = @"马上查看有兴趣的企业并果断收藏吧！";
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    self.subLabel.hidden = YES;
    [self.view addSubview:self.subLabel];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(40));
        make.width.equalTo(@(300));
    }];
    
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeDownloading:
                self.viewModel.isLoading = YES;
                [self startRefleshAnimation];
                break;
            case HUDCodeLoadMore:
                self.viewModel.isLoading = YES;
                [self startUpdateAnimation];
                break;
            case HUDCodeReflashSucess:
                [self.viewModel.selectedCompanies removeAllObjects];
                [self stopRefleshAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                self.tableView.hidden = NO;
                self.titleLabel.hidden = YES;
                self.subLabel.hidden = YES;
                self.networkImage.hidden = YES;
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                [self.tableView reloadData];
                self.tableView.hidden = NO;
                self.viewModel.isLoading = NO;
                self.networkImage.hidden = NO;
                break;
            case HUDCodeNetWork:
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.titleLabel.hidden = YES;
                self.subLabel.hidden = YES;
                self.tableView.hidden = YES;
            
            }
                break;
            default:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.viewModel.isLoading = NO;
                [self.tableView reloadData];
                self.titleLabel.hidden = NO;
                self.subLabel.hidden = NO;
                self.tableView.hidden = YES;
                self.networkImage.hidden = NO;
                break;
        }
    }];
    
    
    [self setupRefleshScrollView];
    [self setupDropDownScrollView];
    self.tableView.showsInfiniteScrolling = NO;
    [self refleshTable];
}

- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self refleshTable];
}

- (void)reloadData
{
    [self.tableView reloadData];
    [self refleshTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refleshTable];
    [self.tableView reloadData];
}
-(void)refleshTable
{
    [self.viewModel reflashPage];
}

-(void)updateTable
{
    [self.viewModel nextPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
//    return recommendModelFrame.totalFrame.size.height;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CompanyCell class])];
    if (cell == nil) {
        cell = [[CompanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CompanyCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setChoice:[self.viewModel selectedWithIndex:indexPath.row]];
    
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    
    SaveCompanyModel *bean;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[SaveCompanyModel class]] )
        bean = (SaveCompanyModel *)recommendModelFrame.recommendModel;
    
    [cell configWithBean:bean];
    
    cell.isChoice = NO;
    [cell.buttonDelete handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        cell.isChoice = !cell.isChoice;
        [cell setChoice:cell.isChoice];
        if (cell.isChoice)
        {
            [self.viewModel.selectedCompanies addObject:self.viewModel.datas[indexPath.row]];
        }else{
            [self.viewModel.selectedCompanies removeObject:self.viewModel.datas[indexPath.row]];
        }
        if ([self.delegate respondsToSelector:@selector(getCompanySelect:)]) {
            [self.delegate getCompanySelect:self.viewModel.selectedCompanies];
        }
    }];
    
    if ( indexPath.row == [self.viewModel.datas count] - 1 )
        cell.lineView.hidden = YES;
    else
        cell.lineView.hidden = NO;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    
    SaveCompanyModel *bean;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[SaveCompanyModel class]] )
        bean = (SaveCompanyModel *)recommendModelFrame.recommendModel;
    
    CompanyDetailVC *vc = [[CompanyDetailVC alloc] initWithCompanyId:bean.CustomerId];
    //vc.title = bean.CompanyName;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
