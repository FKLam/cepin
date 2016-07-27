//
//  CompanyIntroduceCell.m
//  cepin
//
//  Created by zhu on 14/12/7.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CompanyIntroduceCell.h"
#import "NSString+Extension.h"
#import "CPCommon.h"

#define CP_MORE_BUTTON_HEIGHT ( 144.0 / 3.0 )

@interface CompanyIntroduceCell()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation CompanyIntroduceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.isOpen = NO;
    
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = RGBCOLOR(230, 230, 230);
        
        self.viewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.viewHeight)];
        self.viewBackground.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.viewBackground];
      
        
        self.introduction = [[UILabel alloc] init];
        self.introduction.text = @"公司简介";
        self.introduction.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.introduction.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        [self.viewBackground addSubview:self.introduction];
        
        self.labelIntroduction = [[UILabel alloc] init];
        self.labelIntroduction.numberOfLines = 0;
        
//        self.labelIntroduction = [[UITextView alloc] init];
//        self.labelIntroduction.userInteractionEnabled = NO;
//        self.labelIntroduction.contentInset = UIEdgeInsetsMake( -8.0, -5.0, 0, 0);
        self.labelIntroduction.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont];
        self.labelIntroduction.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        [self.viewBackground addSubview:self.labelIntroduction];
        
        
        
//       int offset = [APPFunctionHelper computerOffsetY:4 topRect:self.labelIntroduction.frame];
        
        self.buttonMore = [[FUIButton alloc] init];
        
        [self.buttonMore setTitle:@"点击查看更多" forState:UIControlStateNormal];
        [self.buttonMore setTitleColor:[[RTAPPUIHelper shareInstance] subTitleColor] forState:UIControlStateNormal];
        
        [self.buttonMore setImage:[UIImage imageNamed:@"dropdownbox_ic_down"] forState:UIControlStateNormal];
        [self.buttonMore setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 32 / 3.0)];
        
        self.buttonMore.imageView.viewSize = CGSizeMake(CP_MORE_BUTTON_HEIGHT / 2.0, CP_MORE_BUTTON_HEIGHT / 2.0);
        
//        [self.buttonMore setImage:[UIImage imageNamed:@"dropdownbox_ic_up"] forState:UIControlStateNormal];
        
        self.buttonMore.titleLabel.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont];
        self.buttonMore.buttonColor = [[RTAPPUIHelper shareInstance] whiteColor];
        self.buttonMore.buttonHighlightedColor = [[RTAPPUIHelper shareInstance] whiteColor];
        self.buttonMore.userInteractionEnabled = NO;
        [self.viewBackground addSubview:self.buttonMore];
        self.buttonMore.hidden = YES;
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 1.0);
        [self.viewBackground addSubview:self.lineView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maxMarge = self.viewWidth - 40 / 3.0 * 2.0;
    
    CGFloat horizontal_marge = 40 / 3.0;
    
    CGSize nameSize = [NSString caculateTextSize:self.introduction.font text:self.introduction.text andWith:maxMarge];
    self.introduction.frame = CGRectMake(horizontal_marge, horizontal_marge, nameSize.width, nameSize.height);
    
    self.buttonMore.frame = CGRectMake(0, self.viewHeight - CP_MORE_BUTTON_HEIGHT, self.viewWidth, CP_MORE_BUTTON_HEIGHT);
    
    self.lineView.frame = CGRectMake(40 / 3.0, self.buttonMore.viewY - 1, kScreenWidth - 40 / 3.0 * 2.0, 1);
    
    NSString *regularStr = self.labelIntroduction.text;
    if ( regularStr && [regularStr length] > 0 )
    {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<br />+" options:0 error:nil];
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"\n"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n+\\s*" options:0 error:nil];
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"<p />"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<p />+\\s*</p>" options:0 error:nil];
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"<p />"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"&nbsp;+" options:0 error:nil];
        
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@""];
    }
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[regularStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSString *subStr = [attrStr.string copy];
    
    if ( subStr.length > 0 )
    {
        NSRegularExpression *subStrExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n*\\s+$" options:0 error:nil];
        subStr = [subStrExpression stringByReplacingMatchesInString:subStr options:0 range:NSMakeRange(0, subStr.length) withTemplate:@""];
    }
    
    CGSize introductionSize = [NSString caculateTextSize:self.labelIntroduction.font text:subStr andWith:maxMarge ];
    
    CGFloat fixdHeight = 49.0;
    if ( fixdHeight >= introductionSize.height )
    {
        self.labelIntroduction.frame = CGRectMake(horizontal_marge, CGRectGetMaxY(self.introduction.frame) + 5.0, introductionSize.width + 2.5, introductionSize.height);
        self.buttonMore.hidden = YES;
        self.lineView.hidden = YES;
    }
    else
    {
        CGFloat tempH = self.buttonMore.viewY - CGRectGetMaxY(self.introduction.frame);
        tempH -= 40 / 3.0;
        
        self.labelIntroduction.frame = CGRectMake(horizontal_marge, CGRectGetMaxY(self.introduction.frame) + 5.0, introductionSize.width + 2.5, tempH);
        self.buttonMore.hidden = NO;
        self.lineView.hidden = NO;
    }
}

