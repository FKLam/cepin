//
//  BaseScrollViewController.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-30.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseScrollViewController : BaseViewController    
@property(nonatomic,strong) UIScrollView *scrollView;

- (void)stopKeyboardAvoiding;
@end
