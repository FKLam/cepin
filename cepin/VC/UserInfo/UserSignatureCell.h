//
//  UserSignatureCell.h
//  cepin
//
//  Created by ceping on 15-1-12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SyTextView.h"

@interface UserSignatureCell : UITableViewCell

@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong) UITextField *textFieldName;
@property(nonatomic,strong) UILabel    *lableTitle;
@property(nonatomic,strong)UIButton *editButton;
@end
