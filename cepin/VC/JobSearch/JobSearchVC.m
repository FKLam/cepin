//
//  JobSearchVC.m
//  cepin
//
//  Created by ricky.tang on 14-10-17.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobSearchVC.h"
#import "UIViewController+NavicationUI.h"
#import "TKRoundedView.h"
#import "NIDropDown.h"
#import "JobSearchVM.h"
#import "TKRoundedView.h"
#import "BaseViewController+otherUI.h"
#import "JobSearchTitleCell.h"
#import "JobSearchContentCell.h"
#import "BaseViewController+otherUI.h"
#import "JobDetailVC.h"
#import "NewJobDetialVC.h"
#import "JobSearchResultVC.h"
#import "AlertDialogView.h"
#import "TBAppDelegate.h"
#import "CPSearchHeaderView.h"
#import "CPSearchHistoryHeaderView.h"
#import "CPSearchHistoryCell.h"
#import "CPSearchHistoryFooterView.h"
#import "CPSearchFuzzaMatchCell.h"
#import "RTNetworking+Position.h"
#import "HotSearchKeyModel.h"
#import "CPSearchMatchDTO.h"
#import "CPSearchDefaultBean.h"
#import "CPSearchWithRightTextField.h"
#import "CPCommon.h"
@interface JobSearchVC ()<NIDropDownDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)CPSearchWithRightTextField *textSearch;
@property(nonatomic,strong)JobSearchVM *viewModel;
@property(nonatomic,strong)FUILineButton *buttonClear;
@property(nonatomic,strong)UIView      *clearView;
@property(nonatomic,strong)AlertDialogView *alertView;
@property (nonatomic, strong) CPSearchHeaderView *searchHeardView;
@property (nonatomic, strong) CPSearchHistoryHeaderView *searchHistoryHeaderView;
@property (nonatomic, strong) CPSearchHistoryFooterView *searchHistoryFooterView;
@property (nonatomic, strong) UITableView *searchMatchTableView;
@property (nonatomic, copy) NSArray *tempSearchMatchArray;
@property (nonatomic, copy) NSString *matchString;
@property(nonatomic,strong) NSMutableArray *keyArray;
@property(nonatomic,strong) UIView  *bindTipsView;
@property(nonatomic,strong)NSString *defalutSearchKey;//默认的搜索热词
@property(nonatomic,assign)BOOL isLoading;//正在加载数据
@property (nonatomic, strong) UIView *noNetworkView;
@property(nonatomic,assign)BOOL isLoad;
@property(nonatomic,strong)TBLoading *load;

