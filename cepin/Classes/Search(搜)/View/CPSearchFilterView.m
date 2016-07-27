//
//  CPSearchFilterView.m
//  cepin
//
//  Created by kun on 16/1/10.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchFilterView.h"
#import "CPSearchFilterButton.h"
#import "CPSearchFilterCell.h"
#import "CPSearchCityFilterView.h"
#import "RegionDTO.h"
#import "JobFunctionHeaderView.h"
#import "AddressChooseVC.h"
#import "CPSearchCityFilterCell.h"
#import "CPSearchTextField.h"
#import "CPSearchMatchCell.h"
#import "CPSearchWithRightTextField.h"
#import "CPPinyin.h"
#import "CPChineseString.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
typedef NS_ENUM( NSInteger, CPSearchFilterMenuType ){
    CPSearchFilterMenuWorkAddress,
    CPSearchFilterMenuExpectSalary,
    CPSearchFilterMenuWorkYear,
    CPSearchFilterMenuMoreFilter
};
@interface CPSearchFilterView ()<UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate,JobFunctionHeaderViewDelegate,HotCityChangeDeleger, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CPSearchFilterButton *selectedMenuButton;
@property (nonatomic, strong) UIView *searchFilterBackgroundView;
@property (nonatomic, strong) UITableView *searchFilterTableView;
@property (nonatomic, strong) UITableView *searchCityFilterTableView;//城市选择
@property (nonatomic, strong) UITableView *searchCityMatchFilterTableView;//城市筛选城市地点关联
@property (nonatomic, strong) NSMutableArray *workAddress;
@property (nonatomic, strong) NSMutableArray *workRegionAddress;
@property (nonatomic, strong) NSMutableArray *workSubAddress;
@property (nonatomic, strong) NSArray *expectSalary;
@property (nonatomic, strong) NSArray *workYear;
@property (nonatomic, strong) NSArray *moreFilter;
@property (nonatomic, assign) CGFloat workAddressHeight;
@property (nonatomic, assign) CGFloat expectSalaryHeight;
@property (nonatomic, assign) CGFloat workYearHeight;
@property (nonatomic, assign) CGFloat moreFilterHeight;
@property (nonatomic, assign) NSUInteger workAddressSelectedIndex;
@property (nonatomic, assign) NSUInteger expectSalarySelectedIndex;
@property (nonatomic, assign) NSUInteger workYearSelectedIndex;
@property (nonatomic, assign) NSUInteger moreFilterSelectedIndex;
@property(nonatomic,strong)CPSearchCityFilterView *searchCityFilterView;
@property(nonatomic,strong)NSMutableArray *headView;
@property(nonatomic,strong)NSMutableArray *thirdRegion;
@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,strong)CPSearchWithRightTextField *searchTextFiled;
@property(nonatomic,strong)UIView *searchBg;
@property (nonatomic, copy) NSArray *tempSearchMatchArray;
@property(nonatomic,strong)NSString  *matchString;
@property(nonatomic,assign)BOOL isSearchCity;
@property(nonatomic,strong)UITableView *currentTableView;
@property(nonatomic,strong)JobSearchVM *model;
@property(nonatomic,strong)NSMutableArray *allCity;

@end

@implementation CPSearchFilterView

