//
//  CPNLoginTipsView.h
//  cepin
//
//  Created by ceping on 16/7/26.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CPNLoginCallback) (void);
@interface CPNLoginTipsView : UIView

/** 创建自定义提示窗口
 
 @param  frame 提示窗口底层视图的坐标和大小.
 @param  title 提示窗口的标题.
 @param  message 提示窗口的信息内容。
 @param  confirmBlock 提示窗口的确定按钮的回调block。
 @param  cancelBlock 提示窗口的取消按钮的回调block。
 @return void.
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message confirmBlock:(CPNLoginCallback)confirmBlock cancelBlock:(CPNLoginCallback)cancelBlock;

/** 创建自定义提示窗口，提供按钮标题
 
 @param  frame 提示窗口底层视图的坐标和大小.
 @param  title 提示窗口的标题.
 @param  message 提示窗口的信息内容。
 @param  buttonTitles 提示窗口的按钮的标题。
 @param  confirmBlock 提示窗口的确定按钮的回调block。
 @param  cancelBlock 提示窗口的取消按钮的回调block。
 @return void.
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles confirmBlock:(CPNLoginCallback)confirmBlock cancelBlock:(CPNLoginCallback)cancelBlock;

/** 显示自定义提示用户登录的窗口
 
 @return void
 */
- (void)showTips;
@end
