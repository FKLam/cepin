//
//  PoliticsVC.m
//  cepin
//
//  Created by dujincai on 15/6/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "PoliticsVC.h"
#import "ResumeChooseCell.h"
#import "PoliticsVM.h"
#import "BaseCodeDTO.h"
#import "CPCommon.h"
@interface PoliticsVC ()

@property(nonatomic,strong)PoliticsVM *viewModel;
@end

@implementation PoliticsVC

- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [PoliticsVM new];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"政治面貌";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil)
    {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    
    BaseCode *item = self.viewModel.datas[indexPath.row];
    cell.titleLabel.text = item.CodeName;
    if ([self.model.Politics isEqualToString:item.CodeName])
    {
        cell.chooseImage.hidden = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.viewModel.datas count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *item = self.viewModel.datas[indexPath.row];
    self.model.Politics = item.CodeName;
    self.model.PoliticsKey = [NSString stringWithFormat:@"%@",item.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}
@end