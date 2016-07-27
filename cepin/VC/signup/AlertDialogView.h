//
//  AlertDialogView.h
//  cepin
//
//  Created by dujincai on 15/12/9.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertDialogView : UIView
@property(nonatomic,strong)UIButton *accountExitsBg;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic)SEL sureSelector;
@property(nonatomic,strong)id target;
@property(nonatomic,assign)BOOL isCepinView;

-(void)Show;
- (void)showCancelButton;
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title content:(NSString*)content selector:(SEL)selector target:(id)target;
-(instancetype)initWithFrame:(CGRect)frame selector:(SEL)selector target:(id)target;
@end
