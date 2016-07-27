//
//  ResumeCompanyIndustryVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyIndustryVC.h"
#import "BaseCodeDTO.h"
#import "ResumeCompanyIndustryVM.h"
#import "ResumeCompanyIndustryCell.h"
#import "IndustrySecondCell.h"
#import "CPResumeWorkExperienceIndustryCell.h"
#import "CPCommon.h"
@interface ResumeCompanyIndustryVC ()<ResumeCompanyIndustryCellDelegate, CPResumeWorkExperienceIndustryCellDelegate>
@property(nonatomic,strong)ResumeCompanyIndustryVM *viewModel;
@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,strong)NSMutableArray *headView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectedFirstRow;
@property (nonatomic, strong) NSMutableArray *childCityArrayM;
@end
@implementation ResumeCompanyIndustryVC
- (instancetype)initWithWorkModel:(WorkListDateModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [ResumeCompanyIndustryVM new];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行业";
    self.selectedFirstRow = -1;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.dataArray = [NSMutableArray new];
    for (int i = 0; i < self.viewModel.industryData.count; i++)
    {
        BaseCode *item = self.viewModel.industryData[i];
        [self.dataArray addObject:item.CodeName];
    }
    [self loadModel];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.tableView setContentInset:UIEdgeInsetsMake( 30 / CP_GLOBALSCALE, 0, 0, 0)];
    for ( BaseCode *item in self.viewModel.industryData )
    {
        NSArray *array = [BaseCode SecondLevelIndustryWithPathCode:item.PathCode];
        [self.childCityArrayM addObject:array];
    }
}
- (void)loadModel
{
    self.headView = [NSMutableArray new];
    for (int i = 0; i < self.dataArray.count; i ++ ) {
        ResumeCompanyIndustryCell *headView = [[ResumeCompanyIndustryCell alloc]init];
        headView.delegate = self;
        headView.section = i;
        headView.jobName.text = [NSString stringWithFormat:@"%@",self.dataArray[i]];
        [self.headView addObject:headView];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.selectedFirstRow == indexPath.row )
    {
        NSMutableArray *childArray = [self.childCityArrayM objectAtIndex:indexPath.row];
        CGFloat height = 144.0 / CP_GLOBALSCALE * ([childArray count] + 1);
        return height;
    }
    return 144.0 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.industryData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPResumeWorkExperienceIndustryCell *cell = [CPResumeWorkExperienceIndustryCell workExperienceIndustryCellWithTableView:tableView];
    [cell setWorkExperienceDelegate:self];
    BaseCode *baseCode = self.viewModel.industryData[indexPath.row];
    BOOL isSelected = NO;
    if ( self.selectedFirstRow == indexPath.row )
        isSelected = YES;
    NSMutableArray *childArray = self.childCityArrayM[indexPath.row];
    BaseCode *selectedBasecode;
    if ( [self.model.Industry length] > 0 )
    {
        for ( NSMutableArray *childArray in self.childCityArrayM )
        {
            for ( BaseCode *child in childArray )
            {
                if ( [child.CodeName isEqualToString:self.model.Industry] )
                {
                    selectedBasecode = child;
                    break;
                }
            }
            if ( selectedBasecode )
                break;
        }
    }
    [cell configWithTitle:baseCode.CodeName childArray:childArray isSelected:isSelected selectedBaseode:selectedBasecode];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.row != self.selectedFirstRow )
    {
        NSInteger tempRow = -1;
        if ( -1 != self.selectedFirstRow )
            tempRow = self.selectedFirstRow;
        self.selectedFirstRow = indexPath.row;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        if ( -1 != tempRow )
        {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        NSInteger tempRow = -1;
        tempRow = self.selectedFirstRow;
        self.selectedFirstRow = -1;
        if ( -1 != tempRow )
        {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
#pragma mark - HeadViewdelegate
-(void)selectedWith:(ResumeCompanyIndustryCell *)view
{
    if (view.open) {
        for(int i = 0;i<[self.headView count];i++)
        {
            ResumeCompanyIndustryCell *head = [self.headView objectAtIndex:i];
            head.open = NO;
            //            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        return;
    }
    self.currentSection = view.section;
    [self reset];
}
//界面重置
- (void)reset
{
    for(int i = 0;i<[self.headView count];i++)
    {
        ResumeCompanyIndustryCell *head = [self.headView objectAtIndex:i];
        
        if(head.section == self.currentSection)
        {
            head.open = YES;
        }else {
            head.open = NO;
        }
        
    }
    [self.tableView reloadData];
}
#pragma mark - CPResumeWorkExperienceIndustryCellDelegate
- (void)workExperienceCell:(CPResumeWorkExperienceIndustryCell *)workExperienceCell didSelectedBasecode:(BaseCode *)selectedBaseode
{
    self.model.Industry = selectedBaseode.CodeName;
    self.model.IndustryKey = [NSString stringWithFormat:@"%@", selectedBaseode.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - getter methods
- (NSMutableArray *)childCityArrayM
{
    if ( !_childCityArrayM )
    {
        _childCityArrayM = [NSMutableArray array];
    }
    return _childCityArrayM;
}
@end
