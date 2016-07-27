//
//  CPCompanyInformationFrame.m
//  cepin
//
//  Created by ceping on 15/12/3.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "CPCompanyInformationFrame.h"
#import "CompanyDetailModelDTO.h"
#import "TBTextUnit.h"

@implementation CPCompanyInformationFrame

#pragma mark - setter
- (void)setCompanyDetail:(CompanyDetailModelDTO *)companyDetail
{
    if ( _companyDetail == companyDetail )
        return;
    
    _companyDetail = companyDetail;

    CGFloat horizontal_marge = 20 * 4;
    
    CGFloat maxWidth = kScreenWidth - horizontal_marge - 40 / 3.0;
    
    // 企业名称
    CGFloat companyX = horizontal_marge;
    CGFloat companyY = 20.0;
    CGSize companySize = [companyDetail.CompanyName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[[RTAPPUIHelper shareInstance] companyInformationNameFont] } context:nil].size;
    CGFloat companyW = companySize.width;
    CGFloat companyH = companySize.height;
    if ( companyW > maxWidth )
    {
        NSInteger modeNum = companyW / maxWidth;
        
        if ( maxWidth * modeNum < companyW )
            modeNum += 1;
        
        companyW = maxWidth;
        companyH = companySize.height * modeNum;
    }
    _companNameFrame = CGRectMake(companyX, companyY, companyW, companyH);
    
    // 企业文化
    CGFloat companyIndustryX = horizontal_marge;
    CGFloat companyIndustryY = CGRectGetMaxY(_companNameFrame) + 8.0;
    CGSize companyIndustrySize = [companyDetail.Industry boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIndustryFont]} context:nil].size;
    CGFloat companyIndustryW = companyIndustrySize.width;
    CGFloat companyIndustryH = companyIndustrySize.height;
    if ( companyIndustryW > maxWidth )
    {
        NSInteger modeNum = companyIndustryW / maxWidth;
        if ( modeNum * maxWidth < companyIndustryW )
            modeNum += 1;
        companyIndustryW = maxWidth;
        companyIndustryH = companyIndustrySize.height * modeNum;
    }
    _companyIndustryFrame = CGRectMake(companyIndustryX, companyIndustryY, companyIndustryW, companyIndustryH);
    
    // 企业规模
    NSString *tempNatureStr = [TBTextUnit configWithCompany:companyDetail.CompanyNature data:companyDetail.CompanySize];
    CGFloat companyNatureX = horizontal_marge;
    CGFloat companyNatureY = CGRectGetMaxY(_companyIndustryFrame) + 8.0;
    CGSize companyNatrueSize = [tempNatureStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationNatureFont] } context:nil].size;
    CGFloat companyNatureW = companyNatrueSize.width;
    CGFloat companyNatureH = companyNatrueSize.height;
    if ( companyNatureW > maxWidth )
    {
        NSInteger modeNum = companyNatureW / maxWidth;
        if( modeNum * maxWidth < companyNatureW )
            modeNum += 1;
        companyNatureW = maxWidth;
        companyNatureH = companyNatrueSize.height * modeNum;
    }
    _companyNatureAndSizeFrame = CGRectMake(companyNatureX, companyNatureY, companyNatureW, companyNatureH);
    
    _totalHeight = CGRectGetMaxY(_companyNatureAndSizeFrame) + 20.0;
}

@end
