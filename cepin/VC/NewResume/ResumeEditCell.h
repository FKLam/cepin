//
//  ResumeEditCell.h
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPResumeTextField.h"

@interface ResumeEditCell : UITableViewCell

@property(nonatomic,strong)UILabel  *titleLabel;
@property(nonatomic,strong)CPResumeTextField *infoText;
@property(nonatomic,strong)UITableView *mparantView;

@property (nonatomic, strong) UIView *lineView;
//-(void)isNumberType:(UIView*)view;
@end
