//
//  FullResumeModel.m
//  cepin
//
//  Created by dujincai on 15-4-21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullResumeModel.h"
//@property(nonatomic,strong)NSString<Optional> *Id;//	String	教育ID
//@property(nonatomic,strong)NSString<Optional> *ResumeId;//	String	对应简历id
//@property(nonatomic,strong)NSString<Optional> *StartDate;//	String	(不用)
//@property(nonatomic,strong)NSString<Optional> *StartDateFormat;//	String	教育开始时间
//@property(nonatomic,strong)NSString<Optional> *EndDate;//	String	教育结束时间
//@property(nonatomic,strong)NSString<Optional> *EndDateFormat;//	String	教育结束时间
//@property(nonatomic,strong)NSString<Optional> *School;//	String	学校
//@property(nonatomic,strong)NSString<Optional> *SchoolCode;//	String	学校code
//@property(nonatomic,strong)NSString<Optional> *Major;//	String	专业
//@property(nonatomic,strong)NSString<Optional> *MajorKey;//	String	专业key
//@property(nonatomic,strong)NSString<Optional> *Degree;//	String	学历
//@property(nonatomic,strong)NSString<Optional> *DegreeKey;//	String	学历key
//@property(nonatomic,strong)NSString<Optional> *Description;//	String	描述
//@property(nonatomic,strong)NSString<Optional> *Content;//	String
//@property(nonatomic,strong)NSString<Optional> *IsAbrot;//	String
//@property(nonatomic,strong)NSString<Optional> *SchoolLevel;//	String
@implementation FullResumeModel
+(FullResumeModel*)CreateWithEducation:(EducationListDataModel*)model
{
    FullResumeModel *data = [FullResumeModel new];
    data.StartTime = model.StartDateFormat;
    data.EndTime = model.EndDateFormat;
    data.name = model.School;
    data.major = model.Major;
    data.degree = model.Degree;
    
    return data;
}

@end
