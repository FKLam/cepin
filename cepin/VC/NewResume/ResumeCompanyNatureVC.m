//
//  ResumeCompanyNatureVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyNatureVC.h"
#import "BaseCodeDTO.h"
#import "ResumeChooseCell.h"
#import "ResumeCompanyNatureVM.h"
#import "CPCommon.h"
@interface ResumeCompanyNatureVC ()
@property(nonatomic,strong)ResumeCompanyNatureVM *viewModel;

@end

@implementation ResumeCompanyNatureVC

- (instancetype)initWithWorkModel:(WorkListDateModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[ResumeCompanyNatureVM alloc]initWithSelected:model.NatureKey];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司性质";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    BaseCode *item = self.viewModel.datas[indexPath.row];
    cell.titleLabel.text = item.CodeName;
    
    BOOL isSelected = NO;
    for (BaseCode *str in self.viewModel.selection) {
        if ([str.CodeName isEqualToString:item.CodeName]) {
            isSelected = YES;
            break;
        }
    }
    if (isSelected) {
        cell.isSelect = isSelected;
    }else
    {
        cell.isSelect = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.viewModel.datas count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *item = self.viewModel.datas[indexPath.row];
    self.model.Nature = item.CodeName;
    self.model.NatureKey = [NSString stringWithFormat:@"%@",item.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
