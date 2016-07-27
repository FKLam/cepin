//
//  FullAppendCell.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
@interface FullAppendCell : BaseFullCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *appendText;

- (void)changeAppendText:(NSString *)str;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
