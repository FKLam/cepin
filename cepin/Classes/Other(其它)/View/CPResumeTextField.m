//
//  CPResumeTextField.m
//  cepin
//
//  Created by ceping on 15/12/1.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "CPResumeTextField.h"

@implementation CPResumeTextField

/** 重写placeholder的setter方法 */
- (void)setPlaceholder:(NSString *)placeholder
{
    
#pragma mark - 修改textfield的placeholder字体的颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance]labelColorGreen]}];
    self.attributedPlaceholder = attStr;
}

@end
