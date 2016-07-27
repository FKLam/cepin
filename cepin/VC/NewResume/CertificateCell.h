//
//  CertificateCell.h
//  cepin
//
//  Created by dujincai on 15/5/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseFullCell.h"

@interface CertificateCell : BaseFullCell
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *name;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
