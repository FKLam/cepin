//
//  JobFunctionFilterCell.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobFunctionFilterCell.h"

@implementation JobFunctionFilterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [[RTAPPUIHelper shareInstance]whiteColor];
        self.edImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, imagehight, imagehight)];
        self.edImage.image = [UIImage imageNamed:@"ic_selected"];
        [self addSubview:self.edImage];
        
        self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.edImage.viewX + self.edImage.viewWidth, 12, 100, IS_IPHONE_5?12:14)];
        self.countLabel.font = [[RTAPPUIHelper shareInstance]titleFont];
        self.countLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [self addSubview:self.countLabel];
        
        self.tagListView = [[AOTagList alloc]init];
        self.tagListView.hidden = YES;
        [self addSubview:self.tagListView];
        [self.tagListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.countLabel.mas_bottom).offset(10);
            make.height.equalTo(@(60));
        }];
        
        self.clickButton = [UIButton buttonWithType: UIButtonTypeCustom];
        self.clickButton.backgroundColor = [UIColor clearColor];
        self.clickButton.frame = CGRectMake(kScreenWidth - 70, 0, 70, 30);
//        [self.clickButton setBackgroundImage:[UIImage imageNamed:@"ic_down"] forState:UIControlStateNormal];
        [self addSubview:self.clickButton];
        
        self.clickImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20 - (imagehight), self.countLabel.viewY, imagehight, imagehight)];
        self.clickImage.image = [UIImage imageNamed:@"ic_down"];
        [self addSubview:self.clickImage];
        int hight = IS_IPHONE_5?18:21;
        UIView *shade = [[UIView alloc]init];
        shade.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
        [self addSubview:shade];
        [shade mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(hight));
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
