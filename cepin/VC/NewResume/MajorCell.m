//
//  MajorCell.m
//  cepin
//
//  Created by dujincai on 15-4-23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "MajorCell.h"
#import "ResumeNameModel.h"
#import "NSString+Extension.h"

@implementation MajorCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        int imageHight = 21.0;
//        int hight = IS_IPHONE_5?11:12.6;
        UIImageView *imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake( 40 / 3.0, 40 / 3.0 - (imageHight - [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize) / 2.0, imageHight, imageHight)];
        imageLogo.image = [UIImage imageNamed:@"ic_jl"];
        [self addSubview:imageLogo];
        
        
        self.name = [[UILabel alloc] init];
        self.name.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.name.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.name.numberOfLines = 0;
        [self.contentView addSubview:self.name];
        
        self.level = [[UILabel alloc] init];
        self.level.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.level.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.level];
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 0.8);
        [self.contentView addSubview:separatorView];
        self.baseSeparatorView = separatorView;
    }
    return self;
}

-(void)getModel:(id)model
{
    SkillDataModel *skillModel = model;
    
    NSString *time = [NSString stringWithFormat:@"%@  |  %@", skillModel.Name, skillModel.MasteryLevel];
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  专业技能";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    self.name.attributedText = [timeAttStr copy];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat tempH = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize;
    
    CGFloat maxMarge = self.viewWidth - 40 - 40 / 3.0;
    CGSize nameSize = [NSString caculateAttTextSize:self.name.attributedText andWith:maxMarge];
    self.name.frame = CGRectMake(40.0, 40 / 3.0, nameSize.width, tempH);
    
    self.baseSeparatorView.frame = CGRectMake(self.name.viewX, self.viewHeight - 1.0, kScreenWidth - self.name.viewX, 1 / 2.0);
}

@end
