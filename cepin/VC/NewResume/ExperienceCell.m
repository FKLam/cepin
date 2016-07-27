//
//  ExperienceCell.m
//  cepin
//
//  Created by dujincai on 15-4-22.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExperienceCell.h"
#import "ResumeNameModel.h"
#import "NSString+Extension.h"
#import "CPCommon.h"

@interface ExperienceCell ()

@property (nonatomic, weak) UILabel *proveLabel;

@end

@implementation ExperienceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        int imageHight = 21.0;
        int hight = IS_IPHONE_5?11:12.6;
        UIImageView *imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake( 40 / 3.0, 40 / 3.0 - (imageHight - [[RTAPPUIHelper shareInstance] jobInformationDetaillFont].pointSize) / 2.0, imageHight, imageHight)];
        imageLogo.image = [UIImage imageNamed:@"ic_jl"];
        [self.contentView addSubview:imageLogo];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(imageLogo.viewWidth + imageLogo.viewX + 10, 3, self.viewWidth - 40, hight)];
        self.time.font = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.time];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(self.time.viewX, self.time.viewHeight + 10, self.viewWidth - imageHight -40, hight)];
        self.name.font = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont];
        self.name.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.name];
        
        self.position = [[UILabel alloc]initWithFrame:CGRectMake(self.name.viewX, self.name.viewY + self.name.viewHeight + 10, self.viewWidth - imageHight - 40, hight)];
        self.position.font = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont];
        self.position.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.position];
        
        UILabel *proveLabel = [[UILabel alloc] init];
        proveLabel.font = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont];
        proveLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        [proveLabel setUserInteractionEnabled:NO];
        [proveLabel setTextAlignment:NSTextAlignmentLeft];
        [proveLabel setNumberOfLines:0];
        [self.contentView addSubview:proveLabel];
        _proveLabel = proveLabel;
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 0.8);
        [self.contentView addSubview:separatorView];
        _separatorView = separatorView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat tempH = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont].pointSize;
    CGFloat maxMarge = self.viewWidth - 40  - 40 / 3.0;
    
    CGSize timeSize = [NSString caculateTextSize:self.time.font text:self.time.text andWith:maxMarge];
    self.time.frame =CGRectMake( 40, 40 / 3.0, timeSize.width, tempH);
    
    CGSize nameSize = [NSString caculateTextSize:self.name.font text:self.name.text andWith:maxMarge];
    self.name.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.time.frame) + 5.0, nameSize.width, tempH);
    
    CGSize positionSize = [NSString caculateTextSize:self.position.font text:self.position.text andWith:maxMarge];
    self.position.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.name.frame) + 5.0, positionSize.width, tempH);
    
    CGSize proveSize = [NSString caculateTextSize:self.proveLabel.font text:self.proveLabel.text andWith:maxMarge];
    self.proveLabel.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.position.frame) + 5.0, proveSize.width, proveSize.height);
    
    self.separatorView.frame = CGRectMake(self.time.viewX, self.viewHeight - 1.0, kScreenWidth - self.time.viewX, 1 / 2.0);
}

- (void)getModel:(id)model
{
    self.proveLabel.text = nil;
    WorkListDateModel *exModel = model;
    NSString *star = [self managestrTime:exModel.StartDate];
    NSString *end = [self managestrTime:exModel.EndDate];
    
    NSString *time = [NSString stringWithFormat:@"%@-%@",star,end];
    self.time.text = time;
    self.name.text = exModel.Company;
    self.position.text = exModel.JobFunction;
    
    NSMutableString *proveStr = [NSMutableString string];
    if(exModel.AttestorName)
    {
        [proveStr appendFormat:@"证明人：%@", exModel.AttestorName];
    }
    
    if(exModel.AttestorRelation)
    {
        [proveStr appendFormat:@"／%@", exModel.AttestorRelation];
    }
    
    if(exModel.AttestorPosition)
    {
        [proveStr appendFormat:@"／%@", exModel.AttestorPosition];
    }
    
    if(exModel.AttestorPhone)
    {
        [proveStr appendFormat:@"／%@", exModel.AttestorPhone];
    }
    
    if(exModel.AttestorCompany)
    {
        [proveStr appendFormat:@"\n证明人单位：%@", exModel.AttestorCompany];
    }
    
    self.proveLabel.text = [proveStr copy];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
