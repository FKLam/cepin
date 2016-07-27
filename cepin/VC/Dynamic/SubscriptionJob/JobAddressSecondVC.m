//
//  JobAddressSecondVC.m
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobAddressSecondVC.h"
#import "RegionDTO.h"
#import "ChooseCell.h"
#import "SubscriptionJobVC.h"
#import "JobAddressSecondVM.h"
@interface JobAddressSecondVC ()
@property(nonatomic,strong)JobAddressSecondVM *viewModel;
@end

@implementation JobAddressSecondVC

- (instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities model:(SubscriptionJobModel *)model
{
    if (self = [super init])
    {
        self.viewModel = [[JobAddressSecondVM alloc]initWithCities:cities selectedCity:selectedCities];
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = IS_IPHONE_5?40:48;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    BOOL isSelected = NO;
    
    for (Region *item in self.viewModel.selectedCity) {
        if ([item.RegionName isEqualToString:region.RegionName]) {
            isSelected = YES;
            break;
        }
    }
    
    if (isSelected)
    {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Region *region = self.viewModel.cities[indexPath.row];
    BOOL isSelected = NO;
    Region *tempItem = nil;
    for (Region *item in self.viewModel.selectedCity) {
        if ([item.RegionName isEqualToString:region.RegionName]) {
            isSelected = YES;
            tempItem = item;
            break;
        }
    }
    
    if (self.viewModel.selectedCity) {
        [self.viewModel.selectedCity removeAllObjects];
    }
    [self.viewModel.selectedCity addObject:region];
    
    Region *it = self.viewModel.selectedCity[0];
    self.model.address = it.RegionName;
    self.model.addresskey = [NSString stringWithFormat:@"%@",it.PathCode];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SubscriptionJobVC class]]) {
            
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
}

@end
