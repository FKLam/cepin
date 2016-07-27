//
//  AwardListVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AwardListVC.h"
#import "AwardListCell.h"
#import "UIViewController+NavicationUI.h"
#import "EditAwardVC.h"
#import "AwardListVM.h"
#import "AddAwardListVC.h"
#import "CPPraciticeAwardCell.h"
#import "CPCommon.h"
@interface AwardListVC ()<AwardListCellDelegate>
@property(nonatomic,strong)AwardListVM *viewModel;
@property(nonatomic,retain)NSIndexPath      *currentIndexPath;
@property(nonatomic,strong)UIImageView *wuImage;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UILabel *secLabel;
@end
@implementation AwardListVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[AwardListVM alloc]initWithResumeModel:model];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getAwardList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"曾获奖励";
    [[self addNavicationObjectWithType:NavcationBarObjectTypeAddExperience] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        AddAwardListVC *vc = [[AddAwardListVC alloc] initWithResumeId:self.viewModel.resumeId];
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:@"edit_honour"];
    }];
    
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            self.networkImage.hidden = YES;
            self.subLabel.hidden = YES;
            self.secLabel.hidden = YES;
           
             self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else if ([self requestStateWithStateCode:stateCode] == HUDCodeNetWork){
            self.networkLabel.hidden = NO;
            [self.networkImage setImage:UIIMAGE(@"null_exam_linkbroken")];
            [self.networkLabel setText:@"当前网络不可用，请检查网络设置"];
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
        }
        
        else
        {
            self.networkLabel.hidden = NO;
            [self.networkImage setImage:UIIMAGE(@"null_info")];
            [self.networkLabel setText:@"您还没有填写任何信息,\n马上添加为简历加分吧!"];
            self.tableView.hidden = YES;
            self.networkImage.hidden = NO;
//            self.subLabel.hidden = NO;
//            self.secLabel.hidden = NO;
        }
        
    }];
    
    
    [RACObserve(self.viewModel,deleteCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            
            [self.viewModel getAwardList];
            [self.tableView reloadData];
        }
    }];

    self.subLabel = [[UILabel alloc]init];
    self.subLabel.text = @"您还没有填写任何信息,";
    self.subLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.subLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.networkImage.mas_bottom).offset(10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(250));
    }];
    
    self.secLabel = [[UILabel alloc]init];
    self.secLabel.text = @"马上添加为简历加分吧!";
    self.secLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.secLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    self.secLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.secLabel];
    [self.secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.subLabel.mas_bottom);
        make.height.equalTo(@(40));
        make.width.equalTo(@(250));
    }];
    self.subLabel.hidden = YES;
    self.secLabel.hidden = YES;
}

- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getAwardList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ( 60 + 60 + 36 + 40 + 36 + 60 + 6 ) / CP_GLOBALSCALE;
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.awardDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AwardsListDataModel *model = [AwardsListDataModel beanFromDictionary:self.viewModel.awardDatas[indexPath.row]];
    CPPraciticeAwardCell *cell = [CPPraciticeAwardCell awardCellWithTableView:tableView];
    [cell configCellWithAward:model];
    [cell.editButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        EditAwardVC *vc = [[EditAwardVC alloc] initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(void)PushCellDelete:(AwardListCell *)cell model:(AwardsListDataModel *)model
{
    [self.viewModel deleteAwardListWith:model.Id];
}
-(void)GestureGo:(AwardListCell *)cell isReset:(BOOL)isReset
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (isReset)
    {
        if (self.currentIndexPath)
        {
            if (self.currentIndexPath.row != indexPath.row)
            {
                AwardListCell *cell = (AwardListCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
                [cell resetCell];
            }
        }
        self.currentIndexPath = indexPath;
    }
    else
    {
        self.currentIndexPath = nil;
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.currentIndexPath)
    {
        AwardListCell *cell = (AwardListCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell resetCell];
        self.currentIndexPath = nil;
    }
}

@end
