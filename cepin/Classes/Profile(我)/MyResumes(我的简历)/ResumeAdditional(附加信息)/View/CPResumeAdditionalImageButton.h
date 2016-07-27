//
//  CPResumeAdditionalImageButton.h
//  cepin
//
//  Created by ceping on 16/2/18.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
#import "CPWResumeAdditionImageRetryButton.h"
@class CPResumeAdditionalImageButton;
@protocol CPResumeAdditionalImageButtonDelegate <NSObject>
@optional
- (void)resumeAdditionalImageButton:(CPResumeAdditionalImageButton *)resumeAdditionalImageButton retryButton:(CPWResumeAdditionImageRetryButton *)retryButton;
@end
@interface CPResumeAdditionalImageButton : UIButton
@property (nonatomic, weak) id<CPResumeAdditionalImageButtonDelegate>resumeAdditionalImageButtonDelegate;
@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) CPWResumeAdditionImageRetryButton *retryButton;
- (void)configWithAttachment:(NSDictionary *)attachmentModel;
- (void)configWithAttachment:(NSDictionary *)attachmentModel isChangeFrame:(BOOL)isChangeFrame;
- (void)configWithImage:(UIImage *)image imageName:(NSString *)imageName;
- (void)configError;
- (void)setPrograssWithTotalBytesWritten:(CGFloat)totalBytesWritten totalBytesExpectedToWrite:(CGFloat)totalBytesExpectedToWrite;
- (NSString *)getStorageImageName;
- (UIImage *)getPlaceholderImage;
@end
