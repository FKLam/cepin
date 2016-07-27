//
//  FuCongVC.m
//  cepin
//
//  Created by dujincai on 15/11/3.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "FuCongVC.h"
#import "ResumeChooseCell.h"
#import "ResumeNameModel.h"
#import "CPCommon.h"
@interface FuCongVC ()
@property(nonatomic,strong)NSArray *titleArray;
@end

@implementation FuCongVC

- (instancetype)initWithModel:(ResumeNameModel*)model
{
    self = [super init];
    if (self) {
        self.model = model;
        self.titleArray = @[@"是",@"否"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"是否服从分配";
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
    NSString *gender = [NSString stringWithFormat:@"%@",self.model.IsAllowDistribution];
    NSString *index = [NSString stringWithFormat:@"%d",(int)(indexPath.row + 1)];
    if(nil == self.model.IsAllowDistribution){
         cell.isSelect = NO;
        return cell;
    }
    if ([gender isEqualToString:index]) {
        cell.isSelect = YES;
    }else
    {
        if(self.model.IsAllowDistribution.intValue == 0 && indexPath.row==1){
            cell.isSelect = YES;
        }else{
             cell.isSelect = NO;
        }
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.titleArray count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model.IsAllowDistribution = [NSNumber numberWithInteger:indexPath.row + 1];
    if (self.model.IsAllowDistribution.intValue == 2) {
        self.model.IsAllowDistribution = [NSNumber numberWithInt:0];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
