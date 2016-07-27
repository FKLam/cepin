//
//  ExpectSalaryVC.m
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExpectSalaryVC.h"
#import "ResumeChooseCell.h"
#import "AddExpectJobVC.h"
#import "CPCommon.h"
@interface ExpectSalaryVC ()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *sarrayArray;
@end

@implementation ExpectSalaryVC

- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if ( self )
    {
        self.resumeModel = model;
        self.titleArray = @[@"2K以内",@"2K-5K",@"5K-10K",@"10K-15K",@"15K-20K",@"20K-25K",@"25K以上"];
        self.sarrayArray = [NSMutableArray new];
        if ( !model.ExpectSalary || [model.ExpectSalary isEqualToString:@""] ) {
            [self.sarrayArray removeAllObjects];
        }
        else
        {
            [self.sarrayArray addObject:model.ExpectSalary];
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"期望薪酬";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake( 30 / CP_GLOBALSCALE, 0, 0, 0)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.resumeModel.ExpectSalary = self.titleArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil)
    {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    BOOL isSelect = NO;
    if (self.sarrayArray.count > 0)
    {
        for (NSString *salary in self.sarrayArray)
        {
            if ([salary isEqualToString:self.titleArray[indexPath.row]]) {
                isSelect = YES;
                break;
            }
        }
        if (isSelect)
        {
            cell.isSelect = isSelect;
        }
        else
        {
            cell.isSelect = NO;
        }
    }
    else
    {
        cell.isSelect = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.titleArray count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
@end
