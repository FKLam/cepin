//
//  CPResumeInfoAddressSearchTextField.m
//  cepin
//
//  Created by ceping on 16/3/6.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeInfoAddressSearchTextField.h"

@implementation CPResumeInfoAddressSearchTextField
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        [self setClearButtonMode:UITextFieldViewModeNever];
        UIButton *clearButton = [self valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateHighlighted];
        [clearButton setFrame:CGRectMake(0, 0, 48 / 3.0, 48 / 3.0)];
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
        [clearButton setFrame:CGRectMake(0, 0, 48 / 3.0, 48 / 3.0)];
        [self setRightView:clearButton];
        [self setRightViewMode:UITextFieldViewModeWhileEditing];
    }
    return self;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGFloat leftViewWidth = 48 / 3.0 + 40 / 3.0 / 2.0;
    CGFloat leftViewHeight = 48 / 3.0 + 40 / 3.0;
    CGFloat leftViewX = 20 / 3.0;
    CGFloat leftViewY = ( bounds.size.height - leftViewHeight ) / 2.0;
    return CGRectMake(leftViewX, leftViewY, leftViewWidth, leftViewHeight);
}
- (void)setPlaceholder:(NSString *)placeholder
{
    if ( !placeholder || placeholder.length == 0 )
        return;
    NSString *tempStr = placeholder;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc] initWithString:tempStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36.0 / 3.0], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}];
    self.attributedPlaceholder = placeholderStr;
}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat textHeight = bounds.size.height;
    CGFloat textX = CGRectGetMaxX(self.leftView.frame);
    CGFloat textY = 0;
    CGFloat textMaxWidth = bounds.size.width - textX - 48 / 3.0 * 2 - 20 / 3.0;
    return CGRectMake(textX, textY, textMaxWidth, textHeight);
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGFloat clearButtonW = 48 / 3.0;
    CGFloat clearButtonH = 48 / 3.0;
    CGFloat clearButtonX = bounds.size.width - clearButtonW - 20 / 3.0;
    CGFloat clearButtonY = ( bounds.size.height - clearButtonH ) / 2.0;
    return CGRectMake(clearButtonX, clearButtonY, clearButtonW, clearButtonH);
}
@end
