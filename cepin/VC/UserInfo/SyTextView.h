//
//  SyTextView.h
//  SyTextViewApp
//
//  Created by yangjie on 14-9-23.
//  Copyright (c) 2014年 yangjie. All rights reserved.
//

//
//  监控输入法的切换，限制用户输入字数
//
//  因为拼音输入的过程中，会调用textDidChange，而此时的
//
//  文字尚未输入，只是占据着位置，如果常规限制输入字数的情况下
//
//  写代码的时候可能会在这个地方截取，稍不注意就会引起crash,下面是
//
//  解决办法

#import <UIKit/UIKit.h>

@interface SyTextView : UITextView

// 限制的字数
@property NSInteger numOfTextLimit;

// 限制用户的输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextRange:(NSRange)range replacementText:(NSString *)text;

// textDidChange监控
- (void)textDidChange;
@end

