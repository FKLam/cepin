//
//  DynamicWebVC.h
//  cepin
//
//  Created by zhu on 15/2/12.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjectiveCDelegate <JSExport>

- (void)searchOnAndroid:(NSString *)searchKey;

- (void)postOnAndroid:(NSString *)params;

- (void)companyOnAndroid:(NSString *)companyId;

//	跳转到我的测评中心
- (void)toInviteCepinList;

@end

// 此模型用于注入JS的模型，这样就可以通过模型来调用方法。
@interface HYBJsObjCModel : NSObject<JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;

@end



@interface DynamicWebVC : BaseTableViewController

@property(nonatomic,retain)NSString* strTitle;
@property(nonatomic,retain)NSString* urlPath;
@property(nonatomic,retain)NSString* urlLogo;
@property(nonatomic,retain)NSString* contentText;

-(instancetype)initWithTitleAndlUrl:(NSString*)title url:(NSString*)urlString;
-(instancetype)initWithFullUrl:(NSString*) url title:(NSString*)title;
- (instancetype)initWithFullUrl:(NSString *)url title:(NSString *)title isBigADCome:(BOOL)isBigADCome;
@end