#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame model:(JobSearchVM *)model
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.model = model;
        [self addSubview:self.searchFilterBackgroundView];
        [self.searchFilterBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( @( 120 / CP_GLOBALSCALE ) );
            make.left.equalTo( self.mas_left );
            make.bottom.equalTo( self.mas_bottom );
            make.right.equalTo( self.mas_right );

        }];
        _searchFilterBackgroundView.hidden = YES;
        self.workSubAddress = [[NSMutableArray alloc]init];
        self.searchBg = [[UIView alloc]initWithFrame:CGRectMake(0, 120/CP_GLOBALSCALE, kScreenWidth, 144/CP_GLOBALSCALE)];
        [self.searchBg setBackgroundColor:[UIColor whiteColor]];
        [self.searchBg addSubview:self.searchTextFiled];
        [self addSubview:self.searchBg];
        UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
        [line setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.searchBg addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.searchBg.mas_bottom );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        //城市输入框筛选
        [self addSubview:self.searchCityMatchFilterTableView];
        //城市筛选
        [self addSubview:self.searchCityFilterTableView];
        self.searchCityMatchFilterTableView.hidden = YES;
        [self addSubview:self.searchFilterTableView];
        self.searchFilterTableView.hidden  = YES;
        _workAddressSelectedIndex = -1;
        _expectSalarySelectedIndex = -1;
        _workYearSelectedIndex = -1;
        self.isSearchCity = NO;
        self.searchBg.hidden = YES;
        [self.searchTextFiled.rac_textSignal subscribeNext:^(NSString *text) {
            self.matchString = text;
            if(nil == text || NULL == text || [text isEqualToString:@""]){
                self.tempSearchMatchArray  = [NSArray array];
                self.isSearchCity = NO;
                [self.searchCityMatchFilterTableView reloadData];
                [self.searchCityFilterTableView setHidden:NO];
                return ;
            }
            [self searMatch:text];
            UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick)];
            [self addGestureRecognizer:pan];
            pan.delegate = self;
        }];
    }
    return self;
}
- (void)didClick
{
    [self endEditing:YES];
}
//手势和uitableview冲突点不了。实现该方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
#pragma mark 搜索模糊搜索
-(void)searMatch:(NSString*)searchKey
{
    self.tempSearchMatchArray = [Region searchRegionWithRegionName:searchKey];
    if( self.tempSearchMatchArray )
    {
        self.searchCityMatchFilterTableView.viewHeight = kScreenHeight-(120 / CP_GLOBALSCALE+144/CP_GLOBALSCALE+64);
        self.searchCityMatchFilterTableView.hidden = NO;
         self.searchCityFilterTableView.hidden = YES;
        self.isSearchCity = YES;
        self.searchCityMatchFilterTableView.viewHeight =144.0 / CP_GLOBALSCALE*self.tempSearchMatchArray.count;
        [self.searchCityMatchFilterTableView reloadData];
    }
    else
    {
        self.isSearchCity = NO;
        self.searchCityMatchFilterTableView.hidden = YES;
        self.searchCityFilterTableView.hidden = NO;
    }
}
- (CPSearchWithRightTextField *)searchTextFiled
{
    if(!_searchTextFiled)
    {
        CPSearchWithRightTextField *text = [[CPSearchWithRightTextField alloc] initWithFrame:CGRectMake(40/CP_GLOBALSCALE, 20/CP_GLOBALSCALE, self.viewWidth-80/CP_GLOBALSCALE, 90/CP_GLOBALSCALE)];
        text.backgroundColor = [UIColor colorWithHexString:@"f0f2f5"];
        UIView *imageBackView = [[UIView alloc] init];
        [imageBackView setBackgroundColor:[UIColor redColor]];
        UIImageView *customLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_ic_search"]];
        CGFloat leftW = customLeftView.image.size.width / CP_GLOBALSCALE;
        CGFloat leftH = customLeftView.image.size.height / CP_GLOBALSCALE;
        customLeftView.frame = CGRectMake(0, 40/CP_GLOBALSCALE / 2.0, leftW, leftH);
        [imageBackView addSubview:customLeftView];
        text.delegate = self;
        text.leftView = imageBackView;
        text.rightViewMode = UITextFieldViewModeAlways;
        text.leftView.backgroundColor = [UIColor clearColor];
        text.leftViewMode = UITextFieldViewModeAlways;
        text.layer.cornerRadius = 90 / CP_GLOBALSCALE / 2.0;
        text.layer.masksToBounds = YES;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.placeholder = @"请输入城市名称";
        text.font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
        text.textColor = [UIColor colorWithHexString:@"404040"];
        
        _searchTextFiled = text;
    }
    return _searchTextFiled;
}
- (void)configTopButtonWithTitles:(NSArray *)titles
{
    if ( !titles )
        return;
    CGFloat buttonY = 0;
    CGFloat buttonW = kScreenWidth / [titles count];
    CGFloat buttonH = 120 / CP_GLOBALSCALE;
    for ( NSInteger index = 0; index < [titles count]; index++ )
    {
        CPSearchFilterButton *topButton = [[CPSearchFilterButton alloc] init];
        topButton.tag = index;
        NSString *title = [titles objectAtIndex:index];
        topButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [topButton.titleLabel setFont:[UIFont systemFontOfSize:36.0 / CP_GLOBALSCALE]];
        if(nil != self.model && self.model.subModel.address && ![self.model.subModel.address isEqualToString:@""]  && index==0){
            [topButton setTitle:self.model.subModel.address forState:UIControlStateNormal];
            [topButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        }else if(nil != self.model && nil != self.model.subModel.salary && ![self.model.subModel.salary isEqualToString:@""] && index==1){
            [topButton setTitle:self.model.subModel.salary forState:UIControlStateNormal];
            [topButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        }else if(nil != self.model && self.model.subModel.workYear && ![self.model.subModel.workYear isEqualToString:@""] && index==2){
            [topButton setTitle:self.model.subModel.workYear forState:UIControlStateNormal];
            [topButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        }else{
            [topButton setTitle:title forState:UIControlStateNormal];
            [topButton setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        }
        [topButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateSelected];
        CGFloat buttonX = index * buttonW;
        topButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [topButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"efeff4"] cornerRadius:0.0] forState:UIControlStateNormal];
        [topButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateSelected];
        if ( index == [titles count] - 1 )
        {
            [topButton setImage:[UIImage imageNamed:@"filter_ic_filter"] forState:UIControlStateNormal];
        }
        else
        {
            [topButton setImage:[UIImage imageNamed:@"filter_ic_down"] forState:UIControlStateNormal];
            [topButton setImage:[UIImage imageNamed:@"filter_ic_up"] forState:UIControlStateSelected];
        }
        if ( index == [titles count] - 1 )
        {
            [topButton addTarget:self action:@selector(clickedMoreFilterButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [topButton addTarget:self action:@selector(clickedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:topButton];
    }
}
- (void)configMenuWithAddress:(NSArray *)workAddress expectSalary:(NSArray *)expectSalary workYear:(NSArray *)workYear moreFilter:(NSArray *)moreFilter
{
    CGFloat fixdHeight = 144.0 / CP_GLOBALSCALE;
    _workAddress = [NSMutableArray arrayWithCapacity:workAddress.count];
    self.workRegionAddress = [NSMutableArray arrayWithCapacity:workAddress.count];
    for (int i = 0; i < workAddress.count; i++ )
    {
        Region *region = [Region beanFromDictionary:workAddress[i]];
        [_workAddress addObject:region.RegionName];
        [self.workRegionAddress addObject:region];
    }
    [self loadModel];
    _expectSalary = expectSalary;
    _workYear = workYear;
    _moreFilter = moreFilter;
    _workAddressHeight = fixdHeight* [_workAddress count];
    _expectSalaryHeight = fixdHeight * [_expectSalary count];
    _workYearHeight = fixdHeight * [_workYear count];
    _moreFilterHeight = fixdHeight * [_moreFilter count];
}
- (void)loadModel
{
    self.headView = [NSMutableArray new];
    for (int i = 0; i < _workAddress.count; i ++ ) {
        JobFunctionHeaderView *headView = [[JobFunctionHeaderView alloc]init];
        headView.delegate = self;
        headView.section = i;
        headView.jobName.text = [NSString stringWithFormat:@"%@",self.workAddress[i]];
        [self.headView addObject:headView];
    }
}
#pragma mark - HeadViewdelegate
-(void)selectedWith:(JobFunctionHeaderView *)view
{
    [self.searchTextFiled endEditing:YES];
    
    [view resetLine];
    if (view.open) {
       
        for(int i = 0;i<[self.headView count];i++)
        {
            JobFunctionHeaderView *head = [self.headView objectAtIndex:i];
            head.open = NO;
        }
        [self.searchCityFilterTableView reloadData];
        return;
    }
    
    self.currentSection = view.section;
    [self resetView];
    
}
//界面重置
- (void)resetView
{
    for(int i = 0;i<[self.headView count];i++)
    {
        JobFunctionHeaderView *head = [self.headView objectAtIndex:i];
        if(head.section == self.currentSection)
        {
            head.open = YES;
        }else {
            head.open = NO;
        }
    }
    [self.searchCityFilterTableView reloadData];
}
#pragma mark UITableViewDataScource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !self.selectedMenuButton )
        return 0;
   
    if (self.selectedMenuButton.tag == CPSearchFilterMenuWorkAddress) {
        if(self.isSearchCity){
            //显示城市输入框搜索列表
                return 144/CP_GLOBALSCALE;
        }else{
            //显示城市筛选
            JobFunctionHeaderView* headView = [self.headView objectAtIndex:indexPath.section];
            return headView.open? 144 / CP_GLOBALSCALE : 0.0;
        }
    }
    return 144 / CP_GLOBALSCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( !self.selectedMenuButton )
        return 0;
   
    if (self.selectedMenuButton.tag == CPSearchFilterMenuWorkAddress) {
        if(!self.isSearchCity){
            return 144 / CP_GLOBALSCALE;
        }
    }
   return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( !self.selectedMenuButton )
        return 0;
   
    if (self.selectedMenuButton.tag == CPSearchFilterMenuWorkAddress && self.isSearchCity==NO) {
       return [self.headView objectAtIndex:section];
    }
    return nil;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( !self.selectedMenuButton )
        return 0;
    if (self.selectedMenuButton.tag == CPSearchFilterMenuWorkAddress && self.isSearchCity==NO) {
        return [self.headView count];
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( !self.selectedMenuButton )
        return 0;
    if(self.selectedMenuButton.tag == CPSearchFilterMenuWorkAddress && NO==self.isSearchCity){
        //显示城市筛选
        JobFunctionHeaderView *headView = [self.headView objectAtIndex:section];
        Region *region = self.workRegionAddress[section];
        NSMutableArray *thirdArray = [Region citiesWithCodeAndNotHot:region.PathCode];
        
        return headView.open?[thirdArray count]>0?[thirdArray count]:1:0;
    }
    switch ( self.selectedMenuButton.tag )
    {
        case CPSearchFilterMenuWorkAddress:
            //显示城市输入框列表
            return self.tempSearchMatchArray.count;
            break;
        case CPSearchFilterMenuExpectSalary:
            return [self.expectSalary count];
            break;
        case CPSearchFilterMenuWorkYear:
            return [self.workYear count];
            break;
        case CPSearchFilterMenuMoreFilter:
            return [self.moreFilter count];
            break;
        default :
            return 0;
    }
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !self.selectedMenuButton )
        return nil;
    self.currentTableView = tableView;
    //搜索城市
    if (self.selectedMenuButton.tag==CPSearchFilterMenuWorkAddress && self.isSearchCity) {
        CPSearchMatchCell *cell = [CPSearchMatchCell searchMatchCellWithTableView:tableView];
        Region *hotSearchKey = [self.tempSearchMatchArray objectAtIndex:indexPath.row];
        BOOL hideSeparator = indexPath.row == [self.tempSearchMatchArray count] - 1;
        [cell configSearchMatchCell:hotSearchKey.RegionName matchString:self.matchString hideSeparator:hideSeparator];
        return cell;
    }
    NSString *searchFilterTitle = nil;
    BOOL hideSelectedImage = YES;
    
    if (self.selectedMenuButton.tag==CPSearchFilterMenuWorkAddress) {
        CPSearchCityFilterCell *cell = [CPSearchCityFilterCell searchCityFilterCellWithTableView:tableView];
        Region *region = self.workRegionAddress[indexPath.section];
         NSArray *thirdArray =  [self getThirdRegionWithRegion:region];
        if(thirdArray.count==0){
            searchFilterTitle = region.RegionName;
             [cell resetLineWithShowFull:YES];
        }else{
            Region *subRegion = thirdArray[indexPath.row];
            searchFilterTitle = subRegion.RegionName;
            if(thirdArray.count-1==indexPath.section){
              [cell resetLineWithShowFull:YES];
            }else{
              [cell resetLineWithShowFull:NO];
            }
        }
        if (self.model.subModel.address && [self.model.subModel.address isEqualToString:searchFilterTitle]) {
             hideSelectedImage = NO;
        }
        
        cell.backgroundColor =  [UIColor colorWithHexString:@"eeeeee"];
        [cell configWithSearchCityFilterTitle:searchFilterTitle hideSelectedImage:hideSelectedImage];
        return cell;
    }else{
        CPSearchFilterCell *cell = [CPSearchFilterCell searchFilterCellWithTableView:tableView];
        switch ( self.selectedMenuButton.tag )
        {
            case CPSearchFilterMenuExpectSalary:
                searchFilterTitle = self.expectSalary[indexPath.row];
                
                if ( self.expectSalarySelectedIndex == indexPath.row )
                    hideSelectedImage = NO;
                else
                    hideSelectedImage = YES;
                if (self.model && self.model.subModel && [self.model.subModel.salarykey isEqualToString:searchFilterTitle]) {
                    hideSelectedImage = NO;
                    self.expectSalarySelectedIndex  = indexPath.row;
                }
                break;
            case CPSearchFilterMenuWorkYear:
                searchFilterTitle = self.workYear[indexPath.row];
                
                if ( self.workYearSelectedIndex == indexPath.row )
                    hideSelectedImage = NO;
                else
                    hideSelectedImage = YES;
                if (self.model && self.model.subModel && [self.model.subModel.workYear isEqualToString:searchFilterTitle]) {
                     hideSelectedImage = NO;
                    self.workYearSelectedIndex  = indexPath.row;
                }
                break;
            case CPSearchFilterMenuMoreFilter:
                searchFilterTitle = self.moreFilter[indexPath.row];
                
                if ( self.moreFilterSelectedIndex == indexPath.row )
                    hideSelectedImage = NO;
                else
                    hideSelectedImage = YES;
                if (self.model && self.model.subModel && [self.model.subModel.workYearkey isEqualToString:@"searchFilterTitle"]) {
                    hideSelectedImage = NO;
                    self.moreFilterSelectedIndex  = indexPath.row;
                }
                break;
            default :
                return 0;
        }
        [cell configWithSearchFilterTitle:searchFilterTitle hideSelectedImage:hideSelectedImage];
        return cell;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchTextFiled endEditing:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchTextFiled endEditing:YES];
    if ( !self.selectedMenuButton )
        return;
    self.currentTableView = tableView;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger frontFlash = 0;
    NSUInteger afterFlash = indexPath.row;
    switch ( self.selectedMenuButton.tag )
    {
        case CPSearchFilterMenuWorkAddress:
            frontFlash = self.workAddressSelectedIndex;
            self.workAddressSelectedIndex = afterFlash;
             break;
        case CPSearchFilterMenuExpectSalary:
            frontFlash = self.expectSalarySelectedIndex;
            self.expectSalarySelectedIndex = afterFlash;
            [self.filterChangeDeleger salarySelect:self.expectSalary[indexPath.row] selectBtn:self.selectedMenuButton];
            break;
        case CPSearchFilterMenuWorkYear:
            frontFlash = self.workYearSelectedIndex;
            self.workYearSelectedIndex = afterFlash;
            [self.filterChangeDeleger workSelect:self.workYear[indexPath.row] selectBtn:self.selectedMenuButton];
            break;
        case CPSearchFilterMenuMoreFilter:
            frontFlash = self.moreFilterSelectedIndex;
            self.moreFilterSelectedIndex = afterFlash;
            break;
    }
    if(self.selectedMenuButton.tag == CPSearchFilterMenuWorkAddress){
        if (self.isSearchCity) {
            //热门城市点击搜索
            Region *hotSearchKey = [self.tempSearchMatchArray objectAtIndex:indexPath.row];
             [self.filterChangeDeleger cityselect:hotSearchKey selectBtn:self.selectedMenuButton];
        }else{
            //所有城市点击搜搜
            Region *region = self.workRegionAddress[indexPath.section];
            NSArray *thirdArray =  [self getThirdRegionWithRegion:region];
            if(thirdArray.count>0){
                Region *subRegion = thirdArray[indexPath.row];
                [self.filterChangeDeleger cityselect:subRegion selectBtn:self.selectedMenuButton];
            }else{
                [self.filterChangeDeleger cityselect:region selectBtn:self.selectedMenuButton];
            }
            [tableView reloadData];

        }
    }else{
    
        [self.searchFilterTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:frontFlash inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.searchFilterTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:afterFlash inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    __weak typeof( self ) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf clickedMenuButton:self.selectedMenuButton];
        weakSelf.selectedMenuButton = nil;
    });
}
#pragma mark-字母排序
-(NSArray *)getThirdRegionWithRegion:(Region *)region{
    
    NSMutableArray *thirdArray =  [Region citiesWithCodeAndNotHot:region.PathCode];
    if (nil == thirdArray ||thirdArray.count==0 ) {
       return thirdArray;
    }
    //字母排序
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    for(int i=0;i<[thirdArray count];i++){
        CPChineseString *chineseString=[[CPChineseString alloc]init];
        Region *region = [thirdArray objectAtIndex:i];
        chineseString.string=[NSString stringWithString:region.RegionName];
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        region.firstLetter = chineseString.pinYin;
    }
    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES]];
    NSArray *sortedArr = [thirdArray sortedArrayUsingDescriptors:sortDesc];
    return sortedArr;
}
#pragma mark 热门城市点击监听
-(void)hotCitySelect:(Region *)cityRegion{
    __weak typeof( self ) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf clickedMenuButton:self.selectedMenuButton];
        weakSelf.selectedMenuButton = nil;
    });
    [self.filterChangeDeleger cityselect:cityRegion selectBtn:self.selectedMenuButton];
}
#pragma mark - event action
- (void)clickedMenuButton:(CPSearchFilterButton *)sender
{
    [self.searchTextFiled endEditing:YES];
    if ( _selectedMenuButton == sender )
    {
        if ( _selectedMenuButton.selected )
        {
            [self closeSearchFilterTableView];
        }
        else
        {
            [self openSearchFilterTableView];
        }
        _selectedMenuButton.selected = !_selectedMenuButton.selected;
    }
    else
    {
        if ( self.selectedMenuButton )
        {
            self.searchFilterTableView.viewHeight = 0;
        }
        _selectedMenuButton.selected = NO;
        sender.selected = YES;
        _selectedMenuButton = sender;
        
        [self openSearchFilterTableView];
    }
}
- (void)clickedMoreFilterButton:(CPSearchFilterButton *)sender
{
    if ( _selectedMenuButton )
    {
        _selectedMenuButton.selected = !_selectedMenuButton.selected;
        [self closeSearchFilterTableView];
        CGFloat tableViewHeight = 120 / CP_GLOBALSCALE;
        self.searchFilterTableView.viewHeight = 0;
        self.viewHeight = tableViewHeight;
        self.selectedMenuButton = nil;
    }
    if ( [self.searchFilterDelegate respondsToSelector:@selector(clickedMoreFilterButton)] )
    {
        [self.searchFilterDelegate clickedMoreFilterButton];
    }
}
- (void)clickedCityFilterButton:(CPSearchFilterButton *)sender
{
    if ( _selectedMenuButton )
    {
        _selectedMenuButton.selected = !_selectedMenuButton.selected;
        CGFloat tableViewHeight = 120 / CP_GLOBALSCALE;
        self.searchFilterTableView.viewHeight = 0;
        self.viewHeight = tableViewHeight;
        self.selectedMenuButton = nil;
        if ( [self.searchFilterDelegate respondsToSelector:@selector(removeCityView)] )
        {
            [self.searchFilterDelegate removeCityView];
        }
    }
    else
    {
        if ( self.selectedMenuButton )
        {
            self.searchFilterTableView.viewHeight = 0;
        }
        _selectedMenuButton.selected = NO;
        sender.selected = YES;
        _selectedMenuButton = sender;
        
        if ( [self.searchFilterDelegate respondsToSelector:@selector(clickedCityFilterButton)] )
        {
            [self.searchFilterDelegate clickedCityFilterButton];
        }
    }
}
- (void)openSearchFilterTableView
{
    self.searchFilterTableView.hidden  = NO;
    self.viewHeight = kScreenHeight- 64.0;
    __weak typeof ( self ) weakSelf = self;
    CGFloat tableViewHeight = 0;
    switch ( self.selectedMenuButton.tag )
    {
        case CPSearchFilterMenuWorkAddress:
            self.viewHeight = kScreenHeight - (64);
            tableViewHeight = kScreenHeight - (120 / CP_GLOBALSCALE+144/CP_GLOBALSCALE+64);
            _searchFilterTableView.hidden = YES;
            _searchCityMatchFilterTableView.hidden = YES;
            _searchCityFilterTableView.hidden = NO;
             _searchFilterBackgroundView.hidden = NO;
            self.isSearchCity = NO;
            [_searchTextFiled setText:@""];
            self.tempSearchMatchArray = nil;
            self.tempSearchMatchArray  = [NSArray array];
//            [_searchCityMatchFilterTableView reloadData];
//            [_searchFilterTableView reloadData];
            if ( self.model.subModel.address )
            {
                self.searchCityFilterView.selectCity = self.model.subModel.address;
            }
            self.searchBg.hidden = NO;
            self.currentTableView = _searchCityFilterTableView;
            break;
        case CPSearchFilterMenuExpectSalary:
            if ( self.viewHeight == 120 / CP_GLOBALSCALE )
                self.viewHeight = kScreenHeight - 64.0;
             _searchFilterBackgroundView.hidden = NO;
            _searchFilterTableView.hidden = NO;
            _searchCityFilterTableView.hidden = YES;
            _searchCityMatchFilterTableView.hidden = YES;
            self.searchBg.hidden = YES;
            tableViewHeight = self.expectSalaryHeight;
            self.currentTableView = _searchFilterTableView;
            break;
        case CPSearchFilterMenuWorkYear:
            if ( self.viewHeight == 120 / CP_GLOBALSCALE )
                self.viewHeight = kScreenHeight - 64.0;
            tableViewHeight = self.workYearHeight;
            _searchCityFilterTableView.hidden = YES;
             _searchFilterBackgroundView.hidden = NO;
            self.searchBg.hidden = YES;
            _searchFilterTableView.hidden = NO;
            _searchCityMatchFilterTableView.hidden = YES;
            self.currentTableView = _searchFilterTableView;
            break;
        case CPSearchFilterMenuMoreFilter:
            tableViewHeight = self.moreFilterHeight;
            self.currentTableView.hidden = YES;
            self.searchBg.hidden = YES;
            self.currentTableView.rowHeight = 0;
             _searchFilterBackgroundView.hidden= YES;
            break;
        default :
            break;
    }
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.currentTableView.viewHeight = tableViewHeight;
        [weakSelf.currentTableView reloadData];
         _searchFilterBackgroundView.hidden = NO;
    }];
}
- (void)closeSearchFilterTableView
{
    __weak typeof ( self ) weakSelf = self;
    CGFloat tableViewHeight = 120 / CP_GLOBALSCALE;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.currentTableView.viewHeight = 0;
    } completion:^(BOOL finished) {
        weakSelf.viewHeight = tableViewHeight;
        weakSelf.selectedMenuButton = nil;
            self.searchBg.hidden = YES;
    }];
}
#pragma mark - getter methods
- (UIView *)searchFilterBackgroundView
{
    if ( !_searchFilterBackgroundView )
    {
        _searchFilterBackgroundView = [[UIView alloc] init];
        [_searchFilterBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.8]];
    }
    return _searchFilterBackgroundView;
}
- (UITableView *)searchFilterTableView
{
    if ( !_searchFilterTableView )
    {
        _searchFilterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120 / CP_GLOBALSCALE, kScreenWidth, 0) style:UITableViewStylePlain];
        _searchFilterTableView.dataSource = self;
        _searchFilterTableView.delegate = self;
        [_searchFilterTableView setBackgroundColor:[UIColor whiteColor]];
        [_searchFilterTableView setRowHeight:144.0 / CP_GLOBALSCALE];
        _searchFilterTableView.rowHeight = 144.0 / CP_GLOBALSCALE;
        _searchFilterTableView.sectionHeaderHeight = 144.0 / CP_GLOBALSCALE;
        [_searchFilterTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _searchFilterTableView;
}
#pragma mark-城市筛选
- (UITableView *)searchCityFilterTableView
{
    if ( !_searchCityFilterTableView )
    {
        _searchCityFilterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144 / CP_GLOBALSCALE+120/CP_GLOBALSCALE, kScreenWidth, 0) style:UITableViewStylePlain];
        _searchCityFilterTableView.dataSource = self;
        _searchCityFilterTableView.delegate = self;
        [_searchCityFilterTableView setBackgroundColor:[UIColor whiteColor]];
        [_searchCityFilterTableView setRowHeight:144.0 / CP_GLOBALSCALE];
        _searchCityFilterTableView.rowHeight = 144.0 / CP_GLOBALSCALE;
        _searchCityFilterTableView.sectionHeaderHeight = 144.0 / CP_GLOBALSCALE;
        [_searchCityFilterTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _searchCityFilterTableView.tableHeaderView = self.searchCityFilterView;
    }
    return _searchCityFilterTableView;
}
#pragma mark-城市关联筛选
- (UITableView *)searchCityMatchFilterTableView
{
    if ( !_searchCityMatchFilterTableView )
    {
        _searchCityMatchFilterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120 / CP_GLOBALSCALE+144/CP_GLOBALSCALE, kScreenWidth, kScreenHeight-120 / CP_GLOBALSCALE+144/CP_GLOBALSCALE) style:UITableViewStylePlain];
        _searchCityMatchFilterTableView.dataSource = self;
        _searchCityMatchFilterTableView.delegate = self;
        [_searchCityMatchFilterTableView setBackgroundColor:[UIColor whiteColor]];
        [_searchCityMatchFilterTableView setRowHeight:144.0 / CP_GLOBALSCALE];
        [_searchCityMatchFilterTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _searchCityMatchFilterTableView;
}
- (CPSearchCityFilterView *)searchCityFilterView
{
    if ( !_searchCityFilterView )
    {
        TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
        //判断是否已经请求过热门城市的接口
        if(nil != delegate.cityData){
            _allCity = delegate.cityData;
            NSInteger intNum = _allCity.count / 4;
            NSInteger floatNum = _allCity.count % 4;
            if ( 0 < floatNum )
                intNum++;
            CGFloat fixldH = ( 60 + 42 + 60 ) / CP_GLOBALSCALE;
            fixldH += ( 90 + 40 ) / CP_GLOBALSCALE * intNum;
            CGFloat topViewHeight = ( 144 + 144 ) / CP_GLOBALSCALE + fixldH;
            
            _searchCityFilterView = [[CPSearchCityFilterView alloc] initWithFrame:CGRectMake(0, 144.0/CP_GLOBALSCALE+120 / CP_GLOBALSCALE, kScreenWidth, topViewHeight) city:self.model.subModel.address otherCityHeight:topViewHeight];
            _searchCityFilterView.hotCityfilterChangeDeleger = self;
        }else{
            _searchCityFilterView = [[CPSearchCityFilterView alloc] initWithFrame:CGRectMake(0, 144.0/CP_GLOBALSCALE+120 / CP_GLOBALSCALE, kScreenWidth, 400) city:self.model.subModel.address otherCityHeight:300];
            _searchCityFilterView.hotCityfilterChangeDeleger = self;
        }
    }
    return _searchCityFilterView;
}
@end
