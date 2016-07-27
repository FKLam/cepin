//
//  JobFunctionFilterCell.h
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOTag.h"
@interface JobFunctionFilterCell : UITableViewCell
@property(nonatomic,strong) AOTagList *tagListView;
@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) UIImageView *edImage;
@property(nonatomic,strong) UIButton *clickButton;
@property(nonatomic,strong)UIImageView *clickImage;
@end
