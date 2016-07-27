//
//  ResumeCompanyIndustryCell.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResumeCompanyIndustryCell;
@protocol ResumeCompanyIndustryCellDelegate <NSObject>

-(void)selectedWith:(ResumeCompanyIndustryCell *)view;

@end

@interface ResumeCompanyIndustryCell : UIView
@property(nonatomic,strong)UILabel *jobName;
@property(nonatomic,strong)UIImageView *arrowImage;
@property(nonatomic,strong)UIButton *clickButton;
@property(nonatomic,strong)UILabel *labelSub;
@property(nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL open;//开 关
@property(nonatomic,strong)id<ResumeCompanyIndustryCellDelegate>delegate;
@end
