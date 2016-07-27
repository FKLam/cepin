//
//  FullResumeMenuView.h
//  cepin
//
//  Created by dujincai on 15-4-24.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FullResumeMenuViewDelegate <NSObject>

-(void)didFullResumeMenuTouch:(int)index;

@end

@interface FullResumeMenuView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)id<FullResumeMenuViewDelegate> delegate;

-(void)startApper;
-(void)startDisapper;
@end
