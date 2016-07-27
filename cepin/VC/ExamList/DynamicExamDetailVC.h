//
//  DynamicExamDetailVC.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseViewController.h"
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
@interface MyHYBJsObjCModel : NSObject <JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, assign) BOOL isMsgCepin;//标记是否来自我的消息的测评

@end
typedef enum {
    examDetailFirst,
    examDetailOther
}examDetail;

@interface DynamicExamDetailVC : BaseViewController
@property(nonatomic)examDetail examDetail;
@property(nonatomic,retain)NSString* strTitle;
@property(nonatomic,retain)NSString* urlPath;
@property(nonatomic,retain)NSString* urlLogo;
@property(nonatomic,retain)NSString* contentText;
@property(nonatomic,assign)BOOL isJiSuCepin;
@property (nonatomic,assign)BOOL isMsgCepin;//判断是否来自信息页面的测评

-(instancetype)initWithUrl:(NSString*)url examDetail:(examDetail)examDetail;
-(instancetype)initWithUrl:(NSString*)url examDetail:(examDetail)examDetail noTarget:(Boolean)noTarget;

@end
