//
//  BaseCustomLineCell.m
//  cepin
//
//  Created by zhu on 14/12/14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseCustomLineCell.h"

@implementation BaseCustomLineCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.equalTo(self.contentView.mas_left);
            maker.right.equalTo(self.contentView.mas_right);
            maker.bottom.equalTo(self.contentView.mas_bottom);
            maker.height.equalTo(@(0.5));
        }];
        [self.lineView setBackgroundColor:[[RTAPPUIHelper shareInstance] lineColor]];
    }
    return self;
}

@end
