//
//  CertificateNameVC.h
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ResumeNameModel.h"
@interface CertificateNameVC : BaseTableViewController
@property(nonatomic,strong)CredentialListDataModel *model;
- (instancetype)initWithEduModel:(CredentialListDataModel*)model;
@end
