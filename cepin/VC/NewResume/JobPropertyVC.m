//
//  JobPropertyVC.m
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobPropertyVC.h"
#import "AddExpectJobVC.h"
#import "ResumeChooseCell.h"
#import "BaseCodeDTO.h"
#import "CPCommon.h"
@interface JobPropertyVC ()
@property(nonatomic,strong)NSArray *titleArrays;
@end

@implementation JobPropertyVC

- (instancetype)initWithResumeModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.resumeModel = model;
        self.titleArrays = @[@"全职",@"实习"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作性质";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake( 30 / CP_GLOBALSCALE, 0, 0, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPaths
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    cell.titleLabel.text = self.titleArrays[indexPaths.row];
    NSString *str = nil;
    if ([self.resumeModel.ExpectEmployType isEqualToString:@"1"]) {
        str = @"全职";
    }else if([self.resumeModel.ExpectEmployType isEqualToString:@"4"])
    {
        str = @"实习";
    }
    if ([str isEqualToString:self.titleArrays[indexPaths.row]]) {
        cell.chooseImage.hidden  = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPaths.row == [self.titleArrays count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.titleArrays[indexPath.row] isEqualToString:@"全职"]) {
        self.resumeModel.ExpectEmployType = @"1";
    }else{
        self.resumeModel.ExpectEmployType = @"4";
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
