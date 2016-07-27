//
//  DynamicExamCell.h
//  cepin
//
//  Created by ceping on 14-12-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RTLabel.h"
#import "TKRoundedView.h"
#import "DynamicExamModelDTO.h"
@interface DynamicExamCell : UITableViewCell

@property(nonatomic,retain)UILabel *lableTime;
@property(nonatomic,retain)TKRoundedView *roundView;
@property(nonatomic,retain)UIImageView   *imageLogo;
@property(nonatomic,retain)UILabel *lableTitle;
@property(nonatomic,retain)UIButton *buttonShare;
@property(nonatomic,retain)UILabel  *lableDetail;
@property(nonatomic,assign)int hight;
@property(nonatomic,strong)UIView *line;
-(void)computyWith:(DynamicExamModelDTO*)model;

+(int)computyHith:(UIImage*)image;
@end
