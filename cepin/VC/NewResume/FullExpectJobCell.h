//
//  FullExpectJobCell.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
#import "ResumeNameModel.h"
@interface FullExpectJobCell : BaseFullCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextView *expect;
@property(nonatomic,strong)UILabel *des;
@property(nonatomic,strong)UIView *baseView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
