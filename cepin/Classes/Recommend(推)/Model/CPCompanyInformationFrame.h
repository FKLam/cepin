//
//  CPCompanyInformationFrame.h
//  cepin
//
//  Created by ceping on 15/12/3.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CompanyDetailModelDTO;

@interface CPCompanyInformationFrame : NSObject
/** 企业详情数据模型 */
@property (nonatomic, strong) CompanyDetailModelDTO *companyDetail;
/** 企业名字frame */
@property (nonatomic, assign) CGRect companNameFrame;
/** 产业frame */
@property (nonatomic, assign) CGRect companyIndustryFrame;
/** 企业规模 */
@property (nonatomic, assign) CGRect companyNatureAndSizeFrame;
/** 企业详情展示在cell中的整体高度 */
@property (nonatomic, assign) CGFloat totalHeight;

@end
