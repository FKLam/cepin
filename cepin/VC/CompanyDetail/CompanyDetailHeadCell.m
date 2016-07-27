//
//  CompanyDetailHeadCell.m
//  cepin
//
//  Created by zhu on 14/12/21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CompanyDetailHeadCell.h"
#import "TBTextUnit.h"
#import "CPCompanyInformationFrame.h"
#import "CPCommon.h"

@implementation CompanyDetailHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];

        self.imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 56, 56)];
        self.imageLogo.backgroundColor = [UIColor clearColor];
        self.imageLogo.layer.cornerRadius = 56 / 2.0;
        self.imageLogo.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageLogo];
        
        self.companyName = [[UILabel alloc]initWithFrame:CGRectMake(self.imageLogo.viewX + self.imageLogo.viewWidth + 10, 0, 250, 30)];
        self.companyName.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.companyName.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
        self.companyName.numberOfLines = 0;
        [self.contentView addSubview:self.companyName];
        
        self.industry = [[UILabel alloc]initWithFrame:CGRectMake(self.companyName.viewX, self.companyName.viewHeight + self.companyName.viewY, 250, 30)];
        self.industry.textColor = CPColor(0x9d, 0x9d, 0x9d, 1.0);
        self.industry.font = [[RTAPPUIHelper shareInstance] companyInformationIndustryFont];
        self.industry.numberOfLines = 0;
        [self.contentView addSubview:self.industry];
        
        self.companyNatureAndSize = [[UILabel alloc]initWithFrame:CGRectMake(self.industry.viewX, self.industry.viewY + self.industry.viewHeight - 2.0, 250, 30)];
        self.companyNatureAndSize.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.companyNatureAndSize.font = [[RTAPPUIHelper shareInstance] companyInformationNatureFont];
        self.companyNatureAndSize.numberOfLines = 0;
        [self.contentView addSubview:self.companyNatureAndSize];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake( 40 / 3.0, self.companyNatureAndSize.viewHeight + self.companyNatureAndSize.viewY,kScreenWidth - 40 / 3.0, 1)];
        self.lineView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.companyName.frame = self.compaynInformationFrame.companNameFrame;
//    
//    self.industry.frame = self.compaynInformationFrame.companyIndustryFrame;
//    
//    self.companyNatureAndSize.frame = self.compaynInformationFrame.companyNatureAndSizeFrame;
    
    CGRect lineFrame = self.lineView.frame;
    lineFrame.origin.y = self.viewHeight - 1;
    self.lineView.frame = lineFrame;
}
-(void)configureWithBean:(CompanyDetailModelDTO *)bean
{
    [self.imageLogo sd_setImageWithURL:[NSURL URLWithString:bean.Logo] placeholderImage:[UIImage imageNamed:@"tb_default_logo"]];
    self.companyName.text = bean.CompanyName;
    self.industry.text = bean.Industry;
    self.companyNatureAndSize.text = [TBTextUnit configWithCompany:bean.CompanyNature data:bean.CompanySize];

}
#pragma mark - setter
- (void)setCompaynInformationFrame:(CPCompanyInformationFrame *)compaynInformationFrame
{
    if ( _compaynInformationFrame == compaynInformationFrame )
        return;
    
    _compaynInformationFrame = compaynInformationFrame;
}
@end
