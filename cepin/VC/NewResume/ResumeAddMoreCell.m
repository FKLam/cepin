//
//  ResumeAddMoreCell.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeAddMoreCell.h"

@implementation ResumeAddMoreCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, IS_IPHONE_5?8:10, IS_IPHONE_5?21:25, IS_IPHONE_5?21:25)];
        addImage.image = [UIImage imageNamed:@"ic_add-1"];

        [self addSubview:addImage];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(addImage.viewX + addImage.viewWidth + 10,IS_IPHONE_5?12:17, 150, IS_IPHONE_5?12:14)];
        label.text = @"还可以添加";
        label.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        label.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        [self addSubview:label];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
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
