//
//  BaseViewController.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-5.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSUserDefaults+UserData.h"


typedef enum {
    ReflashButtonTypeNormalNoData = 100,
    ReflashButtonTypeNoStoreData,
    ReflashButtonTypeNoBookingTime,
    ReflashButtonTypeNoTradeListData,
    ReflashButtonTypeNoCoupon,
    ReflashButtonTypeNoComment,
    ReflashButtonTypeNoMineTrade,
    ReflashButtonTypeNoMineCoupon,
    ReflashButtonTypeNoInvite,
}ReflashButtonType;

@class RTReflashButton;
@interface BaseViewController : UIViewController<UIAlertViewDelegate>
{
    NSUserDefaults *_userDefaults;
}
@property(nonatomic,strong)IBOutlet RTReflashButton *buttonReflesh;
@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *activityView;
@property(nonatomic,strong)UIImageView *networkImage;
@property(nonatomic,strong)UILabel *networkLabel;
@property(nonatomic,strong)UIButton *networkButton;
@property(nonatomic,strong)UIImageView *clickImage;
-(id)initWithDictionary:(NSDictionary *)dic;
-(id)initWithObject:(id)object;

-(void)setupCancelTextFieldFocusTap;
-(void)cancelTextFieldFocusTapRecognizer:(UIGestureRecognizer *)recognizer;

- (NSInteger)requestStateWithStateCode:(id)stateCode;

-(void)memoryRelease;

- (void)noNetwork;

-(void)alertWithMessage:(NSString *)msg;

-(void)alertCancelWithMessage:(NSString *)msg;

- (void)clickNetWorkButton;
@end


