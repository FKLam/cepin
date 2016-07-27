//
//  FullUserRemarkCell.m
//  cepin
//
//  Created by dujincai on 15/7/22.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullUserRemarkCell.h"
#import "NSString+Extension.h"

@implementation FullUserRemarkCell
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
        
        self.appendText = [[UITextView alloc]init];
        self.appendText.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.appendText.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.appendText.userInteractionEnabled = NO;
//        self.appendText.contentInset = UIEdgeInsetsMake( -9.0, -5.0, 0, 0 );
        self.appendText.textContainerInset = UIEdgeInsetsMake(-1.0, -5.0, 0, 0);
        [self.contentView addSubview:self.appendText];
        [self.appendText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset( 40 / 3.0 );
            make.bottom.equalTo(self.mas_bottom).offset( -40 / 3.0 );
            make.right.equalTo(self.mas_right).offset( 0 );
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
//        self.appendText.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
//    }
//    
//    CGFloat maxMarge = self.viewWidth - 40 / 3.0;
//    
//    CGSize appendSize = [NSString caculateTextSize:self.appendText.font text:self.appendText.text andWith:maxMarge];
//    
//    if ( self.appendText.text.length == 1 )
//    {
//        self.appendText.frame = CGRectMake(40 / 3.0, 102 / 3.0 + 10.0, appendSize.width + 10.0, appendSize.height + 10.0);
//    }
//    else
//    {
//        if ( appendSize.width < maxMarge )
//        {
//            self.appendText.frame = CGRectMake(40 / 3.0, 102 / 3.0 + 5.0, maxMarge, appendSize.height + 18.0 * CP_RECOMMEND_SCALE);
//        }
//        else
//            self.appendText.frame = CGRectMake(40 / 3.0, 102 / 3.0 + 5.0, appendSize.width + 5.0 * CP_RECOMMEND_SCALE, appendSize.height + 18.0 * CP_RECOMMEND_SCALE);
////        CGRectMake( 40 / 3.0, 102 / 3.0 + 5.0, appendSize.width + 10.0, appendSize.height + 15.0
//    }
}

- (void)changeAppendText:(NSString *)str
{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 0.0;
//    
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName : [[RTAPPUIHelper shareInstance] searchResultSubFont],
//                                 NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor],
//                                 NSParagraphStyleAttributeName : paragraphStyle
//                                 };
//    self.appendText.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    self.appendText.text = str;
}

@end
