//
//  AllResumeDataModel.h
//  cepin
//
//  Created by ceping on 15-3-16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface AllResumeDataModel : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *BarcodeContent;
@property(nonatomic,strong)NSString<Optional> *BarcodeUrl;
@property(nonatomic,strong)NSString<Optional> *ChineseName;
@property(nonatomic,strong)NSString<Optional> *City;
@property(nonatomic,strong)NSArray<Optional> *CityList;
@property(nonatomic,strong)NSString<Optional> *Degree;
@property(nonatomic,strong)NSString<Optional> *DegreeKey;
@property(nonatomic,strong)NSString<Optional> *Email;
@property(nonatomic,strong)NSString<Optional> *Function;
@property(nonatomic,strong)NSArray<Optional> *FunctionList;
@property(nonatomic,strong)NSNumber<Optional> *Gender;
@property(nonatomic,strong)NSString<Optional> *GraduateDate;
@property(nonatomic,strong)NSNumber<Optional> *HR;
@property(nonatomic,strong)NSString<Optional> *Major;
@property(nonatomic,strong)NSString<Optional> *MajorKey;
@property(nonatomic,strong)NSString<Optional> *Mobile;
@property(nonatomic,strong)NSString<Optional> *PhotoUrlPath;
@property(nonatomic,strong)NSString<Optional> *ResumeId;
@property(nonatomic,strong)NSString<Optional> *ResumeName;
@property(nonatomic,strong)NSString<Optional> *School;
@property(nonatomic,strong)NSString<Optional> *SchoolId;
@property(nonatomic,strong)NSNumber<Optional> *Status;
@property(nonatomic,strong)NSString<Optional> *UserRemark;
@property(nonatomic,strong)NSNumber<Optional> *Viewed;
@property(nonatomic,strong)NSNumber<Optional> *IsMicroResume;
@property(nonatomic,strong)NSNumber<Optional> *ResumeType;//(0社招，1校招)
@property(nonatomic,strong)NSNumber<Optional> *IsCompleteResume;//(是否可投)



@end
