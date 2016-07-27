//
//  CPResumeReviewAttachInforView.h
//  cepin
//
//  Created by ceping on 16/1/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class CPResumeReviewAttachInforView;
@protocol CPReviewAttachInformationViewDelegate <NSObject>
@optional
- (void)reviewAttachInformationView:(CPResumeReviewAttachInforView *)reviewAttachInformationView reviewImageButton:(UIButton *)reviewImageButton imageArray:(NSArray *)imageArray isImage:(BOOL)isImage originArray:(NSArray *)originArray;
@end
@interface CPResumeReviewAttachInforView : UIView
@property (nonatomic, weak) id<CPReviewAttachInformationViewDelegate> reviewAttachInformationViewDelegate;
- (void)configWithResume:(ResumeNameModel *)resumeModel;
@end
