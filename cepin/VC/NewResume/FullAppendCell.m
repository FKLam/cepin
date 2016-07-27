//
//  FullAppendCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullAppendCell.h"
#import "NSString+Extension.h"

@interface FullAppendCell ()<UITextViewDelegate>

@end

@implementation FullAppendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
//        int hight = IS_IPHONE_5?12:15;

        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 102 / 3.0)];
        baseView.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:baseView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / 3.0, baseView.viewY, self.viewWidth - 40 / 3.0 * 2, baseView.viewHeight)];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance]labelColorGreen];
        self.titleLabel.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:self.titleLabel];
        
        self.appendText = [[UILabel alloc]init];
        self.appendText.numberOfLines = 0;
        self.appendText.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.appendText.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.appendText];
        [self.appendText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset( 40 / 3.0 );
            make.bottom.equalTo(self.mas_bottom).offset( -40 / 3.0 );
            make.right.equalTo(self.mas_right).offset( -40 / 6.0 );
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    if ( [self.appendText.text isEqualToString:@"无"] )
//    {
//        self.appendText.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
//    }
//    else
//    {
//        self.appendText.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
//    }
//    
//    CGFloat maxMarge = self.viewWidth - 40 / 3.0 - 5.0;
//    
//    CGSize appendSize = [NSString caculateTextSize:self.appendText.font text:self.appendText.text andWith:maxMarge];
//    if ( appendSize.width < maxMarge )
//    {
//        self.appendText.frame = CGRectMake( 40 / 3.0, 102 / 3.0 + 5.0, maxMarge, appendSize.height + 18 * CP_RECOMMEND_SCALE);
//    }
//    else
//        self.appendText.frame = CGRectMake( 40 / 3.0, 102 / 3.0 + 5.0, appendSize.width + 5.0 * CP_RECOMMEND_SCALE, appendSize.height + 18 * CP_RECOMMEND_SCALE);
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0.0;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont],
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
}
- (void)changeAppendText:(NSString *)str
{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 0.0;
//    
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont],
//                                 NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor],
//                                 NSParagraphStyleAttributeName : paragraphStyle
//                                 };
//    self.appendText.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    self.appendText.text = str;
}

@end
