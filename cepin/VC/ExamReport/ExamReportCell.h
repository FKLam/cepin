//
//  ExamReportCell.h
//  cepin
//
//  Created by dujincai on 15/6/9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicExamModelDTO.h"
#import "TKRoundedView.h"
@interface ExamReportCell : UITableViewCell

@property(nonatomic,retain)TKRoundedView *roundView;
@property(nonatomic,strong)UIImageView *imageLogo;
@property(nonatomic,strong)UILabel *lableTitle;
@property(nonatomic,strong)UILabel *ReportButton;
@property(nonatomic,strong)UILabel *lableTime;
@property(nonatomic,assign)int hight;

- (void)computyWith:(DynamicExamModelDTO *)model;
+(int)computyHith:(UIImage *)image;
@end
