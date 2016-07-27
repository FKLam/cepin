//
//  CPCompanyDetailReformer.h
//  cepin
//
//  Created by ceping on 16/1/27.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPCompanyDetailReformer : NSObject
+ (CGFloat)caculateTextHeightWtihText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth;
+ (CGFloat)companyInforHeightWithCompanyData:(NSDictionary *)companyData;
+ (CGFloat)companyWelfareHeightWithCompanyData:(NSDictionary *)companyData;
+ (CGFloat)companyIntroduceHeightWithCampanyData:(NSDictionary *)companyData;
+ (CGFloat)companyPositionHeightWithCampanyData:(NSDictionary *)companyData offset:(NSInteger)offset;
+ (NSArray *)positionWithCompanyData:(NSDictionary *)companyData toClass:(Class)toClass;
+ (NSArray *)welfareWithCompanyData:(NSDictionary *)companyData;
+ (CGFloat)companyDescriptViewHeightWithText:(NSDictionary *)companyData;
+ (CGFloat)companyIntroduceDescriptHeightWithCampanyData:(NSDictionary *)companyData;
+ (CGFloat)companyIntroduceHeightWithCampanyData:(NSDictionary *)companyData isSelected:(BOOL)isSelecectd;
@end
