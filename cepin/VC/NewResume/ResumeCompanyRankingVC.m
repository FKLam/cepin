//
//  ResumeCompanyRankingVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyRankingVC.h"
#import "BaseCodeDTO.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface ResumeCompanyRankingVC ()
@property(nonatomic,strong)NSArray *ranking;
@end

@implementation ResumeCompanyRankingVC
-(instancetype)initWithWorkModel:(WorkListDateModel *)model
{
    if (self = [super init])
    {
        self.ranking = @[@"中国500强", @"世界500强", @"其他"];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司排名";
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
    return self.ranking.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    NSString *str =self.ranking[indexPath.row];
    cell.titleLabel.text = str;
    if ([str isEqualToString:self.model.CompanyRanking]) {
        cell.chooseImage.hidden = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.ranking count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model.CompanyRanking = self.ranking[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
