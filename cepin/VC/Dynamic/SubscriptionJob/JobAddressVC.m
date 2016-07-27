//
//  JobAddressVC.m
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobAddressVC.h"
#import "JobAddressVM.h"
#import "RegionDTO.h"
#import "ChooseCell.h"
#import "TBTextUnit.h"
#import "JobAddressSecondVC.h"
#import "AddressPresentCell.h"
#import "OtherAddressCell.h"
@interface JobAddressVC ()
@property(nonatomic,strong)JobAddressVM *viewModel;
@end

@implementation JobAddressVC
- (instancetype)initWithJobModel:(SubscriptionJobModel *)model
{
    self = [super init];
    if (self) {
//        NSMutableArray *a = [Region hotRegions];
        self.viewModel = [[JobAddressVM alloc]initWithJobModel:model];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作地点";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDataScource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.allAddress.count + 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AddressPresentCell *Cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressPresentCell class ])];
        if (!Cell)
        {
            Cell = [[AddressPresentCell alloc] initWithCellIdentifier:NSStringFromClass([AddressPresentCell class])];
        }
        
        Cell.presentCity.text = self.viewModel.GPSCity;
        BOOL isSelected = NO;
        for (Region *item in self.viewModel.selectedCity) {
            if ([item.RegionName isEqualToString:self.viewModel.GPSCity]) {
                isSelected = YES;
                break;
            }
        }
        Cell.tickImage.hidden = !isSelected;
        
        return Cell;
    }
//    else if(indexPath.row == 1)
//    {
//        static NSString *cellId = @"cellId";
//        OtherAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell)
//        {
//            cell = [[OtherAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        cell.otherLabel.text = @"其它城市";
//       
//        return cell;
//    }
    else
    {
        ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseCell class])];
        if(cell==nil)
        {
            cell=[[ChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ChooseCell class])];
        }
        if (indexPath.row == 1) {
            cell.labelTitle.text = @"全国";
            
            cell.labelSub.hidden = YES;
            cell.chooseType = ChooseSelectType;
            
            if ([self.model.address isEqualToString:@""] || !self.model.address) {
                cell.isSelected = YES;
            }else
            {
                cell.isSelected = NO;
            }
            return cell;
        }else if (indexPath.row == 2) {
            cell.chooseType = ChooseNextType;
            cell.labelTitle.text = @"热门城市";
            return cell;
        }else{
            cell.chooseType = ChooseNextType;
            Region *region = self.viewModel.allAddress[indexPath.row - 3];
            
            [cell configureLableTitleText:region.RegionName];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    return nil;
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (!self.viewModel.GPSCity || [self.viewModel.GPSCity isEqualToString:@""]) {
            return;
        }else
        {
            self.model.address = self.viewModel.GPSCity;
            Region *item = [Region searchAddressWithAddressString:self.viewModel.GPSCity];
            self.model.addresskey = [NSString stringWithFormat:@"%@",item.PathCode];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if (indexPath.row == 1)
    {
        self.model.address = @"";
        self.model.addresskey = @"";
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(indexPath.row == 2){
        
        JobAddressSecondVC *vc = [[JobAddressSecondVC alloc]initWithCities:self.viewModel.hotAddress selectedCity:self.viewModel.selectedCity model:self.model];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        Region *region = self.viewModel.allAddress[indexPath.row - 3];
        NSMutableArray *cities = [[NSMutableArray alloc]init];
        [cities addObjectsFromArray:[Region citiesWithCodeAndNotHot:region.PathCode]];
        if (cities.count > 0) {
            cities = cities;
        }else
        {
            [cities addObject:region];
        }
        JobAddressSecondVC *vc = [[JobAddressSecondVC alloc] initWithCities:cities selectedCity:self.viewModel.selectedCity model:self.model];
        vc.title = region.RegionName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return IS_IPHONE_5?40:48;
}

@end
