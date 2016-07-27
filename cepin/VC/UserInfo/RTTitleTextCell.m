//
//  RTTitleTextCell.m
//  letsgo
//
//  Created by Ricky Tang on 14-8-5.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "RTTitleTextCell.h"

@implementation RTTitleTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, self.viewHeight)];
        self.labelTitle.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        self.labelTitle.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelTitle];
        
        self.name = [[UITextField alloc]initWithFrame:CGRectMake(self.labelTitle.viewX + self.labelTitle.viewWidth, 0, 180, self.viewHeight)];
        self.name.textAlignment = NSTextAlignmentRight;
        self.name.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        self.name.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        self.name.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:self.name];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.contentView addSubview:line];
        _lineView = line;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@(1));
        }];
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editButton.frame = self.bounds;
        self.editButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.editButton];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect titleFrame = self.labelTitle.frame;
    CGSize titlSize = [self.labelTitle.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.viewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileBaseInformationRFont] } context:nil].size;
    titleFrame.size.width = titlSize.width;
    titleFrame.origin.x = 40 / 3.0;
    self.labelTitle.frame = titleFrame;
    
    CGFloat nameY = 0;
    CGFloat nameX = CGRectGetMaxX(self.labelTitle.frame) + 40 / 3.0;
    CGFloat nameW = self.viewWidth - 40 / 3.0 * 3 - titlSize.width;
    self.name.frame = CGRectMake(nameX, nameY, nameW, self.viewHeight);
    
}

@end
