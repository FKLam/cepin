//
//  UmengView.h
//  cepin
//
//  Created by zhu on 15/1/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UmengViewDelegate <NSObject>

-(void)didChooseUmengView:(int)tag;

@end

@interface UmengView : UIView

@property(nonatomic,assign)id<UmengViewDelegate>delegate;

-(void)show;
-(void)disMiss;

@end
