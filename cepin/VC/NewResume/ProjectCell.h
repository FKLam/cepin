//
//  ProjectCell.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
@interface ProjectCell : BaseFullCell
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *projecrName;
@property(nonatomic,strong)UILabel *position;
@property(nonatomic,strong)UILabel *projectDescribe;
@property (nonatomic, strong) UIView *separatorView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
