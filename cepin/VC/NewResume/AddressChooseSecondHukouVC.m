//
// 
//  cepin
//
//  Created by ricky.tang on 14-10-22.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "AddressChooseSecondHukouVC.h"

#import "AddressChooseHuKouSecondVM.h"
#import "RegionDTO.h"
#import "ChooseCell.h"
#import "TBTextUnit.h"
#import "SubscriptionJobVC.h"
#import "AddResumeVC.h"
#import "SchoolAddResumeVC.h"
@interface AddressChooseSecondHukouVC ()
@property(nonatomic,strong)AddressChooseHuKouSecondVM *viewModel;
@property(nonatomic,assign)BOOL isFirstSelect;
@property(nonatomic,strong)ResumeNameModel *model;
@end

@implementation AddressChooseSecondHukouVC

-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities model:(ResumeNameModel *)model
{
    if (self = [super init])
    {
        self.model = model;
        self.viewModel = [[AddressChooseHuKouSecondVM alloc] initWithCities:cities selectedCity:selectedCities];
        Region *region = self.viewModel.cities[0];
        BOOL isSelected = NO;
        for (Region *item in self.viewModel.selectedCity) {
            if ([item.RegionName isEqualToString:region.RegionName]) {
                isSelected = YES;
                break;
            }
        }
        self.isFirstSelect = isSelected;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"城市筛选";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.cities.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseCell class])];
    if(cell==nil)
    {
        cell=[[ChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ChooseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Region *region = self.viewModel.cities[indexPath.row];
    if (indexPath.row == 0)
    {
        cell.labelTitle.text = [NSString stringWithFormat:@"%@",region.RegionName];
    }
    else
    {
        cell.labelTitle.text = region.RegionName;
    }
    
    cell.labelSub.hidden = YES;
    cell.chooseType = ChooseSelectType;
    
    if (self.isFirstSelect)
    {
        if (indexPath.row == 0)
        {
            cell.selectType = ChooseHasSelect;
        }
        else
        {
            cell.selectType = ChooseDisable;
        }
    }
    else
    {
        BOOL isSelected = NO;
        
        for (Region *item in self.viewModel.selectedCity) {
            if ([item.RegionName isEqualToString:region.RegionName]) {
                isSelected = YES;
                break;
            }
        }
        
        if (isSelected)
        {
            cell.selectType = ChooseHasSelect;
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
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Region *region = self.viewModel.cities[indexPath.row];
//    BOOL isSelected = NO;
//    Region *tempItem = nil;
    for (Region *item in self.viewModel.selectedCity) {
        if ([item.RegionName isEqualToString:region.RegionName]) {
//            isSelected = YES;
//            tempItem = item;
            break;
        }
    }
    
    if (self.viewModel.selectedCity) {
        [self.viewModel.selectedCity removeAllObjects];
    }
    [self.viewModel.selectedCity addObject:region];
    
    Region *it = self.viewModel.selectedCity[0];
    self.model.Hukou = it.RegionName;
    self.model.HukouKey = it.PathCode;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[AddResumeVC class]] || [vc isKindOfClass:[SchoolAddResumeVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
}


@end
