//
//  CPSearchWithRightTextField.m
//  cepin
//
//  Created by dujincai on 16/3/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchWithRightTextField.h"
#import "CPCommon.h"
@implementation CPSearchWithRightTextField
CGFloat tempScale = 3.0;
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        [self setClearButtonMode:UITextFieldViewModeNever];
        UIButton *clearButton = [self valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateHighlighted];
        [clearButton setFrame:CGRectMake(0, 0, 48 / tempScale, 48 / tempScale)];
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
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        UIButton *clearButton = [self valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"input_ic_cancel"] forState:UIControlStateHighlighted];
        [clearButton setContentMode:UIViewContentModeCenter];
//        [clearButton setFrame:CGRectMake(0, 0, 56 / tempScale, 56 / tempScale)];
//        [self setRightView:clearButton];
//        [self setRightViewMode:UITextFieldViewModeWhileEditing];
        [self setValue:clearButton forKey:@"_clearButton"];
    }
    return self;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGFloat leftViewWidth = 30.0 - 20 / CP_GLOBALSCALE;
    CGFloat leftViewHeight = 30.0;
    CGFloat leftViewX = 20 / CP_GLOBALSCALE;
    CGFloat leftViewY = ( bounds.size.height - leftViewHeight ) / 2.0;
    return CGRectMake(leftViewX, leftViewY, leftViewWidth, leftViewHeight);
}
- (void)setPlaceholder:(NSString *)placeholder
{
    if ( !placeholder || placeholder.length == 0 )
        return;
    NSString *tempStr = placeholder;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc] initWithString:tempStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36.0 / ( 3.0 * ( 1 / 1.29 ) )], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}];
    self.attributedPlaceholder = placeholderStr;
}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat textHeight = bounds.size.height;
    CGFloat textX = CGRectGetMaxX(self.leftView.frame);
    CGFloat textY = 1.5;
    CGFloat textMaxWidth = bounds.size.width - textX - 20 / CP_GLOBALSCALE - 30.0;
    return CGRectMake(textX, textY, textMaxWidth, textHeight);
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
//    CGFloat clearButtonW = 48 / tempScale;
//    CGFloat clearButtonH = 48 / tempScale;
//    CGFloat clearButtonX = bounds.size.width - clearButtonW - 30 / CP_GLOBALSCALE;
//    CGFloat clearButtonY = ( bounds.size.height - clearButtonH ) / 2.0;
//    return CGRectMake(clearButtonX, clearButtonY, clearButtonW, clearButtonH);
    CGFloat scale = 0.8;
    if ( !CP_IS_IPHONE_6 || !CP_IS_IPHONE_6P )
    {
        scale = 0.7;
    }
    CGFloat clearButtonW = 30.0 * scale;
    CGFloat clearButtonH = 30.0 * scale;
    CGFloat clearButtonX = bounds.size.width - clearButtonW - 30 / CP_GLOBALSCALE;
    CGFloat clearButtonY = ( bounds.size.height - clearButtonH ) / 2.0;
    return CGRectMake(clearButtonX, clearButtonY, clearButtonW, clearButtonH);
}
//- (CGRect)rightViewRectForBounds:(CGRect)bounds
//{
//    CGFloat scale = 0.8;
//    if ( !CP_IS_IPHONE_6 || !CP_IS_IPHONE_6P )
//    {
//        scale = 0.7;
//    }
//    CGFloat clearButtonW = 30.0 * scale;
//    CGFloat clearButtonH = 30.0 * scale;
//    CGFloat clearButtonX = bounds.size.width - clearButtonW - 30 / CP_GLOBALSCALE;
//    CGFloat clearButtonY = ( bounds.size.height - clearButtonH ) / 2.0;
//    return CGRectMake(clearButtonX, clearButtonY, clearButtonW, clearButtonH);
//}
@end
