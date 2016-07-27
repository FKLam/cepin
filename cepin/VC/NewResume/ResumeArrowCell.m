//
//  ResumeArrowCell.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeArrowCell.h"

@interface ResumeArrowCell()

@property (nonatomic, strong) UIImageView *starView;

@end

@implementation ResumeArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int hight = IS_IPHONE_5?21:25;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 44)];
         self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformatonFont];
        [self addSubview:self.titleLabel];
        
        UIImageView *arrowImage = [[UIImageView alloc]init];
        arrowImage.image = [UIImage imageNamed:@"ic_next"];
        [self addSubview:arrowImage];
        
        self.infoText = [[CPResumeTextField alloc]init];
        self.infoText.textAlignment = NSTextAlignmentRight;
        self.infoText.userInteractionEnabled = NO;
        self.infoText.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.infoText.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        
        [self addSubview:self.infoText];
        
        UIImageView *starView = [[UIImageView alloc] initWithImage:UIIMAGE(@"ic_asterisk")];
        starView.viewX = 40 / 3.0;
        [self addSubview:starView];
        _starView = starView;
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        self.line.hidden = NO;
        [self addSubview:self.line];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.starView.mas_right).offset(0);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(100));
            make.height.equalTo(self.mas_height);
        }];
        
        [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(hight));
            make.width.equalTo(@(hight));
        }];
        
        [self.infoText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.right.equalTo(arrowImage.mas_left);
            make.centerY.equalTo(self.mas_centerY);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.bottom.equalTo(self.mas_bottom).offset( -1 );
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( _showStar )
    {
        _starView.frame = CGRectMake( 40 / 3.0, (self.viewHeight - 20.0 * 0.8) / 2.0, 20.0 * 0.8, 20.0 * 0.8);
    }
    else
    {
        _starView.viewSize = CGSizeZero;
    }
}

+(int)computerTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [UIFont boldSystemFontOfSize:16]);
//    [str sizeWithAttributes:<#(NSDictionary *)#>]
    return size.width;
}

- (void)configureInfoText:(NSString *)text
{
    if (text && ![text isEqualToString:@""]) {
        self.infoText.text = text;
    }else{
        self.infoText.text = @"";
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
