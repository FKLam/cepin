//
//  JobDetailNewTitleCell.h
//  cepin
//
//  Created by zhu on 15/1/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//


#import "JobDetailModelDTO.h"
#import "CPJobInformationFrame.h"

@interface JobDetailNewTitleCell : UITableViewCell

@property(nonatomic,strong)UILabel *positionName;
@property(nonatomic,strong)UILabel *salary;
@property(nonatomic,strong)UILabel *companyName;
@property(nonatomic,strong)UILabel *informationLabel;
@property(nonatomic,strong)UILabel *time;

@property (nonatomic, strong) CPJobInformationFrame *informationFrame;

//
- (void)getModelWith:(JobDetailModelDTO*)model;
@end
