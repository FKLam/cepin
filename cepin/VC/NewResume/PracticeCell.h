//
//  PracticeCell.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
@interface PracticeCell : BaseFullCell
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UITextView *projectDescribe;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
