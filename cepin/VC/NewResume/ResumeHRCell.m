//
//  ResumeHRCell.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeHRCell.h"

@implementation ResumeHRCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self addSubview:line];
    
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.left.equalTo(self.mas_left).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.right.equalTo(self.mas_right);
        }];
        
        self.HRimage  = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
        [self.HRimage setBackgroundImage:[UIImage imageNamed:@"ic_radio_null"] forState:UIControlStateNormal];
        [self addSubview:self.HRimage];
        
        UILabel *HRlabel = [[UILabel alloc]initWithFrame:CGRectMake(self.HRimage.viewX + self.HRimage.viewWidth + 10, 0, 150, 44)];
        HRlabel.text = @"仅HR可见";
        [self addSubview:HRlabel];
        
        
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
