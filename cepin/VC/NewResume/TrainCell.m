//
//  TrainCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "TrainCell.h"
#import "ResumeNameModel.h"
#import "TBTextUnit.h"
#import "NSString+Extension.h"
#import "CPCommon.h"

@implementation TrainCell
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
        [self.contentView addSubview:imageLogo];
        
        
        self.time = [[UILabel alloc] init];
        self.time.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.time];
        
        self.name = [[UILabel alloc] init];
        self.name.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.name.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.name];
        
        self.content = [[UILabel alloc] init];
        self.content.numberOfLines = 0;
        self.content.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        self.content.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
    
        [self.contentView addSubview:self.content];
        
        self.content.userInteractionEnabled = NO;

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
    
    CGFloat tempH = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize;
    
    CGFloat maxMarge = self.viewWidth - 40 - 40 / 3.0;
    
    CGSize timeSize = [NSString caculateTextSize:self.time.font text:self.time.text andWith:maxMarge];
    self.time.frame = CGRectMake( 40.0, 40 / 3.0, timeSize.width, tempH);
    
    CGSize nameSize = [NSString caculateTextSize:self.name.font text:self.name.text andWith:maxMarge];
    self.name.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.time.frame) + 5.0, nameSize.width, tempH);
    
    CGSize contentSize = [NSString caculateTextSize:self.content.font text:self.content.text andWith:maxMarge];
    self.content.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.name.frame) + 5.0, contentSize.width, contentSize.height);
    
    self.separatorView.frame = CGRectMake(self.time.viewX, self.viewHeight - 1.0, kScreenWidth - self.time.viewX, 1 / 2.0);
   
}
- (void)getModel:(id)model
{
    TrainingDataModel *trainModel = model;
    NSString *star = [self managestrTime:trainModel.StartDate];
    NSString *end = [self managestrTime:trainModel.EndDate];
    NSString *time = [NSString stringWithFormat:@"%@ - %@",star,end];
    self.time.text = time;
    self.name.text = [TBTextUnit fullResumeDetail:trainModel.Name degle:trainModel.Organization];
    self.content.text = trainModel.Content;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
