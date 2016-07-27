//
//  DynamicSystemNewCell.h
//  cepin
//
//  Created by ceping on 14-12-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TKRoundedView.h"

@interface DynamicSystemNewCell : UITableViewCell

@property(nonatomic,retain)UILabel *lableTime;
@property(nonatomic,retain)TKRoundedView *roundView;
@property(nonatomic,retain)UILabel *lableTitle;
@property(nonatomic,strong)UILabel *subLabel;

@property (nonatomic, strong) UIView *lineView;
@end
