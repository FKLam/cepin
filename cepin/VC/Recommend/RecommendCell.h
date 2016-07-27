//
//  RecommendCell.h
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobSearchModel.h"
#import "CompanyDetailModelDTO.h"

@interface RecommendCell : UITableViewCell
@property(nonatomic,strong)UILabel *position;//职位
@property(nonatomic,strong)UILabel *salary;//工资
@property(nonatomic,strong)UILabel *company;//公司
@property(nonatomic,strong)UILabel *address;//地址
@property(nonatomic,strong)UILabel *experience;//经验
@property(nonatomic,strong)UILabel *xueli;//学历
@property(nonatomic,strong)UILabel *time;//发布时间
@property(nonatomic,strong)UIImageView *topImage;//置顶
@property(nonatomic,strong)UIImageView *resumeTypeImage;//简历类型图标
@property(nonatomic,strong)UIImageView *locationImage;//地点图标
@property(nonatomic,strong)UIImageView *experienceImage;//经验图标
@property(nonatomic,strong)UIImageView *xueliImage;//学历图标
@property(nonatomic,strong)UIView *WelfareView;//职位诱惑区域
@property(nonatomic,assign)BOOL isTop;
@property(nonatomic,assign)BOOL isSchool;
@property(nonatomic,assign)BOOL hasXueli;
@property(nonatomic,assign)BOOL hasExperience;
@property(nonatomic,readwrite)BOOL isChecked;
@property(nonatomic,strong)NSArray *tagArray;//职位诱惑

- (void)configureModel:(JobSearchModel*)model;
- (void)configureCompanyPositionModel:(CompanyPositionModel *)model;
/**
 *  根据tableView创建recommendCell
 *
 *  @param tableView 显示cell的tableView容器
 */
+ (instancetype)recommendCellWithTableView:(UITableView *)tableView;
@end
