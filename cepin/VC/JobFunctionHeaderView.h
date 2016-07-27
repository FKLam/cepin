//
//  JobFunctionHeaderView.h
//  cepin
//
//  Created by dujincai on 15/6/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JobFunctionHeaderView;
@protocol JobFunctionHeaderViewDelegate <NSObject>

-(void)selectedWith:(JobFunctionHeaderView *)view;


@end

@interface JobFunctionHeaderView : UIView
@property(nonatomic,strong)UILabel *jobName;
@property(nonatomic,strong)UIImageView *arrowImage;
@property(nonatomic,strong)UIButton *clickButton;
@property(nonatomic,strong)UILabel *labelSub;
@property(nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL open;//开 关
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)id <JobFunctionHeaderViewDelegate>delegate;

- (void)configJobName:(NSString *)jobName;
-(void)configureLableSubText:(NSString*)text;
-(void)resetLine;
@end
