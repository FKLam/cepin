//
//  FullResumeModel.h
//  cepin
//
//  Created by dujincai on 15-4-21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BannerModel.h"
#import "FullResumeDataModel.h"
@interface FullResumeModel : BannerModel
@property(nonatomic,retain)NSString *StartTime;
@property(nonatomic,retain)NSString *EndTime;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *major; //专业
@property(nonatomic,retain)NSString *degree;//学历
//@property(nonatomic,retain)NSString *EndTime;


+(FullResumeModel*)CreateWithEducation:(EducationListDataModel*)model;
@end
