//
//  CPProfileMyResumesCell.h
//  cepin
//
//  Created by ceping on 16/1/6.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllResumeDataModel.h"
#import "CPProfileResumeButton.h"
#import "CPProfileResumeReviewButton.h"

@interface CPProfileMyResumesCell : UITableViewCell

@property (nonatomic, strong) CPProfileResumeReviewButton *resumeReviewButton;
@property (nonatomic, strong) UIButton *resumeSetDefualtButton;
@property (nonatomic, strong) CPProfileResumeButton *resumeCopyButton;
@property (nonatomic, strong) CPProfileResumeButton *resumeDeleteButton;
@property (nonatomic, strong) CPProfileResumeButton *resumeEditButton;
@property (nonatomic, strong) UIButton *resumeReviewLabel;

+ (instancetype)resumeCellWithTableView:(UITableView *)tableView;

- (void)setResumeModel:(AllResumeDataModel *)resumeModel indexPath:(NSIndexPath *)indexPath;
@end
