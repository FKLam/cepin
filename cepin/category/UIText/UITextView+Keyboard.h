//
//  UITextView+Keyboard.h
//  御品
//
//  Created by 唐 嘉宾 on 13-4-9.
//
//

#import <UIKit/UIKit.h>
#import "UITextField+Keyboard.h"

@interface UITextView (Keyboard)
-(void)setupKeyBoardNoticafition:(BOOL)isSetup;
-(void)keyBoardWillShowOrHide:(NSNotification *)notification;


-(void)setupCancelActionBarWithBlock:(void(^)(UIBarButtonItem *item))block;

-(void)setupDoneActionBarWithBlock:(void(^)(UIBarButtonItem *item))block;

-(void)setupNextAndPreviousWithBlock:(void(^)(UISegmentedControl *Segmented , NextAndPreviousType index))SegmentedBlock cancel:(void(^)(id sender))block;
@end
