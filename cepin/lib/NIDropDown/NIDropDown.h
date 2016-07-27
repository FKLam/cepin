//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
@optional;
-(void) niDropDownDelegateMethod:(NIDropDown *)sender index:(NSInteger)index;

-(void)niDropDownMenuWillDisplay:(NIDropDown *)sender;

-(NSInteger)numberOfRowWithView:(NIDropDown *)sender;

-(NSString *)dropDownView:(NIDropDown *)view index:(NSInteger)index;

-(id)dropDownObjec:(NSIndexPath *)indexPath data:(NSArray*)datas;

@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) NSObject <NIDropDownDelegate> *delegate;
@property(nonatomic, strong) NSArray *list;
@property(nonatomic,assign)BOOL isCanTap;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)UIButton  *maskButton;

-(void)hideDropDown;
-(void)hideDropDown:(UIButton *)b;
-(id)initShowDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr;

-(instancetype)initShowDropDown:(CGRect)showRect inView:(UIView *)view changeView:(UIView *)changeView height:(CGFloat)height titles:(NSArray *)arr;
-(void)hideDropDown:(UIButton *)b rect:(CGRect)rect;
-(void)hideDropDownWithView:(UIView *)b rect:(CGRect)rect;

-(void)reloadData;

@end
