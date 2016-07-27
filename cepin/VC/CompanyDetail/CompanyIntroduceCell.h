//
//  CompanyIntroduceCell.h
//  cepin
//
//  Created by zhu on 14/12/7.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#define kDefaultCompanyIntroduceStringHeihgt 44.0
#define kDefaultCompanyOffsetY 10

#import "RTLabel.h"
#import "CompanyDetailModelDTO.h"
@interface CompanyIntroduceCell : UITableViewCell

@property(nonatomic,retain)UIView  *viewBackground;
@property(nonatomic,retain)UILabel *labelIntroduction;
@property(nonatomic,retain)FUIButton *buttonMore;
@property(nonatomic,strong)UILabel *introduction;


@property(nonatomic,assign)BOOL    isOpen;

+(CGFloat)computerCellHeihgt:(NSString*)str open:(BOOL)open;

-(void)configureWithBean:(CompanyDetailModelDTO *)bean;
@end
