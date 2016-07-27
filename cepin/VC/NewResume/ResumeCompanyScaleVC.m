//
//  ResumeCompanyScaleVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyScaleVC.h"
#import "BaseCodeDTO.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface ResumeCompanyScaleVC ()
@property(nonatomic,strong)NSMutableArray *scaleArray;
@end

@implementation ResumeCompanyScaleVC
-(instancetype)initWithWorkModel:(WorkListDateModel *)model
{
    if (self = [super init])
    {
        self.scaleArray = [BaseCode companySize];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司规模";
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
    return self.scaleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    BaseCode *item = self.scaleArray[indexPath.row];
    cell.titleLabel.text = item.CodeName;
    if ([item.CodeName isEqualToString:self.model.Size]) {
        cell.chooseImage.hidden = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.scaleArray count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *item = self.scaleArray[indexPath.row];
    self.model.Size = item.CodeName;
    self.model.SizeKey = [NSString stringWithFormat:@"%@",item.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
