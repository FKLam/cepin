//
//  UserSignatureCell.m
//  cepin
//
//  Created by ceping on 15-1-12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "UserSignatureCell.h"

@implementation UserSignatureCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.lineView];
        self.lineView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
            make.height.equalTo(@(0.5));
        }];
        
        self.lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
        self.lableTitle.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self addSubview:self.lableTitle];
        
        self.textFieldName = [[UITextField alloc]initWithFrame:CGRectMake(20, self.lableTitle.viewY + self.lableTitle.viewHeight, 300, 30)];
        self.textFieldName.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        
        [self addSubview:self.textFieldName];
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editButton.frame = CGRectMake(20, self.lableTitle.viewY + self.lableTitle.viewHeight, 300, 30);
        self.editButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.editButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
