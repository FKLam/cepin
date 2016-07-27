//
//  CPResumeAboutSkillView.h
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
#import "CPResumeInformationButton.h"
#import "CPResumeMoreButton.h"
@interface CPResumeAboutSkillView : UIView
- (void)configWithResume:(ResumeNameModel *)resumeModel;
@property (nonatomic, strong) CPResumeInformationButton *editResumeButton;
@property (nonatomic, strong) CPResumeMoreButton *addMoreButton;
@end
