//
//  StudentLeadersCell.h
//  cepin
//
//  Created by dujincai on 15/5/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseFullCell.h"

@interface StudentLeadersCell : BaseFullCell
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *level;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
