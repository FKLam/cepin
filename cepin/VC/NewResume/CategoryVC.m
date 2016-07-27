//
//  CategoryVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CategoryVC.h"
#import "BaseCodeDTO.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface CategoryVC ()
@property(nonatomic,strong)NSMutableArray *categoryData;
@end

@implementation CategoryVC
- (instancetype)initWithEduModel:(LanguageDataModel *)model
{
    self = [super init];
    if (self) {
        self.categoryData = [NSMutableArray new];
        self.categoryData = [BaseCode languages];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"语言类别";
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
    return self.categoryData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    
    BaseCode *item = self.categoryData[indexPath.row];
    cell.titleLabel.text = item.CodeName;
    if ([self.model.Name isEqualToString:item.CodeName]) {
        cell.chooseImage.hidden = NO;
    }else
    {
        cell.chooseImage.hidden = YES;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.categoryData count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     BaseCode *item = self.categoryData[indexPath.row];
    self.model.Name = item.CodeName;
    self.model.BaseCodeKey = [NSString stringWithFormat:@"%@",item.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
