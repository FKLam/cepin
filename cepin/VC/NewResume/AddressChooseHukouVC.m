//
//  AddressChooseVC.m
//  cepin
//
//  Created by ceping on 15-3-19.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddressChooseHukouVC.h"
#import "AddressChooseHuKouVM.h"
#import "CPCommon.h"
#import "RegionDTO.h"
#import "ChooseCell.h"
#import "TBTextUnit.h"
#import "AddressChooseSecondHukouVC.h"
#import "CPSearchTextField.h"
#import "AddressPresentCell.h"
#import "OtherAddressCell.h"
#import "TBAppDelegate.h"
#import "CPResumeEditFirstAddressCell.h"
#import "CPResumeEditLocalAddressButton.h"
#import "CPResumeInforAddressMatchCityCell.h"
#import "CPSearchWithRightTextField.h"
#import "CPChineseString.h"
#import "CPPinyin.h"
@interface AddressChooseHukouVC ()<CPResumeEditFirstAddressCellDelegate, AddressChooseHuKouVMDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,retain)AddressChooseHuKouVM *viewModel;
@property(nonatomic,assign)BOOL isjg;
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
@property (nonatomic, strong) NSMutableArray *searchCityResultArrayM;
@property (nonatomic, strong) NSString *searchMatchString;
@end

@implementation AddressChooseHukouVC
-(instancetype)initWithModel:(ResumeNameModel*)model
{
    if (self = [super init])
    {
        self.viewModel = [[AddressChooseHuKouVM alloc] initWithSendModel:model];
        [self.viewModel setAddressChooseHuKouDelegate:self];
        [self.viewModel beginLocation];
        self.model = model;
        self.searchCityResultArrayM = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"城市选择";
    self.selectedFirstRow = -1;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.view addSubview:self.searchTopView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 144 / CP_GLOBALSCALE, kScreenWidth, self.view.viewHeight - 64 - 144 / CP_GLOBALSCALE) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.topView;
    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    __weak typeof( self ) weakSelf = self;
    [self.searchCityTextField.rac_textSignal subscribeNext:^(NSString *text) {
       
        if(nil == text || NULL == text || [text isEqualToString:@""]){
           self.searchCityTableView.hidden = YES;
            self.tableView.hidden = NO;
            return ;
        }
    }];
    
    NSMutableArray *thirdArray =  self.viewModel.allAddress;
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
    self.viewModel.allAddress = [NSMutableArray arrayWithArray:sortedArr];
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
                     rg.PathCode = @"";
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
            Region *selectedRegion = self.viewModel.selectedCity[0];
            if ( [selectedRegion.RegionName isEqualToString:region.RegionName] )
            {
                [btn setSelected:YES];
                self.selectedHotCityButton = btn;
            }
        }
        else if(index==0){
            [btn setSelected:YES];
            self.selectedHotCityButton = btn;
        }
        [self.hotCityBackgroundView addSubview:btn];
    }
    NSInteger intNum = cityNames.count / 4;
    NSInteger floatNum = cityNames.count % 4;
    if ( 0 < floatNum )
        intNum++;
    CGFloat fixldH = ( 60 + 42 + 60 ) / CP_GLOBALSCALE;
    fixldH += ( 90 + 40 ) / CP_GLOBALSCALE * intNum;
    CGFloat topViewHeight = ( 144 + 144 ) / CP_GLOBALSCALE + fixldH;
    self.topView.viewHeight = topViewHeight;
}

