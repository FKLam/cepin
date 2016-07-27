//
//  FullMenuView.h
//  cepin
//
//  Created by dujincai on 15-4-9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FullMenuViewDelegate <NSObject>

-(void)didResumeMenuTouch:(int)index;

@end

@interface FullMenuView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)id<FullMenuViewDelegate> delegate;

-(void)startApper;
-(void)startDisapper;

@end
