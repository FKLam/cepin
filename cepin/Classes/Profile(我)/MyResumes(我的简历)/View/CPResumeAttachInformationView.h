//
//  CPResumeAttachInformationView.h
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
#import "CPResumeInformationButton.h"
#import "CPResumeMoreButton.h"
@class CPResumeAttachInformationView;
@protocol CPResumeAttachInformationViewDelegate <NSObject>
@optional
- (void)resumeAttachInformationView:(CPResumeAttachInformationView *)resumeAttachInformationView reviewImageButton:(UIButton *)reviewImageButton imageArray:(NSArray *)imageArray isImage:(BOOL)isImage originArray:(NSArray *)originArray;
@end
@interface CPResumeAttachInformationView : UIView
@property (nonatomic, weak) id<CPResumeAttachInformationViewDelegate> resumeAttachInformationViewDelegate;
- (void)configWithResume:(ResumeNameModel *)resumeModel;
@property (nonatomic, strong) CPResumeInformationButton *editResumeButton;
@property (nonatomic, strong) CPResumeMoreButton *addMoreButton;
@end
