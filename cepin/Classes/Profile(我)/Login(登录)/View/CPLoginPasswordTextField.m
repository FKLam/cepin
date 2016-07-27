//
//  CPLoginPasswordTextField.m
//  cepin
//
//  Created by ceping on 16/3/4.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPLoginPasswordTextField.h"
#import <objc/runtime.h>
#import "CPCommon.h"
@implementation CPLoginPasswordTextField
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
- (void)clickedClearButton:(UIButton *)sender
{
    [self setText:@""];
}
- (void)clickedLookPWBtn:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [self setSecureTextEntry:!sender.isSelected];
    [self becomeFirstResponder];
}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat textHeight = bounds.size.height;
    CGFloat textX = bounds.origin.x;
    CGFloat textY = 0;
    CGFloat textMaxWidth = bounds.size.width - 48 / CP_GLOBALSCALE;
    return CGRectMake(textX, textY, textMaxWidth, textHeight);
}
- (void)setPlaceholder:(NSString *)placeholder
{
    if ( !placeholder || 0 == [placeholder length] )
        return;
    NSString *tempStr = placeholder;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc] initWithString:tempStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}];
    self.attributedPlaceholder = placeholderStr;
}
@end
