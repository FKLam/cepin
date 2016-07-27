//
//  JiangLiJiBieVC.m
//  cepin
//
//  Created by dujincai on 15/6/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JiangLiJiBieVC.h"
#import "ResumeChooseCell.h"
#import "BaseCodeDTO.h"
#import "CPCommon.h"
@interface JiangLiJiBieVC ()
@property(nonatomic,strong)NSMutableArray *leverData;

@end

@implementation JiangLiJiBieVC
- (instancetype)initWithEduModel:(AwardsListDataModel *)model
{
    self = [super init];
    if (self) {
        self.leverData = [NSMutableArray new];
        self.leverData = [BaseCode award];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖励级别";
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
    return self.leverData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    
    BaseCode *item = self.leverData[indexPath.row];
    cell.titleLabel.text = item.CodeName;
    if ([self.model.Level isEqualToString:item.CodeName]) {
        cell.chooseImage.hidden = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.leverData count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BaseCode *item = self.leverData[indexPath.row];
    self.model.Level = item.CodeName;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