+ (int)computerWithHight:(NSString*)str
{
    return StringFontSizeH(str, [[RTAPPUIHelper shareInstance]mainTitleFont], kScreenWidth - 40);
   
}

+(CGFloat)computerCellHeihgt:(NSString*)str open:(BOOL)open
{
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"</p><p>"];
    NSString *regularStr = str;
    if ( regularStr && [regularStr length] > 0 )
    {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<br />+" options:0 error:nil];
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"\n"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n+\\s*" options:0 error:nil];
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"<p />"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<p />+\\s*</p>" options:0 error:nil];
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"<p />"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"&nbsp;+" options:0 error:nil];
        
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@""];
    }

    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[regularStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSString *subStr = [attrStr.string copy];
    
    if ( subStr.length > 0 )
    {
        NSRegularExpression *subStrExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n*\\s+$" options:0 error:nil];
        subStr = [subStrExpression stringByReplacingMatchesInString:subStr options:0 range:NSMakeRange(0, subStr.length) withTemplate:@""];
    }
    
    CGSize strSize = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:subStr andWith:kScreenWidth - 40 / 3.0 * 2 + 40 / 6.0];
    CGFloat fixdHeight = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize * 3;
    if (strSize.height <= fixdHeight)
    {
        //这种情况是没有button的, 加上10个像素的偏移量
        return strSize.height + 44.0;
    }
    else
    {
        if (open)
        {
            return strSize.height + 44.0 + 44.0 + 38.0;
        }
        else
        {
            return [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize * 3 + 44.0 + 44.0 + 40 / 3.0;
        }
    }
}

-(void)configureWithBean:(CompanyDetailModelDTO *)bean
{
    NSString *regularStr = bean.Description;
    if ( regularStr && [regularStr length] > 0 )
    {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<br />+" options:0 error:nil];
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"\n"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n+\\s*" options:0 error:nil];
        
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"<p />"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<p />+\\s*</p>" options:0 error:nil];
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@"<p />"];
        
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"&nbsp;+" options:0 error:nil];
        
        regularStr = [regularExpression stringByReplacingMatchesInString:regularStr options:0 range:NSMakeRange(0, regularStr.length) withTemplate:@""];
        
    }
//    bean.Description = [bean.Description stringByReplacingOccurrencesOfString:@"\n" withString:@"</p><p>"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[regularStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    int nTemp = StringFontSizeH(attrStr.string, [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont], kScreenWidth - 40) + 10;
    if (nTemp > kDefaultCompanyIntroduceStringHeihgt)
    {
        self.buttonMore.hidden = NO;
        self.lineView.hidden = NO;
    }else
    {
        self.buttonMore.hidden = YES;
        self.lineView.hidden = YES;
    }
//    NSString * htmlString = @"<html><body> Some html string \n <font size=\"13\" color=\"red\">This is some text!</font> </body></html>";
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[bean.Description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
#pragma mark - 修改公司详情文字的颜色
//    self.labelIntroduction.attributedText = attrStr;
    
    NSString *subStr = [attrStr.string copy];
    
    if ( subStr.length > 0 )
    {
        NSRegularExpression *subStrExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n*\\s+$" options:0 error:nil];
        subStr = [subStrExpression stringByReplacingMatchesInString:subStr options:0 range:NSMakeRange(0, subStr.length) withTemplate:@""];
    }
    
    self.labelIntroduction.text = nil;
    self.labelIntroduction.text = subStr;
}
@end
