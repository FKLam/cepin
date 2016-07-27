//
//  CPResumeExpectWorkView.h
//  cepin
//
//  Created by ceping on 16/1/20.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
#import "CPResumeInformationButton.h"
#import "CPResumeMoreButton.h"

@interface CPResumeExpectWorkView : UIView
- (void)configWithResume:(ResumeNameModel *)resume;
@property (nonatomic, strong) CPResumeInformationButton *editResumeButton;
@property (nonatomic, strong) CPResumeMoreButton *addMoreButton;
@end
