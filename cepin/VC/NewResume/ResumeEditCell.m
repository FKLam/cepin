//
//  ResumeEditCell.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeEditCell.h"

@interface ResumeEditCell ()

@end

@implementation ResumeEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, IS_IPHONE_5?80:85, 44)];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformatonFont];
        [self.contentView addSubview:self.titleLabel];
        
        self.infoText = [[CPResumeTextField alloc]init];
        self.infoText.textAlignment = NSTextAlignmentRight;
        self.infoText.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.infoText.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.infoText.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:self.infoText];
        [self.infoText setValue:RGBCOLOR(100, 201, 194) forKeyPath:@"_placeholderLabel.textColor"];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self.contentView addSubview:line];
        _lineView = line;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(100));
            make.height.equalTo(self.mas_height);
        }];
        [self.infoText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.right.equalTo(self.mas_right).offset(-20);
            make.centerY.equalTo(self.mas_centerY);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.bottom.equalTo(self.mas_bottom).offset(-1);
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
