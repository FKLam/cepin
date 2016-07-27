//
//  BaseViewController+otherUI.h
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    
    BottomButtonColorOrange,
    BottomButtonColorWhite,
    
}BottomButtonColor;


@interface BaseViewController (otherUI)

-(UIButton *)bottomButtonWithTitle:(NSString *)title;

-(UIButton *)bottomButtonWithTitle:(NSString *)title color:(BottomButtonColor)color;
@end
