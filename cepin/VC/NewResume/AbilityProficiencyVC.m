//
//  AbilityProficiencyVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AbilityProficiencyVC.h"
#import "BaseCodeDTO.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface AbilityProficiencyVC ()

@property(nonatomic,strong)NSMutableArray *abilityData;
@end

@implementation AbilityProficiencyVC
- (instancetype)initWithEduModel:(SkillDataModel *)model
{
    self = [super init];
    if (self) {
        self.abilityData = [NSMutableArray new];
        self.abilityData = [BaseCode skillLevel];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"熟练度";
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
    return self.abilityData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    
    BaseCode *item = self.abilityData[indexPath.row];
    cell.titleLabel.text = item.CodeName;
    if ([self.model.MasteryLevel isEqualToString:item.CodeName]) {
        cell.chooseImage.hidden = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.abilityData count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *item = self.abilityData[indexPath.row];
    self.model.MasteryLevel = item.CodeName;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
