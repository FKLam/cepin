//
//  FullExamReportCell.m
//  cepin
//
//  Created by dujincai on 15/7/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullExamReportCell.h"

@implementation FullExamReportCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 102 / 3.0)];
        baseView.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:baseView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (baseView.viewHeight - hight)/2, self.viewWidth - 40, hight)];
//        self.titleLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
//        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance]labelColorGreen];
//        [baseView addSubview:self.titleLabel];
        
//        self.appendText = [[UILabel alloc]init];
//        self.appendText.font = [[RTAPPUIHelper shareInstance]titleFont];
//        self.appendText.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
//        self.appendText.userInteractionEnabled = NO;
//        [self addSubview:self.appendText];
//        [self.appendText mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.titleLabel.mas_left);
//            make.top.equalTo(baseView.mas_bottom).offset(10);
//            make.bottom.equalTo(self.mas_bottom).offset(-15);
//            make.right.equalTo(self.mas_right).offset(-20);
//        }];
        
        self.readExam = [UIButton buttonWithType:UIButtonTypeCustom];
        self.readExam.titleLabel.font = [[RTAPPUIHelper shareInstance]titleFont];
        self.readExam.titleLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.readExam.backgroundColor = [UIColor colorWithHexString:@"fca05f"];
        [self.readExam setTitle:@"极速测评报告" forState:UIControlStateNormal];
        [self.contentView addSubview:self.readExam];
        [self.readExam mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
          
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
