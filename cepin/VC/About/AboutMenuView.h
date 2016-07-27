//
//  AboutMenuView.h
//  cepin
//
//  Created by dujincai on 15/5/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AboutMenuViewDelegate <NSObject>

- (void)didTouchAboutMenue:(int)index;

@end


@interface AboutMenuView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)id <AboutMenuViewDelegate>aboutDelegate;
-(void)startApper;
-(void)startDisapper;
@end
