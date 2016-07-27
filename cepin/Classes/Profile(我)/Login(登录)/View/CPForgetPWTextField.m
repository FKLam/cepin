//
//  CPForgetPWTextField.m
//  cepin
//
//  Created by ceping on 16/3/17.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPForgetPWTextField.h"
#import "CPCommon.h"
@implementation CPForgetPWTextField
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
- (void)setPlaceholder:(NSString *)placeholder
{
    if ( !placeholder || 0 == [placeholder length] )
        return;
    NSString *tempStr = placeholder;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc] initWithString:tempStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}];
    self.attributedPlaceholder = placeholderStr;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGFloat clearButtonW = 48 / CP_GLOBALSCALE;
    CGFloat clearButtonH = 48 / CP_GLOBALSCALE;
    CGFloat clearButtonX = bounds.size.width - clearButtonW - 5.0;
    CGFloat clearButtonY = ( bounds.size.height - clearButtonH ) / 2.0;
    return CGRectMake(clearButtonX, clearButtonY, clearButtonW, clearButtonH);
}
@end