@end
@implementation JobSearchVC
- (instancetype)initWithKeyWord:(NSString *)keyWord
{
    self = [super init];
    if (self) {
        self.viewModel = [JobSearchVM new];
        self.viewModel.keyword = keyWord;
    }
    return self;
}
- (instancetype)initWithKeyWord:(NSString *)keyWord city:(NSString *)city JobFunction:(NSString *)JobFunction Salary:(NSString *)Salary PositionType:(NSString *)PositionType EmployType:(NSString *)EmployType WorkYear:(NSString *)WorkYear Degree:(NSString *)Degree{
    self = [super init];
    if (self) {
        self.viewModel = [JobSearchVM new];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    self.textSearch = [self.parentViewController addNavicationBarCenterSearchBar];
    self.textSearch.delegate = self;
    self.textSearch.returnKeyType = UIReturnKeySearch;
    self.textSearch.placeholder =  self.defalutSearchKey;
    self.tableView.hidden = NO;
    self.viewModel.keywords = [KeywordModel allKeywords];
    if(!self.viewModel.keywords)
    {
        self.viewModel.keywords = [NSMutableArray array];
    }
    [self.tableView reloadData];
    if (self.viewModel.keywords.count == 0) {
        _searchHistoryFooterView.clearSearchHistoryButton.hidden = YES;
    }else {
        _searchHistoryFooterView.clearSearchHistoryButton.hidden = NO;
    }
    [self.searchHeardView setHidden:NO];
    if (self.tempSearchMatchArray && [self.tempSearchMatchArray count]>0) {
        self.tempSearchMatchArray = [[NSArray alloc]init];
        [self.searchMatchTableView reloadData];
    }
    self.searchMatchTableView.hidden = YES;
    //搜索编辑监听
    [self.textSearch.rac_textSignal subscribeNext:^(NSString *text) {
        self.matchString = text;
        [self searMatch:text];
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark 获取默认的搜索关键字
-(void)getSearDefault
{
    RACSignal *signal = [[RTNetworking shareInstance]getSearchDefaultKey];
    [signal subscribeNext:^(RACTuple *racResult) {
        NSDictionary *dict = (NSDictionary *)racResult.second;
        if([dict resultSucess])
        {
            NSArray *dada = [dict resultObject];
            if( dada )
            {
               CPSearchDefaultBean *searchDefault =  [CPSearchDefaultBean beanFromDictionary:dada[0]];
                if (searchDefault) {
                    self.defalutSearchKey = searchDefault.Title;
                     self.textSearch.placeholder =  self.defalutSearchKey;
                }
            }
        }else{
            [self.noNetworkView setHidden:NO];
        }
    }error:^(NSError *error){
         [self.noNetworkView setHidden:NO];
    }];
}
-(instancetype)init
{
    if (self = [super init]) {
        self.viewModel = [JobSearchVM new];
    }
    return self;
}
- (UIView *)noNetworkView
{
    if ( !_noNetworkView )
    {
        _noNetworkView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_noNetworkView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"null_exam_linkbroken"]];
        [_noNetworkView addSubview:errorImageView];
        [errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _noNetworkView.mas_centerX );
            make.top.equalTo( _noNetworkView.mas_top ).offset( 366 / CP_GLOBALSCALE );
            make.width.equalTo( @( 280 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 280 / CP_GLOBALSCALE ) );
        }];
        UILabel *tipsLabel = [[UILabel alloc] init];
        [_noNetworkView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _noNetworkView.mas_centerX );
            make.top.equalTo( errorImageView.mas_bottom ).offset( 90 / CP_GLOBALSCALE );
            make.left.equalTo( _noNetworkView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _noNetworkView.mas_right ).offset( -40 / CP_GLOBALSCALE);
        }];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.text = @"当前网络不可用，请检查网络设置";
        tipsLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
        tipsLabel.textColor = [UIColor colorWithHexString:@"404040"];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [tipsLabel setNumberOfLines:0];
        UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [reloadButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        [reloadButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
        [reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateSelected];
        [reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [reloadButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [reloadButton.layer setMasksToBounds:YES];
        [reloadButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_noNetworkView addSubview:reloadButton];
        [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _noNetworkView.mas_centerX );
            make.top.equalTo( tipsLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.width.equalTo( @( 330 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
        }];
        [reloadButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (!self.isLoad) {
                self.load = [TBLoading new];
                [self.load start];
                self.isLoad = YES;
            }
           [self getSearchHotListKey];
            [self getSearDefault];
        }];
        [_noNetworkView setHidden:YES];
    }
    return _noNetworkView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //统计加载搜索
    [MobClick event:@"search"];
    [MobClick event:@"searchPage"];
    [MobClick event:@"search_position_launch"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:self.searchHeardView];
    [self getSearchHotListKey];
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchHeardView.frame), self.view.viewWidth, self.view.viewHeight - self.searchHeardView.viewHeight - (CP_IS_IPHONE_6P ? 55.0 : 49.0)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableHeaderView = self.searchHistoryHeaderView;
    self.tableView.tableFooterView = self.searchHistoryFooterView;
    [self.tableView setShowsVerticalScrollIndicator:YES];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 144 / CP_GLOBALSCALE, 0)];
    [self.view addSubview:self.tableView];
    if(!self.viewModel.keywords){
        self.viewModel.keywords = [NSMutableArray array];
    }
    [self.tableView reloadData];
    [self.searchHistoryHeaderView setHidden:NO];
    [self.view addSubview:self.searchMatchTableView];
    //获取默认搜索热词
    [self getSearDefault];
    [self.view addSubview:self.noNetworkView];
    [self getSearchHotListKey];
