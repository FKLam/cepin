//
//  MarriedVC.m
//  cepin
//
//  Created by dujincai on 15/6/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "MarriedVC.h"
#import "CPCommon.h"
#import "ResumeChooseCell.h"
@interface MarriedVC ()
@property(nonatomic,strong)NSArray *titleLabel;
@end

@implementation MarriedVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        self.titleLabel = @[@"未婚", @"已婚"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"婚姻状况";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.tableView setContentInset:UIEdgeInsetsMake( 30 / CP_GLOBALSCALE, 0, 0, 0)];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleLabel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    
    cell.titleLabel.text = self.titleLabel[indexPath.row];
    if (self.model.Marital == [NSNumber numberWithInteger:indexPath.row + 1]) {
        cell.chooseImage.hidden = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.titleLabel count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model.Marital = [NSNumber numberWithInteger:indexPath.row + 1];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
