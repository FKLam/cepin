//
//  UITextField+Keyboard.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-24.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NextAndPreviousTypePrevious=0,
    NextAndPreviousTypeNext,
}NextAndPreviousType;

@interface UITextField (Keyboard)

-(void)setupCancelActionBarWithBlock:(void(^)(UIBarButtonItem *item))block;

-(void)setupDoneActionBarWithBlock:(void(^)(UIBarButtonItem *item))block;

-(void)setupDoneActionBarWithTitle:(NSString *)title block:(void (^)(UIBarButtonItem *))block;

-(void)setupNextAndPreviousWithBlock:(void(^)(UISegmentedControl *Segmented , NextAndPreviousType index))SegmentedBlock cancel:(void(^)(id sender))block;
@end
