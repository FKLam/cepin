//
//  SubscriptionJobCell.m
//  cepin
//
//  Created by dujincai on 15/5/22.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SubscriptionJobCell.h"

@implementation SubscriptionJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //input__xx
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(40 / 3.0, 10, imagehight, imagehight)];
        self.imageLogo.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.imageLogo];
        
        self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageLogo.viewWidth + self.imageLogo.viewX + 10, 5, IS_IPHONE_5?45:55, 30)];
        self.titlelabel.textColor = [[RTAPPUIHelper shareInstance] searchResultSubColor];
        self.titlelabel.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        [self.contentView addSubview:self.titlelabel];
        
        self.inputImage = [[UIImageView alloc]init];
        self.inputImage.image = [UIImage imageNamed:@"ic_next"];
        [self.contentView addSubview:self.inputImage];
        
        self.placeholderField = [[UITextField alloc] init];
        self.placeholderField.userInteractionEnabled = NO;
        self.placeholderField.textAlignment = NSTextAlignmentRight;
        self.placeholderField.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.placeholderField.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        [self.contentView addSubview:self.placeholderField];
        
        self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clickButton.backgroundColor = [UIColor clearColor];
        self.clickButton.frame = self.bounds;
        [self.contentView addSubview:self.clickButton];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_bottom).offset( -1 );
            make.height.equalTo(@( 1 ));
        }];
    }
    return self;
}

#pragma mark - private method
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.inputImage.viewWidth = self.inputImage.image.size.width * 0.6;
    self.inputImage.viewHeight = self.inputImage.image.size.width * 0.6;
    self.inputImage.viewY = self.viewHeight / 2.0 - self.inputImage.viewHeight / 2.0;
    self.inputImage.viewX = self.viewWidth - self.inputImage.viewWidth;
    
    CGFloat imageLogoX = 40 / 3.0 - 5.0;
    CGFloat imageLogoW = self.viewHeight * 2 / 3.0;
    CGFloat imageLogoH = self.viewHeight * 2 / 3.0;
    CGFloat imageLogoY = ( self.viewHeight - imageLogoH ) / 2.0;
    self.imageLogo.frame = CGRectMake(imageLogoX, imageLogoY, imageLogoW, imageLogoH);
    
    CGFloat titleLabelX = CGRectGetMaxX(self.imageLogo.frame) + 40 / 3.0;
    CGFloat titleLabelY = 0;
    CGSize titleLabelSize = [self.titlelabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] searchResultSubFont] } context:nil].size;
    CGFloat titleLabelH = self.viewHeight;
    CGFloat titleLabelW = titleLabelSize.width;
    self.titlelabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    self.placeholderField.viewWidth = self.inputImage.viewX - CGRectGetMaxX(self.titlelabel.frame) - 40 / 3.0;
    self.placeholderField.viewX = CGRectGetMaxX(self.titlelabel.frame) + 40 / 3.0;
    self.placeholderField.viewY = 0;
    self.placeholderField.viewHeight = self.viewHeight;
}

-(void)configureTextFieldText:(NSString *)text
{
    if (text && ![text isEqualToString:@""])
    {
        self.placeholderField.text = text;
    }
    else
    {
        self.placeholderField.text = @"";
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
