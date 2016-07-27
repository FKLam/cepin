//
//  AddEducationVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddEducationVC.h"
#import "UIViewController+NavicationUI.h"
#import "EditEducationVC.h"
#import "EducationCell.h"
#import "AddEducationVM.h"
#import "EducationListVC.h"
#import "CPEducationExperienceCell.h"
#import "CPResumeEducationReformer.h"
#import "CPCommon.h"
@interface AddEducationVC ()<EducationCellDelegate>
@property(nonatomic,strong)AddEducationVM *viewModel;
@property(nonatomic,retain)NSIndexPath      *currentIndexPath;
@property(nonatomic,strong)UIImageView *wuImage;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UILabel *secLabel;
@property(nonatomic,assign)BOOL isSocial;
@property (nonatomic, strong) ResumeNameModel *resume;
@end
@implementation AddEducationVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[AddEducationVM alloc]initWithResumeModel:model];
        if(model.ResumeType.intValue == 2){
            self.isSocial = NO;
        }else{
            self.isSocial = YES;
        }
        self.viewModel.showMessageVC = self;
        self.resume = model;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getEducationList];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"教育经历";
    [MobClick event:@"education_experience_launch"];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeAddExperience] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        EducationListVC *vc = [[EducationListVC alloc] initWithResume:self.resume isSocial:self.isSocial];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            self.networkImage.hidden = YES;
            self.networkButton.hidden = YES;
            self.networkLabel.hidden = YES;
            self.subLabel.hidden = YES;
            self.secLabel.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            self.currentIndexPath = nil;
        }else if ([self requestStateWithStateCode:stateCode] == HUDCodeNetWork){
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
            self.networkImage.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
    [RACObserve(self.viewModel,deleteCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            
            [self.viewModel getEducationList];
        }
    }];
    self.subLabel = [[UILabel alloc]init];
    self.subLabel.text = @"您还没有填写任何信息,";
    self.subLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.subLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    [self.view addSubview:self.subLabel];
    self.subLabel.textAlignment = NSTextAlignmentCenter;
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
    [self.view addSubview:self.secLabel];
    self.secLabel.textAlignment = NSTextAlignmentCenter;
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
    [self.viewModel getEducationList];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationListDateModel *model = [EducationListDateModel beanFromDictionary:self.viewModel.eduDatas[indexPath.row]];
    CGFloat rowHeight = [CPResumeEducationReformer educationListRowHeightWithEducationModel:model];
    return rowHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.eduDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationListDateModel *model = [EducationListDateModel beanFromDictionary:self.viewModel.eduDatas[indexPath.row]];
    CPEducationExperienceCell *cell = [CPEducationExperienceCell educationExperienceCellWithTableView:tableView];
    [cell configCellWithEducationExperience:model];
    __weak typeof( self ) weakSelf = self;
    [cell.editButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        EducationListDateModel *model = [EducationListDateModel beanFromDictionary:weakSelf.viewModel.eduDatas[indexPath.row]];
        EditEducationVC *vc = [[EditEducationVC alloc] initWithModel:model isSocial:weakSelf.isSocial];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(void)PushCellDelete:(EducationCell *)cell model:(EducationListDateModel *)model
{
    [self.viewModel deleteEduListWith:model];
}
-(void)GestureGo:(EducationCell *)cell isReset:(BOOL)isReset
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (isReset)
    {
        if (self.currentIndexPath)
        {
            if (self.currentIndexPath.row != indexPath.row)
            {
                EducationCell *cell = (EducationCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
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
        EducationCell *cell = (EducationCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell resetCell];
        self.currentIndexPath = nil;
    }
}
@end