- (void)textFieldTextDidChangeOneCI:(UITextField *)textField
{
    self.searchMatchString = textField.text;
    NSArray *searchResultArray = [self searchMatchAddressWithMatchString:textField.text originArray:[self.allCityArrayM copy]];
    if ( [self.searchCityResultArrayM count] > 0 )
        [self.searchCityResultArrayM removeAllObjects];
    if ( searchResultArray.count > 0 )
    {
        [self.searchCityResultArrayM addObjectsFromArray:searchResultArray];
    }
    [self.searchCityTableView setHidden:NO];
    [self.tableView setHidden:YES];
    [self.searchCityTableView reloadData];
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
        //            NSLog(@"firstLetter=%@",chineseString.pinYin);
        //            [chineseStringsArray addObject:chineseString];
    }
    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES]];
    NSArray *sortedArr = [thirdArray sortedArrayUsingDescriptors:sortDesc];
    return sortedArr;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (NSArray *)searchMatchAddressWithMatchString:(NSString *)matchString originArray:(NSArray *)originArray
{
    NSMutableArray *arrayM = [NSMutableArray array];
    if ( !matchString || 0 == [matchString length] )
        return arrayM;
    NSArray *allAddress = originArray;
    for ( Region *region in allAddress )
    {
        NSRange range = [region.RegionName rangeOfString:matchString];
        if ( range.location == NSNotFound )
        {
            continue;
        }
        [arrayM addObject:region];
    }
    return arrayM;
}

