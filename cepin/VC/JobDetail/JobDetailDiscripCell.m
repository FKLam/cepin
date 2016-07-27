//
//  JobDetailDiscripCell.m
//  cepin
//
//  Created by ceping on 15-1-22.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobDetailDiscripCell.h"

@interface JobDetailDiscripCell()

@property (nonatomic, assign) CGFloat perHeight;

@end

@implementation JobDetailDiscripCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
        self.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *viewCell = [[UIView alloc] init];
        viewCell.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewCell];
        [viewCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top).offset(5);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
        
//        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 50)];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [viewCell addSubview:self.titleLabel];
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, self.titleLabel.viewY + self.titleLabel.viewHeight, self.viewWidth - 20.0, viewCell.viewHeight)];
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.userInteractionEnabled = NO;
        self.webView.tintColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.webView.delegate = self;
        [self.webView setOpaque:NO];
        UIScrollView *tempView = (UIScrollView *)[self.webView.subviews objectAtIndex:0];
        tempView.scrollEnabled = NO;
        
        [viewCell addSubview:self.webView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.webView.frame = CGRectMake(10, self.titleLabel.viewY + self.titleLabel.viewHeight, 300, self.viewHeight);
    
    if ( self.perHeight < self.viewHeight )
        self.perHeight = self.viewHeight;
    
    CGSize titleLabelSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] jobInformationPositionDetailFont] } context:nil].size;
    
    self.titleLabel.frame = CGRectMake(20, 10, titleLabelSize.width, titleLabelSize.height);
    
    self.webView.viewY = CGRectGetMaxY(self.titleLabel.frame);
    
    if ( self.webView.viewHeight != self.perHeight)
    {
        self.webView.viewHeight = self.perHeight;
    }
}

-(void)loadHtmlString:(NSString*)str
{
#pragma mark - 增加行高的控制
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size: %@; font-family: \"%@\"; color: %@; line-height : %@} \n"
                          "p {margin-top : %@; margin-bottom : %@} \n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", [[RTAPPUIHelper shareInstance]jobInformationPositionDetailContentFont], @"微软雅黑",@"#9d9d9d", [NSNumber numberWithFloat:1.2], [NSNumber numberWithFloat:5.0], [NSNumber numberWithFloat:5.0], str];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.webView loadHTMLString:[NSString stringWithFormat:@"%@%@", @"\n", jsString] baseURL:nil];
        
    });
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 设置字体大小
    // 设置字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='95%'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor='#9d9d9d'"];
    webView.opaque = NO;
    
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *h = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
        CGRect webViewFrame = weakSelf.webView.frame;
        
        if ( weakSelf.perHeight < [h floatValue])
            weakSelf.perHeight = [h floatValue];
        
        webViewFrame.size.height = weakSelf.perHeight;
        weakSelf.webView.frame = webViewFrame;
        [weakSelf.webView sizeThatFits:webViewFrame.size];
//        weakSelf.webView.scrollView.contentSize = webViewFrame.size;
        
        [weakSelf layoutSubviews];
    });
        
    
}

- (void)awakeFromNib
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
