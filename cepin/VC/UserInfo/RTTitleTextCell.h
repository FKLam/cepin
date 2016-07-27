//
//  RTTitleTextCell.h
//  letsgo
//
//  Created by Ricky Tang on 14-8-5.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTTitleTextCell : UITableViewCell

@property(nonatomic,strong) UILabel *labelTitle;
@property(nonatomic,strong) UITextField *name;
@property(nonatomic,strong)UIButton *editButton;

@property (nonatomic, strong) UIView *lineView;

@end
