//
//  EditCertificateVM.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "ResumeNameModel.h"
@interface EditCertificateVM : BaseRVMViewModel
@property(nonatomic,strong)id saveStateCode;
@property(nonatomic,strong)CredentialListDataModel *credData;
@property(nonatomic,strong)NSString *credId;
@property(nonatomic,strong)NSString *resumeId;
@property (nonatomic, strong) UIViewController *showMessageVC;
- (instancetype)initWithWork:(CredentialListDataModel*)model;
- (void)saveCred;
@end
