//
//  LanguageCell.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
@interface LanguageCell : BaseFullCell
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *speak;
@property(nonatomic,strong)UILabel *write;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
