//
//  CPFeedBackPhoneTextField.m
//  cepin
//
//  Created by ceping on 16/2/16.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPFeedBackPhoneTextField.h"
#import "CPCommon.h"
#import "NSString+Extension.h"
@implementation CPFeedBackPhoneTextField
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGFloat leftViewWidth = 40 / CP_GLOBALSCALE;
    CGFloat leftViewHeight = bounds.size.height;
    CGFloat leftViewX = 0;
    CGFloat leftViewY = 0;
    return CGRectMake(leftViewX, leftViewY, leftViewWidth, leftViewHeight);
}
- (void)setPlaceholder:(NSString *)placeholder
{
    if ( !placeholder || placeholder.length == 0 )
        return;
    NSString *tempStr = placeholder;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc] initWithString:tempStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]}];
    self.attributedPlaceholder = placeholderStr;
}
@end
