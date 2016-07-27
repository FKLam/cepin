//
//  AboutViewCell.m
//  cepin
//
//  Created by dujincai on 15/5/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AboutViewCell.h"

@implementation AboutViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
        [self addSubview:self.nameLabel];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
