//
//  SyTextView.m
//  SyTextViewApp
//
//  Created by yangjie on 14-9-23.
//  Copyright (c) 2014年 yangjie. All rights reserved.
//

#import "SyTextView.h"

@implementation SyTextView

- (BOOL)textView:(UITextView *)textView shouldChangeTextRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.numOfTextLimit > 0) {
        
        if (range.length == 0 && textView.text.length > self.numOfTextLimit - 1) {
            return NO;
        }
    }
    return YES;
}

- (void)textDidChange {
    
    NSArray *array = [UITextInputMode activeInputModes];
    
    NSLog(@"textDidChange  array.description => %@", [array description]);
    
    if (array.count > 0) {
    
        UITextInputMode *textInputMode = [array firstObject];
        NSString *lang = [textInputMode primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) {
            if (self.text.length != 0) {
            
                int a = [self.text characterAtIndex:self.text.length - 1];
                if( a > 0x4e00 && a < 0x9fff) { // PINYIN 手写的时候 才做处理
                    if (self.text.length >= self.numOfTextLimit) {
                        self.text = [self.text substringToIndex:self.numOfTextLimit];
                    }
                }
            }
        } else {
            if (self.text.length >= self.numOfTextLimit) {
                self.text = [self.text substringToIndex:self.numOfTextLimit];
            }
        }
    }
}

- (void)paste:(id)sender {
    [super paste:sender];
    
    if (self.text.length > self.numOfTextLimit) {
        self.text = [self.text substringToIndex:self.numOfTextLimit];
    }
}
@end
