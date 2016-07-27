//
//  LanguageCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "LanguageCell.h"
#import "ResumeNameModel.h"
#import "NSString+Extension.h"

@implementation LanguageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        int imageHight = 21.0;
        int hight = IS_IPHONE_5?11:12.6;
        UIImageView *imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake( 40 / 3.0,  40 / 3.0 - (imageHight - [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize) / 2.0, imageHight, imageHight)];
        imageLogo.image = [UIImage imageNamed:@"ic_jl"];
        [self.contentView addSubview:imageLogo];
        
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(imageLogo.viewWidth + imageLogo.viewX + 10, 0, self.viewWidth - 40, hight)];
        self.name.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.name.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.name.numberOfLines = 0;
        [self.contentView addSubview:self.name];
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 0.8);
        [self.contentView addSubview:separatorView];
        self.baseSeparatorView = separatorView;
    }
    return self;
}

-(void)getModel:(id)model
{
    LanguageDataModel *lanModel = model;
    self.name.text = lanModel.Name;
    self.speak.text = lanModel.Speaking;
    self.write.text = lanModel.Writing;
    
    NSMutableString *lanMutStr = [NSMutableString stringWithString:lanModel.Name];
    NSString *tempStr = nil;
    if ( lanModel.Speaking.length > 0 && lanModel.Writing.length > 0)
    {
        tempStr = [NSString stringWithFormat:@"（听说%@、读写%@）", lanModel.Speaking, lanModel.Writing];
    }
    else if ( lanModel.Speaking.length > 0 )
    {
        tempStr = [NSString stringWithFormat:@"（听说%@）", lanModel.Speaking];
    }
    else if ( lanModel.Writing.length > 0 )
    {
        tempStr = [NSString stringWithFormat:@"（读写%@）", lanModel.Writing];
    }
    
    if ( tempStr )
        [lanMutStr appendString:tempStr];
    
    NSMutableAttributedString *nameAttStr = [[NSMutableAttributedString alloc] initWithString:lanMutStr attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *append = @"  |  其它语言能力";
    NSAttributedString *appendAttStr = [[NSAttributedString alloc] initWithString:append attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [nameAttStr appendAttributedString:appendAttStr];
    
    self.name.attributedText = [nameAttStr copy];
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
    
    CGFloat maxMarge = self.viewWidth - 40 / 3.0 - 40.0;
    CGSize nameSize = [NSString caculateAttTextSize:self.name.attributedText andWith:maxMarge];
    
    if ( nameSize.height > tempH * 1.4 )
        tempH = nameSize.height;
    
    self.name.frame = CGRectMake(40.0, 40 / 3.0, nameSize.width, tempH);
    
    self.baseSeparatorView.frame = CGRectMake(self.name.viewX, self.viewHeight - 1.0, kScreenWidth - self.name.viewX, 1 / 2.0);
}

@end
