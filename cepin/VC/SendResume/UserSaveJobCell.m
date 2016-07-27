//
//  UserSaveJobCell.m
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UserSaveJobCell.h"
#import "SendReumeModel.h"
#import "NSDate-Utilities.h"
#import "TBTextUnit.h"

#define kResumeDetailStringFormat(Salary,Address,CompanyName) [NSString stringWithFormat:@"<font color='#fb6e52' size=12>%@</font> <font color='#999999' size=12>%@ %@</font>",Salary,Address,CompanyName]

@implementation UserSaveJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelTitle = [[UILabel alloc] init];
        self.labelTitle.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        self.labelTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.labelTitle];
        
        self.labelState = [[UILabel alloc] init];
        self.labelState.font = [[RTAPPUIHelper shareInstance] profileResumeStatueFont];
        self.labelState.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        [self.contentView addSubview:self.labelState];
      
        
        self.time = [[UILabel alloc] init];
        self.time.font = [[RTAPPUIHelper shareInstance] profileResumeStatueFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [self.contentView addSubview:self.time];
        self.detailLable = [[UILabel alloc] init];
        self.detailLable.font = [[RTAPPUIHelper shareInstance] profileResumeStatueFont];
        self.detailLable.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [self.contentView addSubview:self.detailLable];
        
        UIView *lineView = [[UIView alloc]init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        _lineView = lineView;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@(1));
        }];
    }
    return self;
}

- (void)layoutSubviews
{
//    int width = [[self class]computerTextWidth:self.labelState.text];
//    
//    self.labelState.frame = CGRectMake(kScreenWidth- width-20, 10, width + 20, IS_IPHONE_5?11:12.6);
//    self.labelTitle.frame =CGRectMake(20, 10, kScreenWidth - self.labelState.viewWidth - 20, IS_IPHONE_5?12:14.4);
//    self.time.frame = CGRectMake(kScreenWidth- width-20, self.labelState.viewHeight + self.labelState.viewY+10, width + 20, IS_IPHONE_5?11:12.6);
//    self.detailLable.frame = CGRectMake(self.labelTitle.viewX, self.labelTitle.viewY + self.labelTitle.viewHeight + 10, kScreenWidth - self.labelState.viewWidth - 20, IS_IPHONE_5?11:12.6);
    
    [super layoutSubviews];
    
    CGFloat stateY = 40 / 3.0;
    CGSize stateSize = [self.labelState.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeStatueFont] } context:nil].size;
    CGFloat stateW = stateSize.width;
    CGFloat stateH = stateSize.height;
    CGFloat stateX = self.viewWidth - stateW - stateY;
    self.labelState.frame = CGRectMake(stateX, stateY, stateW, stateH);
    
    CGFloat titleX = stateY;
    CGFloat titleY = stateY;
    CGSize titleSize = [self.labelTitle.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeNameFont] } context:nil].size;
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    CGFloat maxMarge = self.labelState.viewX - 2 * 8.0;
    if ( titleW > maxMarge )
        titleW = maxMarge;
    self.labelTitle.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat timeY = CGRectGetMaxY(self.labelState.frame) + 8.0;
    CGSize timeSize = [self.time.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeStatueFont] } context:nil].size;
    CGFloat timeW = timeSize.width;
    CGFloat timeH = timeSize.height;
    CGFloat timeX = self.viewWidth - stateY - timeSize.width;
    self.time.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat detailX = titleX;
    CGSize detailSize = [self.detailLable.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeStatueFont] } context:nil].size;
    CGFloat detailW = detailSize.width;
    CGFloat detailH = detailSize.height;
    CGFloat detailY = self.viewHeight - 40 / 3.0 - detailH;
    
    maxMarge = self.time.viewX - 40 / 3.0 - 2.0;
    
    if ( detailW > maxMarge )
        detailW = maxMarge;
    
    self.detailLable.frame = CGRectMake(detailX, detailY, detailW, detailH);
    
}

+(int)computerTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]titleFont]);
    return size.width;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)configWithBean:(SendReumeModel*)bean
{
    self.labelTitle.text = bean.PositionName;
    self.detailLable.text = [TBTextUnit formatSalary:bean.Salary company:bean.CompanyName city:bean.Address];
    self.time.text = [NSDate cepinDateStringFromString:bean.ApplyDate];;
    if (bean.Viewed.intValue == 1)
    {
        self.labelState.text = @"已查看";
        self.labelState.textColor = [[RTAPPUIHelper shareInstance]labelColorGreen];
    }
    else
    {
        self.labelState.text = @"未查看";
        self.labelState.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    }
}


@end
