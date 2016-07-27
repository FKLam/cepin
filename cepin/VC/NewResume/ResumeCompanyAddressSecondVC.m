//
//  
//  cepin
//
//  Created by ricky.tang on 14-10-22.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "ResumeCompanyAddressSecondVC.h"

#import "AddressChooseSecondVM.h"
#import "RegionDTO.h"
#import "ChooseCell.h"
#import "TBTextUnit.h"
#import "SubscriptionJobVC.h"
#import "ResumuEditJobExperienceVC.h"
#import "ResumeAddJobVC.h"
#import "ResumeCompanyAddressSecondVM.h"
#import "SchoolResumeAddJobVC.h"
#import "SchoolEditJobVC.h"
@interface ResumeCompanyAddressSecondVC ()
@property(nonatomic,assign)BOOL isFirstSelect;
@property(nonatomic,strong)ResumeCompanyAddressSecondVM *viewModel;
@end

@implementation ResumeCompanyAddressSecondVC

-(instancetype)initWithCities:(NSMutableArray *)cities selectedCity:(NSMutableArray *)selectedCities model:(WorkListDateModel *)model
{
    if (self = [super init])
    {
        self.viewModel = [[ResumeCompanyAddressSecondVM alloc]initWithCities:cities selectedCity:selectedCities];
        self.model = model;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"城市筛选";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = IS_IPHONE_5?40:48;
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
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    Region *region = self.datas[indexPath.row];
// 
//    cell.labelTitle.text = region.RegionName;
//    
//    cell.labelSub.hidden = YES;
//    cell.chooseType = ChooseSelectType;
//    if ([self.model.JobCity isEqualToString:region.RegionName]) {
//        cell.isSelected = YES;
//    }
    
    
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
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ResumuEditJobExperienceVC class]] || [vc isKindOfClass:[SchoolEditJobVC class]]) {
            Region *region = self.viewModel.cities[indexPath.row];
            self.model.JobCity = region.RegionName;
            self.model.JobCityKey = [NSString stringWithFormat:@"%@",region.PathCode];
            [self.navigationController popToViewController:vc animated:YES];
        }
        
        if ([vc isKindOfClass:[ResumeAddJobVC class]] || [vc isKindOfClass:[SchoolResumeAddJobVC class]]) {
            Region *region = self.viewModel.cities[indexPath.row];
            self.model.JobCity = region.RegionName;
            self.model.JobCityKey = [NSString stringWithFormat:@"%@",region.PathCode];
            [self.navigationController popToViewController:vc animated:YES];
        }

    }
    
}


@end
