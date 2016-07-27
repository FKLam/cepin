//
//  AddOtherInfomationVM.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface AddOtherInfomationVM : BaseRVMViewModel
@property(nonatomic,strong) id updateImageStateCode;
@property(nonatomic,strong) id deleteAttachmentStateCode;
@property(nonatomic,strong) ResumeNameModel *resumeModel;
@property(nonatomic,strong) NSString *resumeId;
@property (nonatomic, strong) NSMutableArray *attachmentArrayM;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithResumeModel:(ResumeNameModel*)model;
- (void)uploadAdditionalImageWithImage:(UIImage *)image imageName:(NSString *)imageName;
- (void)saveInfo;
- (void)deleteAttachment:(NSNumber *)attachmentID;
@end
