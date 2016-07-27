//
//  CPResumeReviewReformer.h
//  cepin
//
//  Created by ceping on 16/2/4.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResumeNameModel.h"
@interface CPResumeReviewReformer : NSObject
+ (CGFloat)reviewExpectWorkHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewInformationHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewEducationAdditionalHeight:(EducationListDateModel *)education;
+ (CGFloat)reviewEducationHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewDescribeHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewStudyProveHeight:(WorkListDateModel *)study;
+ (CGFloat)reviewStudyProveCompanyHeight:(WorkListDateModel *)study;
+ (CGFloat)reviewStudyTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewStudyProveManCompanyMarge:(WorkListDateModel *)study;
+ (CGFloat)reviewStudyTypeHeight:(WorkListDateModel *)study resume:(ResumeNameModel *)resume;
+ (CGFloat)reviewProjectDutyHeight:(ProjectListDataModel *)project;
+ (CGFloat)reviewProjectDescribeHeight:(ProjectListDataModel *)project;
+ (CGFloat)reviewProjectLinkHeight:(ProjectListDataModel *)project;
+ (CGFloat)reviewProjectGainHeight:(ProjectListDataModel *)project;
+ (CGFloat)reviewProjectTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewPraciticeDescribeHeight:(PracticeListDataModel *)pracitice;
+ (CGFloat)reviewPraciticeTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewTrainContentHeight:(TrainingDataModel *)train;
+ (CGFloat)reviewTrainTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewSkillTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewSocailInforHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewSocailExpectWorkHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewWorkExperienceContentHeight:(WorkListDateModel *)work;
+ (CGFloat)reviewWorkExperienceTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewAttachmentInfoHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewAttachmentTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)reviewAttachmentInfoImageMarge:(ResumeNameModel *)resumeModel;
@end
