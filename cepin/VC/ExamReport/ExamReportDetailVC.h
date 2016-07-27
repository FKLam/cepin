//
//  ExamReportDetailVC.h
//  cepin
//
//  Created by dujincai on 15/7/1.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjectiveCDelegate <JSExport>

- (void)searchOnAndroid:(NSString *)searchKey;

- (void)postOnAndroid:(NSString *)params;

- (void)companyOnAndroid:(NSString *)companyId;

//	点击m端的查看报告查看极速测评报告
- (void)checkReportOnAndroid;

//	职业测评的信息确认页
- (void)editUserInfoOnAndroid;
//	职业测评做题页
- (void)editExamOnAndroid;
//	跳转到我的测评中心
- (void)toInviteCepinList;

@end

// 此模型用于注入JS的模型，这样就可以通过模型来调用方法。
@interface MyBJsObjCModel : NSObject <JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;

@end


@interface ExamReportDetailVC : BaseTableViewController
-(instancetype)initWithUrl:(NSString*)url;
@end
