//
//  CreateResumeDialogView.h
//  cepin
//
//  Created by dujincai on 15/11/10.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateResumeDialogViewDelegate <NSObject>
- (void)clickedCancel;
-(void)clickResume:(int)tag;

@end

@interface CreateResumeDialogView : UIView

@property(nonatomic,strong)id<CreateResumeDialogViewDelegate> delegate;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *socialResumeBtn;
@property(nonatomic,strong)UIButton *schoolResumeBtn;
@property(nonatomic,strong)UIImageView *socialCheckImg;
@property(nonatomic,strong)UIImageView *schoolCheckImg;
@property(nonatomic,strong)UIButton  *cancelBtn;
-(void)initView;
-(void)show;
-(void)hide;
@end
