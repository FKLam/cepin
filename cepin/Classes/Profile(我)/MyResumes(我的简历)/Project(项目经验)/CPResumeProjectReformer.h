//
//  CPResumeProjectReformer.h
//  cepin
//
//  Created by ceping on 16/1/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResumeNameModel.h"
@interface CPResumeProjectReformer : NSObject
+ (CGFloat)projectHeightWith:(ProjectListDataModel *)projectData;
+ (CGFloat)dutyHeightWithProject:(ProjectListDataModel *)projectModel;
+ (CGFloat)projectDescribeWithProject:(ProjectListDataModel *)projectModel;
@end
