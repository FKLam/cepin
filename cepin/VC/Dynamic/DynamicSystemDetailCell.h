//
//  DynamicSystemDetailCell.h
//  cepin
//
//  Created by ceping on 14-12-29.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RTLabel.h"



@interface DynamicSystemDetailCell : UITableViewCell<UIWebViewDelegate>

@property(nonatomic,retain)UILabel *lableTitle;
@property(nonatomic,retain)UILabel *lableTime;
@property(nonatomic,retain)UIView  *lineView;
@property(nonatomic,strong)UIWebView *webView;

+(int)computerCellHeight:(NSString*)strTitle;
-(void)loadHtmlString:(NSString*)str;
@end
