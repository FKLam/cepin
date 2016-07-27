//
//  ResumeMenuView.h
//  cepin
//
//  Created by ceping on 15-3-11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResumeMenuDelegate <NSObject>

-(void)didResumeMenuTouch:(NSUInteger)index;

@end

@interface ResumeMenuView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)id<ResumeMenuDelegate> delegate;

-(void)startApper;
-(void)startDisapper;

@end
