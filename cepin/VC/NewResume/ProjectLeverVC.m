//
//  ProjectLeverVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ProjectLeverVC.h"
#import "ResumeChooseCell.h"
#import "BaseCodeDTO.h"
#import "CPCommon.h"
@interface ProjectLeverVC ()
@property(nonatomic,strong)NSMutableArray *leverData;
@end

@implementation ProjectLeverVC
- (instancetype)initWithEduModel:(ProjectListDataModel *)model
{
    self = [super init];
    if (self) {
        self.leverData = [NSMutableArray new];
        self.leverData = [BaseCode KeyanLevel];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目级别";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
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
    if ([self.model.KeyanLevel isEqualToString:item.CodeName]) {
        cell.chooseImage.hidden = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.leverData count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        BaseCode *item = self.leverData[indexPath.row];
    self.model.KeyanLevel = item.CodeName;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
