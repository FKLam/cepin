//
//  CertificateCell.m
//  cepin
//
//  Created by dujincai on 15/5/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CertificateCell.h"
#import "ResumeNameModel.h"
#import "NSString+Extension.h"
#import "NSDate-Utilities.h"


@implementation CertificateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        int imageHight = 21.0;
        UIImageView *imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake( 40 / 3.0, 40 / 3.0 - (imageHight - [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize) / 2.0, imageHight, imageHight)];
        imageLogo.image = [UIImage imageNamed:@"ic_jl"];
        [self.contentView addSubview:imageLogo];
        
        
        self.time = [[UILabel alloc] init];
        self.time.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.time.numberOfLines = 0;
        [self.contentView addSubview:self.time];
        
        self.name = [[UILabel alloc] init];
        self.name.numberOfLines = 0;
        self.name.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.name.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.name];
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 0.8);
        [self.contentView addSubview:separatorView];
        self.baseSeparatorView = separatorView;
    }
    return self;
}

- (void)getModel:(id)model
{
    CredentialListDataModel *cerModel = model;
    
    NSString *time = [self managestrTime:cerModel.Date];
    
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  专业证书";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    self.time.attributedText = [timeAttStr copy];
    self.name.text = cerModel.Name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat tempH = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize;
    CGFloat maxMarge = self.viewWidth - 40 - 40 / 3.0;
    
    CGSize timeSize = [NSString caculateAttTextSize:self.time.attributedText andWith:maxMarge];
    self.time.frame = CGRectMake(40.0, 40 / 3.0, timeSize.width, tempH);
    
    CGSize nameSize = [NSString caculateTextSize:self.name.font text:self.name.text andWith:maxMarge];
    
    if ( nameSize.height > tempH * 1.4 )
        tempH = nameSize.height;
    
    self.name.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.time.frame) + 5.0, nameSize.width, tempH);
    
    self.baseSeparatorView.frame = CGRectMake(self.name.viewX, self.viewHeight - 1.0, kScreenWidth - self.name.viewX, 1 / 2.0);
}
@end
