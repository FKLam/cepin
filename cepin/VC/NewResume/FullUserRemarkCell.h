//
//  FullUserRemarkCell.h
//  cepin
//
//  Created by dujincai on 15/7/22.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
@interface FullUserRemarkCell : BaseFullCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextView *appendText;

- (void)changeAppendText:(NSString *)str;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
