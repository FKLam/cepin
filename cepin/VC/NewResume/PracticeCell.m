//
//  PracticeCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "PracticeCell.h"
#import "ResumeNameModel.h"
#import "NSString+Extension.h"

@interface PracticeCell()

@property (nonatomic, weak) UILabel *describeLabel;

@end

@implementation PracticeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        int imageHight = 21.0;
        int hight = IS_IPHONE_5?11:12.6;
        UIImageView *imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake( 40 / 3.0, 40 / 3.0 - (imageHight - [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize) / 2.0, imageHight, imageHight)];
        imageLogo.image = [UIImage imageNamed:@"ic_jl"];
        [self.contentView addSubview:imageLogo];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(imageLogo.viewWidth + imageLogo.viewX + 10, 0, self.viewWidth - 40 / 3.0 * 2, hight)];
        self.time.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.time];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(self.time.viewX, self.time.viewHeight + 10, self.viewWidth - 40, hight)];
        self.title.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.title.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.title.numberOfLines = 1;
        [self.contentView addSubview:self.title];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(self.title.viewX, self.title.viewY + self.title.viewHeight + 10, self.viewWidth - 40, hight)];
        self.name.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.name.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.name.numberOfLines = 1;
        [self.contentView addSubview:self.name];
        
        UILabel *describeLabel = [[UILabel alloc] init];
        describeLabel.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        describeLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        describeLabel.numberOfLines = 0;
        [self.contentView addSubview:describeLabel];
        _describeLabel = describeLabel;
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 0.8);
        [self.contentView addSubview:separatorView];
        self.baseSeparatorView = separatorView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat tempH = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize;
    
    CGFloat maxMarge = self.viewWidth - 40 / 3.0 - 40.0;
    
//    CGSize timeSie = [NSString caculateTextSize:self.time.font text:self.time.text andWith:maxMarge];
    CGSize timeSize = [NSString caculateAttTextSize:self.time.attributedText andWith:maxMarge];
    self.time.frame = CGRectMake(40.0, 40 / 3.0, timeSize.width, tempH);
    
    CGSize nameSize = [NSString caculateTextSize:self.name.font text:self.name.text andWith:maxMarge];
    self.name.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.time.frame) + 5.0, nameSize.width, tempH);
    
    CGSize titleSize = [NSString caculateTextSize:self.title.font text:self.title.text andWith:maxMarge];
    self.title.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.name.frame) + 5.0, titleSize.width, tempH);
    
    CGSize describeSize = [NSString caculateTextSize:self.describeLabel.font text:self.describeLabel.text andWith:maxMarge];
    self.describeLabel.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.title.frame) + 5.0, describeSize.width, describeSize.height);
    
    self.baseSeparatorView.frame = CGRectMake(self.time.viewX, self.viewHeight - 1.0, kScreenWidth - self.time.viewX, 1 / 2.0);
}

-(void)getModel:(id)model
{
    PracticeListDataModel *praModel = model;
    NSString *star = [self managestrTime:praModel.StartDate];
    NSString *end = [self managestrTime:praModel.EndDate];
    NSString *time = [NSString stringWithFormat:@"%@ - %@",star,end];
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  社会实践";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    self.time.attributedText = [timeAttStr copy];
    self.title.text = praModel.Title;
    self.name.text = praModel.Name;
    self.describeLabel.text = praModel.Content;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
