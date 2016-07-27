//
//  AddressPresentCell.m
//  cepin
//
//  Created by dujincai on 15/6/1.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddressPresentCell.h"

@implementation AddressPresentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 80, 30)];
        label.text = @"当前城市:";
        label.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        label.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        [self addSubview:label];
        
        self.presentCity = [[UILabel alloc]initWithFrame:CGRectMake(label.viewX + label.viewWidth, label.viewY, 150, 30)];
        self.presentCity.textColor = [[RTAPPUIHelper shareInstance] labelColorBlue];
        self.presentCity.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        [self addSubview:self.presentCity];
        
        self.tickImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.viewWidth - 20 - (imagehight), (self.viewHeight - (imagehight))/2, imagehight, imagehight)];
        self.tickImage.image = [UIImage imageNamed:@"ic_tick"];
        self.tickImage.hidden = YES;
        [self addSubview:self.tickImage];
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
