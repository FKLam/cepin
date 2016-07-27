//
//  CPResumeEducationReformer.h
//  cepin
//
//  Created by ceping on 16/3/7.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResumeNameModel.h"
@interface CPResumeEducationReformer : NSObject
+ (NSArray *)searchSchoolWithMatchString:(NSString *)matchString;
+ (NSArray *)searchMajorWithMatchString:(NSString *)matchString;
+ (CGFloat)educationListRowHeightWithEducationModel:(EducationListDateModel *)educationModel;
@end
