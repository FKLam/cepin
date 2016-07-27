//
//  CompanyDetailHeadCell.h
//  cepin
//
//  Created by zhu on 14/12/21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CompanyDetailModelDTO.h"
@class CPCompanyInformationFrame;

@interface CompanyDetailHeadCell : UITableViewCell

@property(nonatomic,retain)UIImageView   *imageLogo;
@property(nonatomic,retain)UILabel       *companyName;
@property(nonatomic,strong)UILabel       *industry;
@property(nonatomic,retain)UIView        *lineView;
@property(nonatomic,strong)UILabel       *companyNatureAndSize;
@property(nonatomic,strong)UIButton     *addressButton;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIImageView *addressImage;
@property(nonatomic,strong)UIView *addressView;

@property (nonatomic, strong) CPCompanyInformationFrame *compaynInformationFrame;

//+(int)computerCellHeight:(NSString*)str;
-(void)configureWithBean:(CompanyDetailModelDTO *)bean;

@end
