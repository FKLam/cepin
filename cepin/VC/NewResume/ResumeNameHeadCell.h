//
//  ResumeNameHeadCell.h
//  cepin
//
//  Created by dujincai on 15/6/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@interface ResumeNameHeadCell : UITableViewCell
@property(nonatomic,strong)UIButton *headImage;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UIImageView *sexImage;
@property(nonatomic,strong)UILabel *phone;
@property(nonatomic,strong)UILabel *email;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UIImageView *arrawImage;
- (void)configModel:(ResumeNameModel*)model;
@end
