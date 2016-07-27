//
//  ExpectAddressSecendVC.m
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExpectAddressSecendVC.h"

#import "ExpectAddressSecendVM.h"
#import "RegionDTO.h"
#import "ChooseCell.h"
#import "TBTextUnit.h"
#import "SubscriptionJobVC.h"
#import "AddExpectJobVC.h"
#import "SignupExpectJobVC.h"
#import "JobFunctionFilterCell.h"
@interface ExpectAddressSecendVC ()<AOTagDelegate>
@property(nonatomic,strong)ExpectAddressSecendVM *viewModel;
@property(nonatomic,strong)NSMutableArray *seleArray;
@property(nonatomic,assign)BOOL isShrink;
@property(nonatomic,strong)ResumeNameModel *model;
@property(nonatomic,assign)int cellHight;
@end

@implementation ExpectAddressSecendVC

-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities model:(ResumeNameModel *)model
{
    if (self = [super init])
    {
        self.isShrink = NO;
        self.model = model;
        self.seleArray = [NSMutableArray new];
        self.viewModel = [[ExpectAddressSecendVM alloc] initWithCities:cities selectedCity:selectedCities];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"城市筛选";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    
    [MobClick event:@"work_hot_region"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)tagDidRemoveTag:(AOTag *)tag
{
    [self.seleArray removeObject:tag.tTitle];
    
    NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedCity]];
    [self.viewModel.selectedCity removeAllObjects];
    for (Region *item in array) {
        if (![tag.tTitle isEqualToString:item.RegionName]) {
            NSString *str = [NSString stringWithFormat:@"%@",item.PathCode];
            [self.viewModel.selectedCity addObject:str];
        }
    }
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.cities.count + 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JobFunctionFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JobFunctionFilterCell class])];
        if (cell == nil) {
            cell = [[JobFunctionFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JobFunctionFilterCell class])];
        }
        
        
        NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedCity]];
        cell.countLabel.text = [NSString stringWithFormat:@"已选%lu/3",(unsigned long)array.count];
        [self.seleArray removeAllObjects];
        for (int i = 0; i < array.count; i++) {
            Region *item = array[i];
            [self.seleArray addObject:item.RegionName];
        }
        [cell.tagListView setDelegate:self];
        [cell.tagListView removeAllTag];
        for (NSInteger i = 0; i < self.seleArray.count; i++)
        {
            [cell.tagListView addTag:[self.seleArray objectAtIndex:i] withImage:nil withLabelColor:[UIColor whiteColor]  withBackgroundColor:[[RTAPPUIHelper shareInstance] labelColorGreen] withCloseButtonColor:[UIColor whiteColor]];
        }
        [cell.clickButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (!self.isShrink) {
                self.cellHight = 60;
                cell.tagListView.hidden = YES;
                self.isShrink = !self.isShrink;
            }else
            {
                self.cellHight = 100;
                cell.tagListView.hidden = NO;
                self.isShrink = !self.isShrink;
            }
            [self.tableView reloadData];
        }];
        return cell;
    }
    
    
    ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseCell class])];
    if(cell==nil)
    {
        cell=[[ChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ChooseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Region *region = self.viewModel.cities[indexPath.row - 1];
    
    [cell configureLableTitleText:region.RegionName];
    
    NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedCity]];
    NSMutableArray *mutArray = [NSMutableArray new];
    for (int i = 0; i < array.count; i++) {
        Region *item = array[i];
        [mutArray addObject:item.RegionName];
    }
    
    cell.labelSub.hidden = YES;
    cell.chooseType = ChooseSelectType;
    BOOL isSelected = NO;
    
    for (NSString *item in mutArray) {
        if ([item isEqualToString:region.RegionName]) {
            isSelected = YES;
            break;
        }
    }
    if (isSelected)
    {
        cell.selectType = ChooseHasSelect;
        cell.isSelected = isSelected;
    }
    else
    {
        if (self.viewModel.selectedCity.count >= 3)
        {
            cell.selectType = ChooseDisable;
        }
        else
        {
            cell.selectType = ChooseEnable;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.cellHight?self.cellHight:60;
    }
    return IS_IPHONE_5?40:48;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    
    [MobClick event:@"work_hot_region"];
    
    Region *region = self.viewModel.cities[indexPath.row - 1];
    BOOL isSelected = NO;
    NSString *tempItem = nil;
    for (NSString *item in self.viewModel.selectedCity) {
        if ([item isEqualToString:region.PathCode]) {
            isSelected = YES;
            tempItem = item;
            break;
        }
    }
    if (isSelected) {
        [self.viewModel.selectedCity removeObject:tempItem];
    }
    else{
        if (self.viewModel.selectedCity.count > 2) {
            [OMGToast showWithText:@"城市不能超过三个" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        }else
        {
            [self.viewModel.selectedCity addObject:region.PathCode];
        }
    }
    [self.tableView reloadData];

    
}
@end
