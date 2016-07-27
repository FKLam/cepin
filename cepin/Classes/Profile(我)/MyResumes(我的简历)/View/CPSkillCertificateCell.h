//
//  CPSkillCertificateCell.h
//  cepin
//
//  Created by ceping on 16/1/30.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@interface CPSkillCertificateCell : UITableViewCell
@property (nonatomic, strong) UIButton *editButton;
+ (instancetype)certificateCellWithTableView:(UITableView *)tableView;
- (void)configCellWithCertificate:(CredentialListDataModel *)certificate;
@end
