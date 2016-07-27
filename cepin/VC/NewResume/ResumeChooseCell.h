//
//  ResumeChooseCell.h
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumeChooseCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *chooseImage;
@property(nonatomic,readwrite)BOOL isSelect;
- (void)showSeparatorLine:(BOOL)isShowAll;
@end
