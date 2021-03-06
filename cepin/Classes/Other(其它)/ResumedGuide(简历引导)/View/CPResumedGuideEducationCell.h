//
//  CPResumedGuideEducationCell.h
//  cepin
//
//  Created by ceping on 16/1/19.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPTestEnsureArrowCell.h"
#import "ResumeNameModel.h"

@interface CPResumedGuideEducationCell : CPTestEnsureArrowCell
- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder educationData:(EducationListDateModel *)educationData;

- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder contentString:(NSString *)contentString;
@end
