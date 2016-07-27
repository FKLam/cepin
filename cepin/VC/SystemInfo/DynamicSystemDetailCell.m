//
//  DynamicSystemDetailCell.m
//  cepin
//
//  Created by ceping on 14-12-29.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemDetailCell.h"

@implementation DynamicSystemDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.lableTitle];
        
        self.lableTitle.numberOfLines = 0;
        self.lableTitle.textColor = UIColorFromRGB(0x444444);
        self.lableTitle.backgroundColor = [UIColor clearColor];
        self.lableTitle.font = [UIFont boldSystemFontOfSize:16];
        
        self.lableTime = [[UILabel alloc]initWithFrame:CGRectMake(10, self.lableTitle.viewHeight + self.lableTitle.viewY + 10, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.lableTime];
        
        self.lableTime.textColor = UIColorFromRGB(0x444444);
        self.lableTime.backgroundColor = [UIColor clearColor];
        self.lableTime.font = [UIFont systemFontOfSize:14];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, self.lableTime.viewHeight + self.lableTime.viewY + 10, kScreenWidth-20, 0.5)];
        [self.contentView addSubview:self.lineView];
        self.lineView.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];

        self.webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        self.webView.backgroundColor = [UIColor clearColor];
        [self.webView setOpaque:NO];
//        self.webView.delegate = self;
        self.webView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lableTime.mas_left);
            make.top.equalTo(self.lableTime.mas_bottom).offset(10);
            make.right.equalTo(self.lableTime.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int height1 = StringFontSizeH(self.lableTitle.text, [UIFont boldSystemFontOfSize:16], kScreenWidth - 20) + 10;
    height1 = MAX(20, height1);
    self.lableTitle.frame = CGRectMake(10, 20, kScreenWidth-20, height1);
    
    self.lableTime.frame = CGRectMake(10, self.lableTitle.viewHeight + self.lableTitle.viewY + 10, kScreenWidth-20, 20);
    
    self.lineView.frame = CGRectMake(10, self.lableTime.viewHeight + self.lableTime.viewY + 10, kScreenWidth-20, 0.5);
    
//    int height2 = StringFontSizeH(self.lableDetail.text, [UIFont systemFontOfSize:14], kScreenWidth - 20) + 10;
//    height2 = MAX(20, height2);
//    self.lableDetail.frame = CGRectMake(10, self.lableTime.viewHeight + self.lableTime.viewY + 20, kScreenWidth-20, height2);
}

+(int)computerCellHeight:(NSString*)strTitle
{
    int height1 = StringFontSizeH(strTitle, [UIFont boldSystemFontOfSize:16], kScreenWidth - 20) + 10;
    height1 = MAX(20, height1);
//    int height2 = StringFontSizeH(strDetail, [UIFont systemFontOfSize:14], kScreenWidth - 20) + 10;
//    height2 = MAX(20, height2);
    
    return  80 + height1;
}
-(void)loadHtmlString:(NSString*)str
{
    NSMutableString *mStr = [[NSMutableString alloc]init];
    [mStr appendString:[NSString stringWithFormat:@"<html><body>"]];
    [mStr appendString:str];
    [mStr appendString:[NSString stringWithFormat:@"</html></body>"]];
    
    [self.webView loadHTMLString:str baseURL:nil];
    
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSURL *requestURL = [request URL];
//    
//    if ([[requestURL scheme] isEqualToString:@"http"] &&(navigationType == UIWebViewNavigationTypeLinkClicked)) {
//        
//        [[UIApplication sharedApplication]openURL:requestURL];
//        return NO;
//    }
//
//    if ([self.delegate respondsToSelector:@selector(shouldStartLoadWithRequest:navigationType:)]) {
//        [self.delegate respondsToSelector:@selector(shouldStartLoadWithRequest:navigationType:)];
//        return NO;
//    }
//    return YES;
//}
@end
