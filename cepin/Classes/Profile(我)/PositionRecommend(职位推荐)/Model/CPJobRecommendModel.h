//
//  CPJobRecommendModel.h
//  cepin
//
//  Created by dujincai on 16/3/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface CPJobRecommendModel : BaseBeanModel
@property(nonatomic,strong)NSString<Optional> *PositionId;//职位ID
@property(nonatomic,strong)NSNumber<Optional> *MatchRate;//匹配度百分
@property(nonatomic,strong)NSString<Optional> *CreateDate;//创建时间
@property(nonatomic,strong)NSString<Optional> *PositionName;//职位名
@property(nonatomic,strong)NSString<Optional> *EmployType;//工作类型
@property(nonatomic,strong)NSNumber<Optional> *City;//城市码表值
@property(nonatomic,strong)NSString<Optional> *Salary;//薪酬
@property(nonatomic,strong)NSString<Optional> *CustomerId;//企业ID
@property(nonatomic,strong)NSString<Optional> *CompanyName;//公司名
@property(nonatomic,strong)NSString<Optional> *Shortname;//公司简称
@property(nonatomic,strong)NSString<Optional> *CompanySize;//公司人数

@end
