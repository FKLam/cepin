//
//  FeedBackVC.h
//  cepin
//
//  Created by dujincai on 15/11/6.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface FeedBackVC : BaseTableViewController
@property(nonatomic,strong)UILabel *accountLabel;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UILabel *adviceLabel;
@property(nonatomic,strong)UITextView *adviceTextView;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)NSString *emailOrPhone;
@property(nonatomic,strong)NSString *adviceContent;

@end