- (void)clickedHotCityButton:(UIButton *)sender
{
    if ( sender == self.selectedHotCityButton )
    {
        [sender setSelected:NO];
        self.selectedHotCityButton = nil;
    }
    [self.selectedHotCityButton setSelected:NO];
    [sender setSelected:YES];
    self.selectedHotCityButton = sender;
    if (self.viewModel.selectedCity) {
        [self.viewModel.selectedCity removeAllObjects];
    }
    Region *region = [self.cityArray objectAtIndex:sender.tag];
    [self.viewModel.selectedCity addObject:region.PathCode];
    [self.model setHukou:region.RegionName];
    [self.model setHukouKey:region.PathCode];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    for ( Region *region in self.viewModel.allAddress )
    {
        NSMutableArray *thirdArray = [NSMutableArray arrayWithArray:[self getThirdRegionWithRegion:region]];
        if ( 0 == [thirdArray count] )
            thirdArray = [NSMutableArray arrayWithObject:region];
        [self.childCityArrayM addObject:thirdArray];
    }
    for ( NSMutableArray * childArray in self.childCityArrayM )
    {
        [self.allCityArrayM addObjectsFromArray:childArray];
    }
}
#pragma mark UITableViewDataScource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.tableView )
        return self.viewModel.allAddress.count;
    else
        if ( self.searchCityTableView == tableView )
            return [self.searchCityResultArrayM count];
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
        Region *selectedRegion = nil;
        if ( 0 < [self.viewModel.selectedCity count] )
            selectedRegion = self.viewModel.selectedCity[0];
        [cell configWithTitle:region.RegionName childArray:childArray isSelected:isSelected selectedRegion:selectedRegion];
        return cell;
    }
    else if ( self.searchCityTableView == tableView )
    {
        CPResumeInforAddressMatchCityCell *cell = [CPResumeInforAddressMatchCityCell searchMatchCellWithTableView:tableView];
        Region *region = self.searchCityResultArrayM[indexPath.row];
        BOOL isSelected = NO;
        Region *selectedRegion = nil;
        if ( 0 < [self.viewModel.selectedCity count] )
            selectedRegion = self.viewModel.selectedCity[0];
        if ( [region.PathCode isEqualToString:selectedRegion.PathCode] )
            isSelected = YES;
        BOOL isShowAll = NO;
        if ( indexPath.row == [self.searchCityResultArrayM count] - 1 )
            isShowAll = YES;
        [cell configSearchMatchCell:region matchString:self.searchMatchString hideSeparator:isShowAll isSelected:isSelected];
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
    
    else if ( tableView == self.searchCityTableView )
    {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.searchCityTextField endEditing:YES];
        if (self.viewModel.selectedCity) {
            [self.viewModel.selectedCity removeAllObjects];
        }
        Region *region = self.searchCityResultArrayM[indexPath.row];
        [self.viewModel.selectedCity addObject:region];
        [self.model setHukou:region.RegionName];
        [self.model setHukouKey:region.PathCode];
        [self.viewModel.selectedCity addObject:region];
        [self.searchCityTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
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
    else if ( tableView == self.searchCityTableView )
    {
        return 144 / CP_GLOBALSCALE;
    }
    return 0;
}
#pragma mark - CPResumeEditFirstAddressCellDelegate
- (void)resumeEditFirstAddressCell:(CPResumeEditFirstAddressCell *)resumeEditFirstAddressCell didSelectedRegion:(Region *)selectedRegion
{
    if (self.viewModel.selectedCity) {
        [self.viewModel.selectedCity removeAllObjects];
    }
    Region *region = selectedRegion;
    [self.viewModel.selectedCity addObject:region.PathCode];
    [self.model setHukou:region.RegionName];
    [self.model setHukouKey:region.PathCode];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - AddressChooseHuKouVMDelegate
- (void)addressChooseHuKouVM:(AddressChooseHuKouVM *)addressChooseHuKou locationCity:(NSString *)locationCity
{
    NSString *cityName = nil;
    if ( ![locationCity isEqualToString:@"无法定位"] )
        cityName = [locationCity substringToIndex:locationCity.length - 1];
    else
        cityName = locationCity;
    [self.localButton setTitle:cityName forState:UIControlStateNormal];
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
//        else
//            intNum = 7;
        CGFloat topViewHeight = ( 144 + 60 + 42 + 90 * intNum + 40 * intNum + 60 + 144 ) / CP_GLOBALSCALE;
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 144 / CP_GLOBALSCALE, kScreenWidth, topViewHeight )];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
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
        [localButton.layer setCornerRadius:6 / CP_GLOBALSCALE];
        [localButton setImage:[UIImage imageNamed:@"ic_location"] forState:UIControlStateNormal];
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
            
            if (weakSelf.viewModel.selectedCity) {
                [weakSelf.viewModel.selectedCity removeAllObjects];
            }
            [weakSelf.viewModel.selectedCity addObject:region.PathCode];
            [weakSelf.model setHukou:region.RegionName];
            [weakSelf.model setHukouKey:region.PathCode];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        UIButton *resetLocalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [resetLocalButton setImage:[UIImage imageNamed:@"ic_repeat"] forState:UIControlStateNormal];
        [_topView addSubview:resetLocalButton];
        [resetLocalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _topView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo( staticLocalCity.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [resetLocalButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            [weakSelf startButtonAnimationWithButton:sender];
            [weakSelf.localButton setTitle:@"定位..." forState:UIControlStateNormal];
            [weakSelf.viewModel beginLocation];
        }];
        UIView *separatorLineSecond = [[UIView alloc] init];
        [separatorLineSecond setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_topView addSubview:separatorLineSecond];
        self.secondSeparatorLine = separatorLineSecond;
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
        text.rightViewMode = UITextFieldViewModeAlways;
        text.leftView.backgroundColor = [UIColor clearColor];
        text.leftViewMode = UITextFieldViewModeAlways;
        text.layer.cornerRadius = 90 / CP_GLOBALSCALE / 2.0;
        text.layer.masksToBounds = YES;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.placeholder = @"请输入城市名称";
        text.font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
        text.textColor = [UIColor colorWithHexString:@"404040"];
        text.background = [[UIImage imageWithColor:[UIColor colorWithHexString:@"f0f2f5"] cornerRadius:0.0] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [text addTarget:self action:@selector(textFieldTextDidChangeOneCI:) forControlEvents:UIControlEventEditingChanged];
        text.delegate = self;
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
        _searchTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 144 / CP_GLOBALSCALE)];
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
- (NSMutableArray *)allCityArrayM
{
    if ( !_allCityArrayM )
    {
        _allCityArrayM = [NSMutableArray array];
    }
    return _allCityArrayM;
}
- (UITableView *)searchCityTableView
{
    if ( !_searchCityTableView )
    {
        _searchCityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144 / CP_GLOBALSCALE + 64, kScreenWidth, kScreenHeight - 144 / CP_GLOBALSCALE - 64) style:UITableViewStylePlain];
        [_searchCityTableView setDataSource:self];
        [_searchCityTableView setDelegate:self];
        [_searchCityTableView setHidden:YES];
        [_searchCityTableView setBackgroundColor:[UIColor whiteColor]];
        [_searchCityTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _searchCityTableView;
}
@end
