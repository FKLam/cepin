//
//  TheCompanyJobModel.h
//  cepin
//
//  Created by zhu on 14/12/21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface TheCompanyJobModel : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *PositionName;//	String	职位名称
@property(nonatomic,strong)NSString<Optional> *PositionId;//	String	职位Id
@property(nonatomic,strong)NSString<Optional> *PositionNature;//	String	职位性质（全职，兼职，实习）
@property(nonatomic,strong)NSString<Optional> *City;//	String	工作地点
@property(nonatomic,strong)NSString<Optional> *Salary;//	String	薪酬
@property(nonatomic,strong)NSString<Optional> *CompanyName;//	String	公司名称
@property(nonatomic,strong)NSString<Optional> *CustomerId;//	String	公司Id
@property(nonatomic,strong)NSString<Optional> *Logo;//	String	公司logo
@property(nonatomic,strong)NSString<Optional> *PublishDate;//	String	发布时间
@property(nonatomic,strong)NSNumber<Optional> *IsCollection;//	Int	是否收藏简历
@property(nonatomic,strong)NSNumber<Optional> *IsDeliveried;//	int	是否已经投递简历
@property(nonatomic,strong)NSNumber<Optional> *IsTop;
@property(nonatomic,strong)NSString<Optional> *CollectDate;
@property(nonatomic,strong)NSNumber<Optional> *PositionType;//简历类型

@end

