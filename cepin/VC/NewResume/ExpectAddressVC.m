//
//  AddressChooseVC.m
//  cepin
//
//  Created by ceping on 15-3-19.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExpectAddressVC.h"
#import "ExpectAddressVM.h"
#import "RegionDTO.h"
#import "ChooseCell.h"
#import "TBTextUnit.h"
#import "ExpectAddressSecendVC.h"
#import "AddressPresentCell.h"
#import "OtherAddressCell.h"
#import "AOTag.h"
#import "CPSearchTextField.h"
#import "CPResumeGuideExperienceCityButton.h"
#import "CPResumeEditFirstAddressCell.h"
#import "CPResumeEditLocalAddressButton.h"
#import "TBAppDelegate.h"
#import "UIViewController+NavicationUI.h"
#import "CPSearchWithRightTextField.h"
#import "CPSearchMatchDTO.h"
#import "RTNetworking+Position.h"
#import "CPSearchMatchCell.h"
#import "CPWExpectAddressSearchCell.h"
#import "CPCommon.h"
@interface ExpectAddressVC ()<AOTagDelegate, CPResumeEditFirstAddressCellDelegate, ExpectAddressChooseVMDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,retain) ExpectAddressVM *viewModel;
@property(nonatomic,strong) AOTagList *tagListView;
@property(nonatomic,strong)NSMutableArray *secDatas;
@property(nonatomic,strong)UIView *selectedFunctionView;
@property(nonatomic)int selectedCount;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UIImageView *clickImage;
@property (nonatomic, strong) UIView *searchTopView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) CPSearchWithRightTextField *searchCityTextField;
@property (nonatomic, strong) UIView *hotCityBackgroundView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) UIView *secondSeparatorLine;
@property (nonatomic, strong) UIButton *selectedHotCityButton;
@property (nonatomic, strong) NSMutableArray *childCityArrayM;
@property (nonatomic, assign) NSInteger selectedFirstRow;
@property (nonatomic, strong) CPResumeEditLocalAddressButton *localButton;
@property (nonatomic, strong) NSMutableArray *allCityArrayM;
@property (nonatomic, strong) UITableView *searchCityTableView;
@property (nonatomic, strong) NSMutableArray *hotCitySelectedArrayM;
@property (nonatomic, strong) NSMutableArray *hotCityButtonArrayM;
@property (nonatomic, strong) UIButton *resetLocalButton;
@property (nonatomic, strong) UIView *maxSelecetdTipsView;
@property (nonatomic, strong) UITableView *searchMatchTableView;
@property (nonatomic, copy) NSArray *tempSearchMatchArray;
@property (nonatomic, strong) NSString  *matchString;
@end
@implementation ExpectAddressVC
-(instancetype)initWithModel:(ResumeNameModel*)model
{
    if (self = [super init])
    {
        self.model = model;
        self.secDatas = [NSMutableArray new];
        self.viewModel = [[ExpectAddressVM alloc] initWithSendModel:model];
        [self.viewModel setExpectAddressChooseDelegate:self];
    }
    [self.viewModel beginLocation];
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"期望城市";
    self.selectedFirstRow = -1;
    [self createSelectedFunctionView];
    [self.view addSubview:self.searchTopView];
    [self.searchTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.selectedFunctionView.mas_bottom );
        make.left.equalTo( self.view.mas_left );
        make.right.equalTo( self.view.mas_right );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight + (144 / CP_GLOBALSCALE + self.topView.viewHeight), self.view.viewWidth, self.view.viewHeight - 144 / CP_GLOBALSCALE - self.selectedFunctionView.viewHeight - self.topView.viewHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120 / CP_GLOBALSCALE / 2.0, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.tableView.tableHeaderView = self.topView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchMatchTableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.searchTopView.mas_bottom );
        make.left.equalTo( self.view.mas_left );
        make.right.equalTo( self.view.mas_right );
        make.bottom.equalTo( self.view.mas_bottom );
    }];
    [self.searchMatchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.searchTopView.mas_bottom );
        make.left.equalTo( self.view.mas_left );
        make.right.equalTo( self.view.mas_right );
        make.bottom.equalTo( self.view.mas_bottom );
    }];
    [RACObserve(self.viewModel, isShrink) subscribeNext:^(id isShrink) {
        if (!self.viewModel.isShrink) {
            self.selectedFunctionView.frame = CGRectMake(0, 64.0, self.view.viewWidth, 144 / CP_GLOBALSCALE);
            self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight + 144 / CP_GLOBALSCALE + self
                                              .topView.viewHeight, self.view.viewWidth, self.view.viewHeight - self.selectedFunctionView.viewHeight - 144 / CP_GLOBALSCALE - self.topView.viewHeight);
            self.tagListView.hidden = YES;
             self.clickImage.image = [UIImage imageNamed:@"ic_down"];
            [self.tableView reloadData];
        }
        else
        {
            self.selectedFunctionView.frame = CGRectMake(0, 64.0, self.view.viewWidth, (144 + 60 + 90 + 60) / CP_GLOBALSCALE);
            self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight + 144 / CP_GLOBALSCALE + self
                                              .topView.viewHeight, self.view.viewWidth, self.view.viewHeight - self.selectedFunctionView.viewHeight - 144 / CP_GLOBALSCALE - self.topView.viewHeight);
            self.tagListView.hidden = NO;
             self.clickImage.image = [UIImage imageNamed:@"ic_up"];
            [self.tableView reloadData];
        }
    }];
    __weak typeof( self ) weakSelf = self;
    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    if ( nil == delegate.cityData )
    {
        // 请求热门城市接口
        RACSignal *companySignal = (RACSignal *)[[RTNetworking shareInstance] getHotCityData];
        [companySignal subscribeNext:^(RACTuple *tuple)
         {
             NSDictionary *dict = (NSDictionary *)tuple.second;
             if([dict resultSucess])
             {
                 NSArray *array = [dict resultObject];
                 if( array )
                 {
                     self.cityArray = [NSMutableArray arrayWithCapacity:array.count+1];
                     Region *rg = [Region new];
                     rg.PathCode = @"1";
                     rg.RegionName = @"全国";
                     [self.cityArray addObject:rg];
                     for (int i = 0; i < array.count; i++) {
                         Region *region = [Region beanFromDictionary:array[i]];
                         [self.cityArray addObject:region];
                     }
                     weakSelf.topView = nil;
                     weakSelf.tableView.tableHeaderView = weakSelf.topView;
                     [self setOtherCityWithName:self.cityArray];
                     [delegate setCityData:self.cityArray];
                 }
             }
         }];
    }
    else
    {
        self.cityArray = delegate.cityData;
        weakSelf.topView = nil;
        weakSelf.tableView.tableHeaderView = weakSelf.topView;
        [self setOtherCityWithName:delegate.cityData];
    }
    [self.view addSubview:self.searchCityTableView];
    [self.view addSubview:self.maxSelecetdTipsView];
    [self.searchCityTextField.rac_textSignal subscribeNext:^(NSString *text) {
        self.matchString = text;
        if(nil == text || NULL == text || [text isEqualToString:@""])
        {
            self.tempSearchMatchArray  = [NSArray array];
            [self.searchMatchTableView reloadData];
            [self.searchMatchTableView setHidden:YES];
            return ;
        }
        [self searMatch:text];
    }];
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
}
- (void)didClick
{
    [self.view endEditing:YES];
}
//手势和uitableview冲突点不了。实现该方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
- (void)createSelectedFunctionView
{
    self.selectedFunctionView = [[UIView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.viewWidth, 144 / CP_GLOBALSCALE)];
    self.selectedFunctionView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self.view addSubview:self.selectedFunctionView];
    NSString *staticTitle = @"编辑已选条件";
    UILabel *staticTitleLabel = [[UILabel alloc] init];
    [staticTitleLabel setText:staticTitle];
    [staticTitleLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
    [staticTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
    [self.selectedFunctionView addSubview:staticTitleLabel];
    [staticTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.selectedFunctionView.mas_top );
        make.left.equalTo( self.selectedFunctionView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
    CPResumeGuideExperienceCityButton *click = [CPResumeGuideExperienceCityButton buttonWithType:UIButtonTypeCustom];
    click.backgroundColor = [UIColor clearColor];
    [click setImage:[UIImage imageNamed:@"ic_down_blue"] forState:UIControlStateNormal];
    [click setImage:[UIImage imageNamed:@"ic_up_blue"] forState:UIControlStateSelected];
    [self.selectedFunctionView addSubview:click];
    [click mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo( self.selectedFunctionView.mas_right ).offset( -10 / CP_GLOBALSCALE );
        make.centerY.equalTo( staticTitleLabel.mas_centerY );
        make.width.equalTo( @( 144 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
    [click handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        sender.selected = !sender.isSelected;
        self.viewModel.isShrink = !self.viewModel.isShrink;
    }];
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textColor = [UIColor colorWithHexString:@"288add"];
    self.countLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.countLabel setTextAlignment:NSTextAlignmentRight];
    [self.selectedFunctionView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo( click.mas_left );
        make.height.equalTo( staticTitleLabel );
        make.top.equalTo( staticTitleLabel.mas_top );
    }];
    UIView *separatorLine = [[UIView alloc] init];
    [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    [self.selectedFunctionView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( staticTitleLabel.mas_bottom ).offset( -2 / CP_GLOBALSCALE );
        make.left.equalTo( staticTitleLabel.mas_left );
        make.right.equalTo( self.selectedFunctionView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
    }];
    self.tagListView = [[AOTagList alloc] init];
    [self.tagListView setDelegate:self];
    [self.selectedFunctionView addSubview:self.tagListView];
    [self.tagListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedFunctionView.mas_left);
        make.right.equalTo(self.selectedFunctionView.mas_right);
        make.top.equalTo(separatorLine.mas_bottom);
        make.height.equalTo( @( (60 + 90 + 60) / CP_GLOBALSCALE ) );
    }];
}
- (void)tagDidRemoveTag:(AOTag *)tag
{
    [self.secDatas removeObject:tag.tTitle];
    NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedCity]];
    [self.viewModel.selectedCity removeAllObjects];
    for (Region *item in array)
    {
        if (![tag.tTitle isEqualToString:item.RegionName]) {
            [self.viewModel.selectedCity addObject:item.PathCode];
        }
        else
        {
            [self updateHotCityButton:item isSelected:NO];
        }
    }
    if ( [tag.tTitle isEqualToString:@"全国"] )
    {
        Region *region = [[Region alloc] init];
        region.RegionName = tag.tTitle;
        [self updateHotCityButton:region isSelected:NO];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/3",(unsigned long)self.viewModel.selectedCity.count];
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAddressLabel];
    for ( Region *region in self.viewModel.allAddress )
    {
        NSMutableArray *thirdArray = [Region citiesWithCodeAndNotHot:region.PathCode];
        if ( !thirdArray )
            thirdArray = [NSMutableArray arrayWithObject:region];
        [self.childCityArrayM addObject:thirdArray];
    }
    for ( NSMutableArray * childArray in self.childCityArrayM )
    {
        [self.allCityArrayM addObjectsFromArray:childArray];
    }
    int hight = 66.0 / CP_GLOBALSCALE;
    UIImage *image = [UIImage imageNamed:@"ic_confirm"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickedConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, self.navigationController.navigationBar.center.y+hight / 2, hight, hight);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startButtonAnimationWithButton:self.resetLocalButton];
}
#pragma mark - event respond
- (void)clickedConfirmBtn:(UIButton *)sender
{
    self.model.ExpectCity = [TBTextUnit baseCodeNameWithArray:self.viewModel.selectedCity];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setAddressLabel
{
    NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedCity]];
    [self.secDatas removeAllObjects];
    for (int i = 0; i < array.count; i++)
    {
        Region *item = array[i];
        [self.secDatas addObject:item.RegionName];
    }
    NSUInteger tempCount = 0;
    for ( UIButton *btn in self.hotCitySelectedArrayM )
    {
        if ( [btn.titleLabel.text isEqualToString:@"全国"] )
        {
            Region *item = [[Region alloc] init];
            item.RegionName = @"全国";
            [self.secDatas addObject:item.RegionName];
            tempCount++;
            break;
        }
    }
    [self.tagListView removeAllTag];
    for (NSInteger i = 0; i < self.secDatas.count; i++)
    {
        [self.tagListView addTag:[self.secDatas objectAtIndex:i] withImage:nil withLabelColor:[UIColor whiteColor]  withBackgroundColor:[UIColor colorWithHexString:@"288add"] withCloseButtonColor:[UIColor whiteColor]];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/3",(unsigned long)array.count + tempCount];
}
#pragma mark UITableViewDataScource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.tableView )
        return self.viewModel.allAddress.count;
    else if ( tableView == self.searchMatchTableView )
    {
        return [self.tempSearchMatchArray count];
    }
        return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.tableView )
    {
        CPResumeEditFirstAddressCell *cell = [CPResumeEditFirstAddressCell editFirstAddressCellWithTableView:tableView];
        [cell setEditFirstAddressDelegate:self];
        Region *region = self.viewModel.allAddress[indexPath.row];
        NSMutableArray *childArray = self.childCityArrayM[indexPath.row];
        BOOL isSelected = NO;
        if ( self.selectedFirstRow == indexPath.row )
            isSelected = YES;
        NSMutableArray *selectedRegions = [NSMutableArray array];
        if ( 0 < [self.viewModel.selectedCity count] )
        {
            for ( NSString *selectedRegionPathcode in self.viewModel.selectedCity )
            {
                for ( NSMutableArray *tempArray in self.childCityArrayM )
                {
                    for ( Region *childRegion in tempArray )
                    {
                        if ( [selectedRegionPathcode isEqualToString:childRegion.PathCode] )
                        {
                            [selectedRegions addObject:childRegion];
                            break;
                        }
                        if ( 3 == [selectedRegions count] )
                            break;
                    }
                    if ( 3 == [selectedRegions count] )
                        break;
                }
                if ( 3 > [selectedRegions count] )
                {
                        for ( Region *childRegion in self.viewModel.allAddress )
                        {
                            if ( [selectedRegionPathcode isEqualToString:childRegion.PathCode] )
                            {
                                BOOL canAdd = YES;
                                for ( Region *tempRegion in selectedRegions )
                                {
                                    if ( [tempRegion.PathCode isEqualToString:childRegion.PathCode] )
                                    {
                                        canAdd = NO;
                                        break;
                                    }
                                }
                                if ( canAdd )
                                    [selectedRegions addObject:childRegion];
                            }
                            if ( 3 == [selectedRegions count] )
                                break;
                        }
                }
            }
        }
        [cell configWithTitle:region.RegionName childArray:childArray isSelected:isSelected selectedRegions:selectedRegions];
        return cell;
    }
    else if ( tableView == self.searchMatchTableView )
    {
        CPWExpectAddressSearchCell *cell = [CPWExpectAddressSearchCell searchMatchCellWithTableView:tableView];
        Region *hotSearchKey = [self.tempSearchMatchArray objectAtIndex:indexPath.row];
        BOOL isSelecetd = NO;
        BOOL hideSeparator = indexPath.row == [self.tempSearchMatchArray count] - 1;
        for ( NSString *selectedRegionPathcode in self.viewModel.selectedCity )
        {
            if ( [hotSearchKey.PathCode isEqualToString:selectedRegionPathcode] )
            {
                isSelecetd = YES;
                break;
            }
        }
        [cell configSearchMatchCell:hotSearchKey.RegionName matchString:self.matchString hideSeparator:hideSeparator isSelected:isSelecetd];
        return cell;
    }
    else
        return nil;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if ( tableView == self.tableView )
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ( indexPath.row != self.selectedFirstRow )
        {
            NSInteger tempRow = -1;
            if ( -1 != self.selectedFirstRow )
                tempRow = self.selectedFirstRow;
            self.selectedFirstRow = indexPath.row;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            if ( -1 != tempRow )
            {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else
        {
            NSInteger tempRow = -1;
            tempRow = self.selectedFirstRow;
            self.selectedFirstRow = -1;
            if ( -1 != tempRow )
            {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    else if ( tableView == self.searchMatchTableView )
    {
        Region *hotSearchKey = [self.tempSearchMatchArray objectAtIndex:indexPath.row];
        BOOL isSelecetd = NO;
        for ( NSString *selectedRegionPathcode in self.viewModel.selectedCity )
        {
            if ( [hotSearchKey.PathCode isEqualToString:selectedRegionPathcode] )
            {
                isSelecetd = YES;
                break;
            }
        }
        if ( [self.viewModel.selectedCity count] == 3 )
        {
            if ( !isSelecetd )
            {
                if ( !self.maxSelecetdTipsView.isHidden )
                    return;
                [self.maxSelecetdTipsView setHidden:NO];
                [self.maxSelecetdTipsView setAlpha:1.0];
                __weak typeof( self ) weakSelf = self;
                [UIView animateWithDuration:1.50 animations:^{
                    [weakSelf.maxSelecetdTipsView setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [weakSelf.maxSelecetdTipsView setHidden:YES];
                }];
                return;
            }
            else
            {
                for ( NSString *pathCode in self.viewModel.selectedCity )
                {
                    if ( [hotSearchKey.PathCode isEqualToString:pathCode] )
                    {
                        [self.viewModel.selectedCity removeObject:pathCode];
                        break;
                    }
                }
                [self setAddressLabel];
                [self updateHotCityButton:hotSearchKey isSelected:NO];
            }
        }
        else
        {
            if ( !isSelecetd )
            {
                [self.viewModel.selectedCity addObject:hotSearchKey.PathCode];
                [self setAddressLabel];
                [self updateHotCityButton:hotSearchKey isSelected:YES];
            }
            else
            {
                for ( NSString *pathCode in self.viewModel.selectedCity )
                {
                    if ( [hotSearchKey.PathCode isEqualToString:pathCode] )
                    {
                        [self.viewModel.selectedCity removeObject:pathCode];
                        break;
                    }
                }
                [self setAddressLabel];
                [self updateHotCityButton:hotSearchKey isSelected:NO];
            }
        }
        [self.searchMatchTableView reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.tableView )
    {
        if ( self.selectedFirstRow == indexPath.row )
        {
            NSMutableArray *childArray = [self.childCityArrayM objectAtIndex:indexPath.row];
            CGFloat height = 144.0 / CP_GLOBALSCALE * ([childArray count] + 1);
            return height;
        }
        return 144.0 / CP_GLOBALSCALE;
    }
    else if ( tableView == self.searchMatchTableView )
    {
        return 144 / CP_GLOBALSCALE;
    }
    return 0;
}
- (void)setOtherCityWithName:(NSArray *)cityNames
{
    if ( !cityNames || 0 == [cityNames count] )
        return;
    CGFloat buttonX = 40 / CP_GLOBALSCALE;
    CGFloat buttonY = ( 60 + 40 + 42 ) / CP_GLOBALSCALE;
    CGFloat margin = 40 / CP_GLOBALSCALE;
    CGFloat buttonH = 90 / CP_GLOBALSCALE;
    CGFloat buttonW = (kScreenWidth - margin * 5.0) / 4.0;
    NSString *buttonTitleStr = nil;
    for ( NSUInteger index = 0; index < [cityNames count]; index++ )
    {
        Region *region = cityNames[index];
        buttonTitleStr = region.RegionName;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [btn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateSelected];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
        [btn.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [btn.layer setCornerRadius:6 / CP_GLOBALSCALE];
        [btn setTitle:buttonTitleStr forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        buttonX = margin + (buttonW + margin ) * (index % 4);
        buttonY = ( 60 + 40 + 42 ) / CP_GLOBALSCALE + (buttonH + margin) * (index / 4);
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [btn setTag:index];
        [btn addTarget:self action:@selector(clickedHotCityButton:) forControlEvents:UIControlEventTouchUpInside];
        if ( 0 < [self.viewModel.selectedCity count] )
        {
            for ( NSString *regionStr in self.viewModel.selectedCity )
            {
                if ( [regionStr isEqualToString:region.PathCode] )
                {
                    [btn setSelected:YES];
                    [self.hotCitySelectedArrayM addObject:btn];
                }
            }
        }
        [self.hotCityButtonArrayM addObject:btn];
        [self.hotCityBackgroundView addSubview:btn];
    }
    NSInteger intNum = cityNames.count / 4;
    NSInteger floatNum = cityNames.count % 4;
    if ( 0 < floatNum )
        intNum++;
    CGFloat fixldH = ( 60 + 42 + 60 ) / CP_GLOBALSCALE;
    fixldH += ( 90 + 40 ) / CP_GLOBALSCALE * intNum;
    CGFloat topViewHeight = ( 144 + 144 ) / CP_GLOBALSCALE + fixldH;
    [self.topView setFrame:CGRectMake(0, 0, kScreenWidth, topViewHeight)];
}
- (void)updateHotCityButton:(Region *)region isSelected:(BOOL)isSelected
{
    NSString *regionName = region.RegionName;
    for (UIButton *btn in self.hotCityButtonArrayM )
    {
        if ( [btn.titleLabel.text isEqualToString:regionName] )
        {
            [btn setSelected:isSelected];
            if ( isSelected )
                [self.hotCitySelectedArrayM addObject:btn];
            else
                [self.hotCitySelectedArrayM removeObject:btn];
            break;
        }
    }
}
#pragma mark - CPResumeEditFirstAddressCellDelegate
- (void)resumeEditFirstAddressCell:(CPResumeEditFirstAddressCell *)resumeEditFirstAddressCell didSelectedRegion:(Region *)selectedRegion
{
    [self.view endEditing:YES];
    if ( [self.viewModel.selectedCity count] == 3 )
    {
        if ( !self.maxSelecetdTipsView.isHidden )
            return;
        [self.maxSelecetdTipsView setHidden:NO];
        [self.maxSelecetdTipsView setAlpha:1.0];
        __weak typeof( self ) weakSelf = self;
        [UIView animateWithDuration:1.50 animations:^{
            [weakSelf.maxSelecetdTipsView setAlpha:0.0];
        } completion:^(BOOL finished) {
            [weakSelf.maxSelecetdTipsView setHidden:YES];
        }];
        return;
    }
    Region *region = selectedRegion;
    [self.viewModel.selectedCity addObject:region.PathCode];
    [self setAddressLabel];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self updateHotCityButton:region isSelected:YES];
}
- (void)resumeEditFirstAddressCell:(CPResumeEditFirstAddressCell *)resumeEditFirstAddressCell didSelectedRegion:(Region *)selectedRegion isCanAdd:(BOOL)isCanAdd
{
    [self.view endEditing:YES];
    Region *region = selectedRegion;
    if ( isCanAdd )
    {
        [self.viewModel.selectedCity addObject:region.PathCode];
        [self setAddressLabel];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self updateHotCityButton:region isSelected:YES];
    }
    else
    {
        BOOL isExistInSelectedArrayM = NO;
        for ( NSString *pathCode in self.viewModel.selectedCity )
        {
            if ( [selectedRegion.PathCode isEqualToString:pathCode] )
            {
                [self.viewModel.selectedCity removeObject:pathCode];
                isExistInSelectedArrayM = YES;
                break;
            }
        }
        if ( isExistInSelectedArrayM )
        {
            [self setAddressLabel];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self updateHotCityButton:region isSelected:NO];
        }
        else
        {
            if ( [self.viewModel.selectedCity count] == 3 )
            {
                if ( !self.maxSelecetdTipsView.isHidden )
                    return;
                [self.maxSelecetdTipsView setHidden:NO];
                [self.maxSelecetdTipsView setAlpha:1.0];
                __weak typeof( self ) weakSelf = self;
                [UIView animateWithDuration:1.50 animations:^{
                    [weakSelf.maxSelecetdTipsView setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [weakSelf.maxSelecetdTipsView setHidden:YES];
                }];
                return;
            }
        }
    }
}
#pragma mark - event responde method
- (void)clickedHotCityButton:(UIButton *)sender
{
    for ( UIButton *btn in self.hotCitySelectedArrayM )
    {
        if ( ![btn isEqual:sender] )
            continue;
        for ( Region *region in self.cityArray )
        {
            if ( [btn.titleLabel.text isEqualToString:region.RegionName] )
            {
                [btn setSelected:NO];
                [self.viewModel.selectedCity removeObject:region.PathCode];
                [self.hotCitySelectedArrayM removeObject:btn];
                [self setAddressLabel];
                return;
            }
        }
    }
    NSInteger count = [self.viewModel.selectedCity count];
    if ( count == 3 )
    {
        if ( !self.maxSelecetdTipsView.isHidden )
            return;
        [self.maxSelecetdTipsView setHidden:NO];
        [self.maxSelecetdTipsView setAlpha:1.0];
        __weak typeof( self ) weakSelf = self;
        [UIView animateWithDuration:1.50 animations:^{
            [weakSelf.maxSelecetdTipsView setAlpha:0.0];
        } completion:^(BOOL finished) {
            [weakSelf.maxSelecetdTipsView setHidden:YES];
        }];
        return;
    }
    [sender setSelected:YES];
    [self.hotCitySelectedArrayM addObject:sender];
    Region *region = [self.cityArray objectAtIndex:sender.tag];
    [self.viewModel.selectedCity addObject:region.PathCode];
    [self setAddressLabel];
}
#pragma mark - ExpectAddressChooseVMDelegate
- (void)expectAddressChoose:(ExpectAddressVM *)expectAddressChoose locationCity:(NSString *)locationCity
{
    NSString *cityName = nil;
    if ( ![locationCity isEqualToString:@"无法定位"] )
        cityName = [locationCity substringToIndex:locationCity.length - 1];
    else
        cityName = locationCity;
    [self.localButton setTitle:cityName forState:UIControlStateNormal];
    [self stopButtonAnimationWithButton:self.resetLocalButton];
}
#pragma mark - 定位动画
- (void)startButtonAnimationWithButton:(UIButton *)repeatButton
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 5;
    [repeatButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)stopButtonAnimationWithButton:(UIButton *)repeatButton
{
    [repeatButton.layer removeAllAnimations];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark 搜索模糊搜索
- (void)searMatch:(NSString*)searchKey
{
    self.tempSearchMatchArray = [Region searchRegionWithRegionName:searchKey];
    if( self.tempSearchMatchArray )
    {
        self.searchMatchTableView.hidden = NO;
        [self.searchMatchTableView reloadData];
    }
    else
    {
        self.searchMatchTableView.hidden = NO;
        [self.searchMatchTableView reloadData];
    }
}
#pragma mark - getter method
- (UIView *)topView
{
    if ( !_topView )
    {
        NSInteger intNum = self.cityArray.count / 4;
        NSInteger floatNum = self.cityArray.count % 4;
        if ( 0 < floatNum )
            intNum++;
        else
            intNum = 7;
        CGFloat topViewHeight = ( 144 + 60 + 42 + 90 * intNum + 40 * intNum + 60 + 144 ) / CP_GLOBALSCALE;
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topViewHeight )];
//        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_topView.layer setMasksToBounds:YES];
        UILabel *staticLocalCity = [[UILabel alloc] init];
        [staticLocalCity setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [staticLocalCity setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [staticLocalCity setText:@"定位城市"];
        [_topView addSubview:staticLocalCity];
        [staticLocalCity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _topView.mas_top );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
        CPResumeEditLocalAddressButton *localButton = [CPResumeEditLocalAddressButton buttonWithType:UIButtonTypeCustom];
        [localButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [localButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [localButton.layer setMasksToBounds:YES];
        [localButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [localButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [localButton setTitle:@"广州" forState:UIControlStateNormal];
        [localButton setImage:[UIImage imageNamed:@"ic_location"] forState:UIControlStateNormal];
        [localButton.layer setCornerRadius:6 / CP_GLOBALSCALE];
        [_topView addSubview:localButton];
        self.localButton = localButton;
        [localButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( staticLocalCity.mas_centerY );
            make.width.equalTo( @( 220 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 90 / CP_GLOBALSCALE ) );
            make.left.equalTo( staticLocalCity.mas_right ).offset( 40 / CP_GLOBALSCALE );
        }];
        __weak typeof( self ) weakSelf = self;
        [self.localButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( 3 == [weakSelf.viewModel.selectedCity count] )
            {
                if ( !self.maxSelecetdTipsView.isHidden )
                    return;
                [self.maxSelecetdTipsView setHidden:NO];
                [self.maxSelecetdTipsView setAlpha:1.0];
                __weak typeof( self ) weakSelf = self;
                [UIView animateWithDuration:1.50 animations:^{
                    [weakSelf.maxSelecetdTipsView setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [weakSelf.maxSelecetdTipsView setHidden:YES];
                }];
                return;
            }
            Region *region = nil;
            NSString *locationStr = weakSelf.localButton.titleLabel.text;
            for ( NSMutableArray *firstArray in weakSelf.childCityArrayM )
            {
                for ( Region *regionData in firstArray )
                {
                    if ( [locationStr isEqualToString:regionData.RegionName] )
                    {
                        region = regionData;
                        break;
                    }
                }
                if ( region )
                    break;
            }
            if ( !region )
                return;
            for ( NSString *pathCode in weakSelf.viewModel.selectedCity )
            {
                if ( [region.PathCode isEqualToString:pathCode] )
                    return;
            }
            [weakSelf.viewModel.selectedCity addObject:region.PathCode];
            [weakSelf updateHotCityButton:region isSelected:YES];
            [weakSelf setAddressLabel];
            if ( -1 != self.selectedFirstRow )
            {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        UIButton *resetLocalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [resetLocalButton setImage:[UIImage imageNamed:@"ic_repeat"] forState:UIControlStateNormal];
        [_topView addSubview:resetLocalButton];
        self.resetLocalButton = resetLocalButton;
        [resetLocalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _topView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo( staticLocalCity.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [resetLocalButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [weakSelf startButtonAnimationWithButton:sender];
            [weakSelf.localButton setTitle:@"定位..." forState:UIControlStateNormal];
            [weakSelf.viewModel beginLocation];
        }];
        UIView *separatorLineSecond = [[UIView alloc] init];
        [separatorLineSecond setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topView addSubview:separatorLineSecond];
        [separatorLineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( staticLocalCity.mas_bottom );
            make.left.equalTo( _topView.mas_left );
            make.right.equalTo( _topView.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [_topView addSubview:self.hotCityBackgroundView];
        [self.hotCityBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLineSecond.mas_bottom );
            make.left.equalTo( _topView.mas_left );
            make.right.equalTo( _topView.mas_right );
            make.bottom.equalTo( _topView.mas_bottom );
        }];
        UIView *separatorLineThird = [[UIView alloc] init];
        [separatorLineThird setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topView addSubview:separatorLineThird];
        [separatorLineThird mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _topView.mas_bottom ).offset( -(60 + 42 + 40) / CP_GLOBALSCALE );
            make.left.equalTo( _topView.mas_left );
            make.right.equalTo( _topView.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        
        UILabel *otherCityTitle = [[UILabel alloc] init];
        [otherCityTitle setText:@"其它城市"];
        [otherCityTitle setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [otherCityTitle setTextColor:[UIColor colorWithHexString:@"707070"]];\
        [_topView addSubview:otherCityTitle];
        [otherCityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo( @( otherCityTitle.font.pointSize ) );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _topView.mas_bottom ).offset( -40 / CP_GLOBALSCALE );
        }];
        UIView *separatorLineFour = [[UIView alloc] init];
        [separatorLineFour setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topView addSubview:separatorLineFour];
        [separatorLineFour mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _topView.mas_bottom );
            make.left.equalTo( _topView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _topView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _topView;
}
- (CPSearchWithRightTextField *)searchCityTextField
{
    if ( !_searchCityTextField )
    {
        CPSearchWithRightTextField *text = [[CPSearchWithRightTextField alloc] init];
        UIView *imageBackView = [[UIView alloc] init];
        [imageBackView setBackgroundColor:[UIColor redColor]];
        UIImageView *customLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_ic_search"]];
        CGFloat leftW = customLeftView.image.size.width / CP_GLOBALSCALE;
        CGFloat leftH = customLeftView.image.size.height / CP_GLOBALSCALE;
        customLeftView.frame = CGRectMake(0.0, ( 90 - 48 ) / CP_GLOBALSCALE / 2.0, leftW, leftH);
        [imageBackView addSubview:customLeftView];
        text.leftView = imageBackView;
        text.leftView.backgroundColor = [UIColor clearColor];
        text.leftViewMode = UITextFieldViewModeAlways;
        text.layer.cornerRadius = 90 / CP_GLOBALSCALE / 2.0;
        text.layer.masksToBounds = YES;
        text.placeholder = @"请输入城市名称";
        text.font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
        text.textColor = [UIColor colorWithHexString:@"404040"];
        text.background = [[UIImage imageWithColor:[UIColor colorWithHexString:@"f0f2f5"] cornerRadius:0.0] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        _searchCityTextField = text;
    }
    return _searchCityTextField;
}
- (UIView *)hotCityBackgroundView
{
    if ( !_hotCityBackgroundView )
    {
        _hotCityBackgroundView = [[UIView alloc] init];
        [_hotCityBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        UILabel *otherCityTitleLabel = [[UILabel alloc] init];
        [otherCityTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        
        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithString:@"热门城市"];
        [attStrM addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"707070"]} range:NSMakeRange(0, [attStrM length])];
        
        [otherCityTitleLabel setAttributedText:[attStrM copy]];
        [_hotCityBackgroundView addSubview:otherCityTitleLabel];
        [otherCityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _hotCityBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _hotCityBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( otherCityTitleLabel.font.pointSize ) );
        }];
    }
    return _hotCityBackgroundView;
}
- (UIView *)searchTopView
{
    if ( !_searchTopView )
    {
        _searchTopView = [[UIView alloc] init];
        [_searchTopView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_searchTopView addSubview:self.searchCityTextField];
        [self.searchCityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _searchTopView.mas_top ).offset( (144 - 90) / CP_GLOBALSCALE / 2.0 );
            make.left.equalTo( _searchTopView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _searchTopView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 90 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_searchTopView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( _searchTopView.mas_bottom );
            make.left.equalTo( _searchTopView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( _searchTopView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    return _searchTopView;
}
- (NSMutableArray *)childCityArrayM
{
    if ( !_childCityArrayM )
    {
        _childCityArrayM = [NSMutableArray array];
    }
    return _childCityArrayM;
}
- (NSMutableArray *)hotCitySelectedArrayM
{
    if ( !_hotCitySelectedArrayM )
    {
        _hotCitySelectedArrayM = [NSMutableArray array];
    }
    return _hotCitySelectedArrayM;
}
- (NSMutableArray *)hotCityButtonArrayM
{
    if ( !_hotCityButtonArrayM )
    {
        _hotCityButtonArrayM = [NSMutableArray array];
    }
    return _hotCityButtonArrayM;
}
- (UIView *)maxSelecetdTipsView
{
    if ( !_maxSelecetdTipsView )
    {
        CGFloat W = 575 / CP_GLOBALSCALE;
        CGFloat H = 170 / CP_GLOBALSCALE;
        CGFloat X = ( kScreenWidth - W ) / 2.0;
        CGFloat Y = kScreenHeight - 144 / CP_GLOBALSCALE * 3 - H;
        _maxSelecetdTipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [_maxSelecetdTipsView.layer setCornerRadius:H / 2.0];
        [_maxSelecetdTipsView.layer setMasksToBounds:YES];
        [_maxSelecetdTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000"]];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [titleLabel setText:@"最多可选择3个！"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_maxSelecetdTipsView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _maxSelecetdTipsView.mas_top );
            make.left.equalTo( _maxSelecetdTipsView.mas_left );
            make.bottom.equalTo( _maxSelecetdTipsView.mas_bottom );
            make.right.equalTo( _maxSelecetdTipsView.mas_right );
        }];
        [_maxSelecetdTipsView setAlpha:0.0];
        [_maxSelecetdTipsView setHidden:YES];
    }
    return _maxSelecetdTipsView;
}
- (UITableView *)searchMatchTableView
{
    if ( !_searchMatchTableView )
    {
        _searchMatchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _searchMatchTableView.delegate = self;
        _searchMatchTableView.dataSource = self;
        _searchMatchTableView.hidden = YES;
        _searchMatchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchMatchTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    }
    return _searchMatchTableView;
}
@end