//    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClick)];
//    [self.view addGestureRecognizer:ges];
}
-(void)getSearchHotListKey
{
    if(nil!=self.keyArray && self.keyArray.count>0){
        return;
    }
    RACSignal *signal = [[RTNetworking shareInstance]getHotSearchKeyListWithPageSize:10];
    [signal subscribeNext:^(RACTuple *racResult) {
        NSDictionary *dict = (NSDictionary *)racResult.second;
        if (self.load)
        {
            [self.load stop];
        }
        if([dict resultSucess])
        {
            NSArray *array = [dict resultObject];
            if( array )
            {
                self.keyArray = [NSMutableArray arrayWithCapacity:array.count];
                for (int i = 0;i<array.count; i++) {
                    HotSearchModel *hotSearchKey = [HotSearchModel beanFromDictionary:array[i]];
                    [self.keyArray addObject:hotSearchKey.Name];
                }
                [self.searchHeardView configHotButtonWithTitles:self.keyArray target:self selector:@selector(clickHotkey:)];
                [self.noNetworkView setHidden:YES];
            }
        }else{
            
        [self.noNetworkView setHidden:NO];
        }
    }error:^(NSError *error){
        if (self.load)
        {
            [self.load stop];
        }
        [self.noNetworkView setHidden:NO];
    }];
}
#pragma 热门搜索点击事件
-(void)clickHotkey:(UIButton *)btn{
    [self.textSearch endEditing:YES];
    [MobClick event:@"choose_work_remeng"];
    NSInteger tag = btn.tag;
    NSString *name = self.keyArray[tag];
    //保存关键字
    NSString *tempUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    [KeywordModel saveKeywordWith:name userID:tempUserID];
    JobSearchResultVC *vc = [[JobSearchResultVC alloc] initWithKeyWord:name];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clearHistory{
    self.alertView.hidden = YES;
    [self.viewModel deleteAllKeywords];
    [self.tableView reloadData];
    [self.viewModel.keywords removeAllObjects];
    
    [self.tableView reloadData];
    _searchHistoryFooterView.clearSearchHistoryButton.hidden = YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self.viewModel deleteAllKeywords];
        [self.tableView reloadData];
        self.tableView.hidden = YES;
    }
}
- (void)didClick
{
    [self.textSearch resignFirstResponder];
    if (self.viewModel.keywords.count > 0) {
        self.tableView.hidden = NO;
    }else{
        self.tableView.hidden = YES;
    }
    if ( self.searchHeardView.hidden )
    {
        self.searchHeardView.hidden = NO;
        [MobClick event:@"choose_work_start_window"];
    }
    if ( !self.searchMatchTableView.hidden)
        self.searchMatchTableView.hidden = YES;
    self.tempSearchMatchArray = [[NSArray alloc]init];
    [self.searchMatchTableView reloadData];
}
//手势和uitableview冲突点不了。实现该方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
-(void)refleshTable
{
    [self.viewModel reflashPage];
}
-(void)updateTable
{
    [self.viewModel nextPage];
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.tableView )
    {
        if (self.viewModel.keywords.count > 0 && self.viewModel.keywords.count <= 5) {
            return self.viewModel.keywords.count;
        }
        else if (self.viewModel.keywords.count > 5) {
            return 5;
        }
        return 0;
    }
    else if ( tableView == self.searchMatchTableView )
    {
        return [self.tempSearchMatchArray count];
    }
    else
        return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.tableView )
    {
        CPSearchHistoryCell *cell = [CPSearchHistoryCell searchHistoryCellWithTableView:tableView];
        [self.viewModel sort];
        KeywordModel *model = self.viewModel.keywords[indexPath.row];
        BOOL hideSeparator = indexPath.row == self.viewModel.keywords.count - 1;
        [cell configWithKeywordModel:model hideSeparator:hideSeparator];

        [cell.deleteView handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            //删除item
            [self.viewModel deleteKeyWord:model.keyword];
            [self.viewModel.keywords removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            if ( [self.viewModel.keywords count] == 0 )
            {
                _searchHistoryFooterView.clearSearchHistoryButton.hidden = YES;
            }
        }];
        return cell;
    }
    else if ( tableView == self.searchMatchTableView )
    {
        CPSearchFuzzaMatchCell *cell = [CPSearchFuzzaMatchCell searchHistoryCellWithTableView:tableView];
        SearchMatch *hotSearchKey = [SearchMatch beanFromDictionary: [self.tempSearchMatchArray objectAtIndex:indexPath.row]];
        [cell configWithKeywordModel:hotSearchKey matchText:self.matchString hideSeparator:NO];
        return cell;
    }
    return nil;
}
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.tableView )
    {
        //统计
        [MobClick event:@"search_history_click"];
        KeywordModel *model = [self.viewModel.keywords objectAtIndex:indexPath.row];
        self.textSearch.text = model.keyword;
        //保存关键字
        NSString *tempUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
        [KeywordModel saveKeywordWith:model.keyword userID:tempUserID];
        JobSearchResultVC *vc = [[JobSearchResultVC alloc] initWithKeyWord:model.keyword];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( tableView == self.searchMatchTableView )
    {   //统计
        //搜索框关联文件搜索
        [MobClick event:@"search_history_click"];
        SearchMatch *hotSearchKey = [SearchMatch beanFromDictionary: [self.tempSearchMatchArray objectAtIndex:indexPath.row]];
        NSString *searchMatchTitle = hotSearchKey.Keyword;
        //保存关键字
        NSString *tempUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
        [KeywordModel saveKeywordWith:searchMatchTitle userID:tempUserID];
        self.searchMatchTableView.hidden = YES;
        JobSearchResultVC *vc = [[JobSearchResultVC alloc] initWithKeyWord:searchMatchTitle];
        [self.navigationController pushViewController:vc animated:YES];
        [self.textSearch resignFirstResponder];
        self.tempSearchMatchArray = [[NSArray alloc]init];
        [self.searchMatchTableView reloadData];
        [MobClick event:@"choose_work_window_click"];
    }
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [MobClick event:@"do_search"];
//    self.tableView.hidden = YES;
//    self.searchHeardView.hidden = YES;
//    self.searchMatchTableView.hidden = NO;
}
#pragma mark 搜索模糊搜索
-(void)searMatch:(NSString*)searchKey
{
    if (!searchKey || [searchKey isEqualToString:@""] || NULL==searchKey || nil == searchKey) {
        self.tempSearchMatchArray = [[NSArray alloc] init];
        [self.searchMatchTableView reloadData];
         self.searchMatchTableView.hidden = YES;
        [self.tableView setHidden:NO];
        self.searchHeardView.hidden = NO;
        return;
    }
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    RACSignal *signal = [[RTNetworking shareInstance]getMartchSearchKeyListWithPageSize:10 searchKey:searchKey];
    [signal subscribeNext:^(RACTuple *racResult) {
        NSDictionary *dict = (NSDictionary *)racResult.second;
        if([dict resultSucess])
        {
            NSArray *array = [dict resultObject];
            if( array )
            {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0;i<array.count; i++) {
                    SearchMatch *hotSearchKey = [SearchMatch beanFromDictionary:array[i]];
                    [tempArray addObject:hotSearchKey];
                }
                self.searchMatchTableView.hidden = NO;
                self.tempSearchMatchArray =[tempArray copy];
                [self.searchMatchTableView reloadData];
            }
        }
        self.isLoading = NO;
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.textSearch endEditing:YES];
    [self.searchMatchTableView setHidden:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textSearch endEditing:YES];
    if (![self isBlankStr:textField.text])
    {
        for (KeywordModel*item in self.viewModel.keywords) {
            if ([textField.text isEqualToString:item.keyword]) {
                [self.viewModel.keywords removeObject:item];
                break;
            }
        }
        //保存关键字
        NSString *tempUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
        [KeywordModel saveKeywordWith:textField.text userID:tempUserID];
        self.viewModel.keyword = textField.text;
        JobSearchResultVC *vc = [[JobSearchResultVC alloc] initWithKeyWord:textField.text];
        [self.navigationController pushViewController:vc animated:YES];
        [self didClick];
    }
    else
    {
        //保存关键字
        NSString *tempUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
        [KeywordModel saveKeywordWith:self.defalutSearchKey userID:tempUserID];
        self.viewModel.keyword = self.defalutSearchKey;
        self.textSearch.placeholder = self.defalutSearchKey;
        JobSearchResultVC *vc = [[JobSearchResultVC alloc] initWithKeyWord:self.defalutSearchKey];
        [self.navigationController pushViewController:vc animated:YES];
        [self didClick];
    }
    [MobClick event:@"choose_work_btn_find"];
    return YES;
}
- (BOOL)isBlankStr:(NSString*)str
{
    if (str == nil || str == NULL || [str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textSearch endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textSearch endEditing:YES];
}
#pragma mark - getters methods
- (CPSearchHeaderView *)searchHeardView
{
    if ( !_searchHeardView )
    {
        _searchHeardView = [[CPSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 494 / CP_GLOBALSCALE )];
    }
    return _searchHeardView;
}
- (CPSearchHistoryHeaderView *)searchHistoryHeaderView
{
    if ( !_searchHistoryHeaderView )
    {
        CGFloat searchHistoryHeaderHeight = (60 + 40 + 42) / CP_GLOBALSCALE;
        _searchHistoryHeaderView = [[CPSearchHistoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, searchHistoryHeaderHeight)];
    }
    return _searchHistoryHeaderView;
}
- (CPSearchHistoryFooterView *)searchHistoryFooterView
{
    if ( !_searchHistoryFooterView )
    {
        CGFloat searchHistoryFooterViewHeight = ( 40 + 144 + 40 ) / CP_GLOBALSCALE;
        _searchHistoryFooterView = [[CPSearchHistoryFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, searchHistoryFooterViewHeight)];
        [_searchHistoryFooterView.clearSearchHistoryButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self showSignOutTips];
            
        }];
    }
    return _searchHistoryFooterView;
}
#pragma mark - private methods
- (void)showSignOutTips
{
    [self.bindTipsView setHidden:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bindTipsView];
}
- (UITableView *)searchMatchTableView
{
    if ( !_searchMatchTableView )
    {
        _searchMatchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.viewHeight - (CP_IS_IPHONE_6P ? 55.0 : 49.0)) style:UITableViewStylePlain];
        _searchMatchTableView.delegate = self;
        _searchMatchTableView.dataSource = self;
        _searchMatchTableView.hidden = YES;
        _searchMatchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchMatchTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    }
    return _searchMatchTableView;
}
- (NSArray *)tempSearchMatchArray
{
    if ( !_tempSearchMatchArray )
    {
       _tempSearchMatchArray= [NSMutableArray array];
    
    }
    return _tempSearchMatchArray;
}
#pragma mark - getter methods
- (UIView *)bindTipsView
{
    if ( !_bindTipsView )
    {
        _bindTipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_bindTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat H = ( 84 + 60 + 84 + 48 * 1 + 24 * 1 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
        CGFloat X = 40 / CP_GLOBALSCALE;
        CGFloat Y = ( kScreenHeight - H ) / 2.0;
        UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [tipsView.layer setMasksToBounds:YES];
        [_bindTipsView addSubview:tipsView];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:60 / CP_GLOBALSCALE]];
        [titleLabel setText:@"退出"];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [tipsView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( tipsView.mas_top ).offset( 84 / CP_GLOBALSCALE );
            make.left.equalTo( tipsView.mas_left );
            make.right.equalTo( tipsView.mas_right );
            make.height.equalTo( @( 60 / CP_GLOBALSCALE ) );
        }];
        UILabel *contentLabel = [[UILabel alloc] init];
        [contentLabel setNumberOfLines:0];
        NSString *str = @"是否确定清除历史记录";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
        [contentLabel setAttributedText:attStr];
        [tipsView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( titleLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
            make.left.equalTo( tipsView.mas_left ).offset( 74 / CP_GLOBALSCALE );
            make.right.equalTo( tipsView.mas_right ).offset( -64 / CP_GLOBALSCALE );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
            make.left.equalTo( tipsView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:cancelButton];
        [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_bindTipsView setHidden:YES];
            [_bindTipsView removeFromSuperview];
        }];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_bindTipsView setHidden:YES];
            [_bindTipsView removeFromSuperview];
            [self clearHistory];
        }];
        UIView *verSeparatorLine = [[UIView alloc] init];
        [verSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:verSeparatorLine];
        CGFloat buttonW = ( W - 2 / CP_GLOBALSCALE ) / 2.0;
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( buttonW ) );
        }];
        [verSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( cancelButton.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.width.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( tipsView.mas_right );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.height.equalTo( cancelButton );
            make.width.equalTo( cancelButton );
        }];
        [_bindTipsView setHidden:YES];
    }
    return _bindTipsView;
}
@end
