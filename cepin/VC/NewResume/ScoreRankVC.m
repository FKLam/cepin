//
//  ScoreRankVC.m
//  cepin
//
//  Created by dujincai on 15/11/4.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "ScoreRankVC.h"
#import "ResumeChooseCell.h"
#import "ResumeNameModel.h"
#import "CPCommon.h"
@interface ScoreRankVC ()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *indexArray;
@end
@implementation ScoreRankVC
- (instancetype)initWithModel:(EducationListDateModel*)model
{
    self = [super init];
    if (self) {
        self.model = model;
        self.titleArray = @[@"年级前5%", @"年级前10%", @"年级前20%", @"年级前50%", @"其他"];
        self.indexArray = @[@"5", @"10", @"20", @"50", @"0"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成绩排名";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.tableView setContentInset:UIEdgeInsetsMake( 30 / CP_GLOBALSCALE, 0, 0, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    NSString *gender = [NSString stringWithFormat:@"%@",self.model.ScoreRanking];
   
    
    if ([gender isEqualToString:self.indexArray[indexPath.row]]) {
        cell.isSelect = YES;
    }else
    {
        cell.isSelect = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.titleArray count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model.ScoreRanking = self.self.indexArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
