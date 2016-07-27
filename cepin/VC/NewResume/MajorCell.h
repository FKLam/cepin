//
//  MajorCell.h
//  cepin
//
//  Created by dujincai on 15-4-23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
@interface MajorCell : BaseFullCell
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *level;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
