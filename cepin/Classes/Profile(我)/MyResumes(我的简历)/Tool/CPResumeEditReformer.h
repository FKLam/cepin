//
//  CPResumeEditReformer.h
//  cepin
//
//  Created by ceping on 16/1/22.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResumeNameModel.h"
typedef NS_ENUM(NSInteger, CPResumeEditBlockType)
{
    CPResumeEditDefaultBlock = -1,
    CPResumeEdiInformationtBlock,
    CPResumeEditExpectWorkBlock,
    CPResumeEditWorkExperienceBlock,
    CPResumeEditEducationBlock,
    CPResumeEditProjectExperienceBlock,
    CPResumeEditSelfDescribeBlock,
    CPResumeEditAboutSkillBlock,
    CPResumeEditPracticeBlock,
    CPResumeEditTrainBlock,
    CPResumeEditAttachInforBlock
};
@interface CPResumeEditReformer : NSObject
+ (CPResumeEditBlockType)resumeEditBlock;
+ (void)saveResumeEditBlock:(CPResumeEditBlockType)resumeEditBlock;
+ (CGFloat)informationHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)expectWorkHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)workExperienceTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)workPositionHeight:(WorkListDateModel *)work resumeType:(NSNumber *)resumeType;
+ (CGFloat)workDescribeHeight:(WorkListDateModel *)work;
+ (CGFloat)educationTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)projectExperienceTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)projectDescribeHeight:(ProjectListDataModel *)work;
+ (CGFloat)majorDescribeHeight:(ProjectListDataModel *)work;
+ (CGFloat)selfDescribeTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)aboutSkillHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)credentialHeight:(CredentialListDataModel *)credential;
+ (CGFloat)skillHeight:(SkillDataModel *)skill;
+ (CGFloat)langageHeight:(LanguageDataModel *)langage;
+ (CGFloat)CETKeyValueHeigt;
+ (NSDictionary *)CETKeyValueDict:(ResumeNameModel *)resumeModel;
+ (CGFloat)practiceDescribeHeight:(PracticeListDataModel *)practice;
+ (CGFloat)practiceTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)trainDescribeHeight:(TrainingDataModel *)train;
+ (CGFloat)trainTotalHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)resumeEditAdditionHeight:(ResumeNameModel *)resumeModel;
+ (CGFloat)resumeEditAttachmentInfoImageMarge:(ResumeNameModel *)resumeModel;
@end
