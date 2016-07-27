//
//  ResumeSendView.h
//  cepin
//
//  Created by zhu on 15/3/24.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXSCycleScrollView.h"

@protocol ResumeSendViewDelegate <NSObject>

@optional
-(void)clickLevelEnsureButton:(NSString*)str IsComplete:(BOOL)canSend;
-(void)clickManager;

@end

@interface ResumeSendView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *chooseTitle;
//    MXSCycleScrollView *ScrollView;
    NSMutableArray *datas;
//    UIPickerView   *dataView;
    
}

@property(nonatomic,strong)id<ResumeSendViewDelegate> delegate;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIButton *maskButton;
@property(nonatomic,retain)NSString *resumeId;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger currentSelectView;
@property(nonatomic,strong)UIButton *ensureButton;
@property(nonatomic,assign)BOOL isCanSend;
-(void)setCurrentDatas:(NSMutableArray*)allDatas;



@end
