//
//  CompanyCell.h
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveCompanyModel.h"

@interface CompanyCell : UITableViewCell
@property(nonatomic,strong) UIImageView *imageLogo;
@property(nonatomic,strong) UILabel *labelTitle;
@property(nonatomic,strong) UILabel *labelDetail;
@property(nonatomic,strong)UIButton *buttonDelete;
@property(nonatomic,assign)BOOL isChoice;
@property(nonatomic,strong)UIImageView *deleImage;

@property (nonatomic, strong) UIView *lineView;
-(void)setChoice:(BOOL)isChoice;

-(void)configWithBean:(SaveCompanyModel*)bean;


@end
