//
//  CPSearchTextField.m
//  cepin
//
//  Created by ceping on 16/1/8.
//  Copyright © 2016年 talebase. All rights reserved.
//
#import "CPSearchTextField.h"
#import "CPCommon.h"
@implementation CPSearchTextField
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        [self setClearButtonMode:UITextFieldViewModeNever];
        UIButton *clearButton = [self valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateHighlighted];
        [clearButton setFrame:CGRectMake(0, 0, 48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE)];
        [self setRightView:clearButton];
        [self setRightViewMode:UITextFieldViewModeWhileEditing];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setClearButtonMode:UITextFieldViewModeNever];
        UIButton *clearButton = [self valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateHighlighted];
        [clearButton setFrame:CGRectMake(0, 0, 48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE)];
        [self setRightView:clearButton];
        [self setRightViewMode:UITextFieldViewModeWhileEditing];
    }
    return self;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGFloat leftViewWidth = 48 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE / 2.0;
    CGFloat leftViewHeight = 48 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    CGFloat leftViewX = 20 / CP_GLOBALSCALE;
    CGFloat leftViewY = ( bounds.size.height - leftViewHeight ) / 2.0;
    return CGRectMake(leftViewX, leftViewY, leftViewWidth, leftViewHeight);
}
- (void)setPlaceholder:(NSString *)placeholder
{
    if ( !placeholder || placeholder.length == 0 )
        return;
    NSString *tempStr = placeholder;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc] initWithString:tempStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}];
    self.attributedPlaceholder = placeholderStr;
}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat textHeight = bounds.size.height;
    CGFloat textX = CGRectGetMaxX(self.leftView.frame);
    CGFloat textY = 0;
    CGFloat textMaxWidth = bounds.size.width - textX - 20 / CP_GLOBALSCALE;
    return CGRectMake(textX, textY, textMaxWidth, textHeight);
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGFloat clearButtonW = 48 / CP_GLOBALSCALE;
    CGFloat clearButtonH = 48 / CP_GLOBALSCALE;
    CGFloat clearButtonX = bounds.size.width - clearButtonW - 40 / CP_GLOBALSCALE;
    CGFloat clearButtonY = ( bounds.size.height - clearButtonH ) / 2.0;
    return CGRectMake(clearButtonX, clearButtonY, clearButtonW, clearButtonH);
}
@end
