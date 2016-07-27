//
//  JobDetailDiscripCell.h
//  cepin
//
//  Created by ceping on 15-1-22.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "TKRoundedView.h"

@interface JobDetailDiscripCell : UITableViewCell<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic)int height;
-(void)loadHtmlString:(NSString*)str;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
