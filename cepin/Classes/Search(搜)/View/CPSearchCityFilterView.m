//
//  CPSearchCityFilterView.m
//  cepin
//
//  Created by dujincai on 16/2/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchCityFilterView.h"
#import "CPSearchTextField.h"
#import "TBAppDelegate.h"
#import "RegionDTO.h"
#import "CPResumeEditLocalAddressButton.h"
#import "CPSearchMatchCell.h"
#import <CoreLocation/CoreLocation.h>
#import "CPCommon.h"
@interface CPSearchCityFilterView ()<UITableViewDelegate,UITableViewDataSource,NSLayoutManagerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UIView *hotSearchBackground;
@property (nonatomic, strong) UIImageView *titleBlueLineImageView;
@property (nonatomic, strong) UILabel *hotSearchLabel;
@property(nonatomic,strong)NSArray *hotKeyArray;
//@property(nonatomic,strong)CPSearchTextField *searchTextFiled;
@property (nonatomic, strong) UIView *localCityBackgroundView;
@property (nonatomic, strong) UIView *localCityView;
@property (nonatomic, strong) UILabel *localCityLabel;
@property (nonatomic, strong) UILabel *localCityTitleLabel;
@property (nonatomic, strong) UIView *otherCityBackgroundView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *citySelectBtn;//一选中的btn
@property(nonatomic,strong)UITableView *matchTableView;//用于城市的模糊搜索
@property (nonatomic, copy) NSArray *tempSearchMatchArray;
@property(nonatomic,strong)NSString  *matchString;
@property(nonatomic,strong)CPResumeEditLocalAddressButton *localButton;//定位城市
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIButton *resetLocalButton ;
@property (nonatomic,strong)UIView *separatorLine;
@property (nonatomic,strong)UILabel *otherCityTitle;
@property (nonatomic,strong)UIView *separatorLineThird;
@property (nonatomic,strong)UIView *separatorLineFour;
@end

@implementation CPSearchCityFilterView

-(instancetype)initWithFrame:(CGRect)frame city:(NSString *)selectCity otherCityHeight:(CGFloat)height{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor=[UIColor whiteColor];
        _selectCity = selectCity;
        
        [self addSubview:self.localCityBackgroundView];
        [self.localCityBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left ).offset(40/CP_GLOBALSCALE);
            make.height.equalTo(@( 144 / CP_GLOBALSCALE ) );
            make.right.equalTo(self.mas_right );
        }];
        self.separatorLine = [[UIView alloc] init];
        [self addSubview:_separatorLine];
        [_separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.top.equalTo( _localCityBackgroundView.mas_bottom);
            make.width.equalTo( self.mas_width);
        }];
        [self addSubview:self.otherCityBackgroundView];
        [self.otherCityBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatorLine.mas_bottom).offset(60/CP_GLOBALSCALE);
            make.left.equalTo( self.mas_left);
            make.height.equalTo(@(height));
            make.right.equalTo( self.mas_right );
        }];
        _separatorLineThird = [[UIView alloc] init];
        [_separatorLineThird setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:_separatorLineThird];
        [_separatorLineThird mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.otherCityBackgroundView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.mas_left );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        self.otherCityTitle = [[UILabel alloc] init];
        [_otherCityTitle setText:@"其它城市"];
        [_otherCityTitle setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_otherCityTitle setTextColor:[UIColor colorWithHexString:@"707070"]];\
        [self addSubview:_otherCityTitle];
        [_otherCityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo( @( _otherCityTitle.font.pointSize ) );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo(_separatorLineThird.mas_bottom ).offset(-60/CP_GLOBALSCALE);
        }];
        self.separatorLineFour = [[UIView alloc] init];
        [self.separatorLineFour setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self addSubview:self.separatorLineFour];
        [self.separatorLineFour mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom );
            make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        NSString *locationCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
        if(nil==locationCity || [locationCity isEqualToString:@""]){
            locationCity=@"全国";
        }
        [self setLocalCityString:locationCity];
        TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
        //判断是否已经请求过热门城市的接口
        if(nil == delegate.cityData){
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
                         for (int i=0;i<array.count; i++) {
                             Region *region = [Region beanFromDictionary:array[i]];
                             [self.cityArray addObject:region];
                         }
                         [self setOtherCityWithName:self.cityArray];
                         [delegate setCityData:self.cityArray];
                     }
                 }
             }];
        }else{
            self.cityArray = delegate.cityData;
            [self setOtherCityWithName:delegate.cityData];
        }
    }
    return self;
}
#pragma mark-更新热门城市选中按钮
-(void)configView{
    NSArray *views = [_otherCityBackgroundView subviews];
    for(UIView *view in views)
    {
        if ([view isKindOfClass:[UIButton class]]) {
            if (((UIButton *)view).titleLabel.text) {
                if (self.selectCity) {
                    if ([((UIButton *)view).titleLabel.text isEqualToString:self.selectCity]) {
                        ((UIButton *)view).selected = YES;
                    }else{
                        ((UIButton *)view).selected = NO;
                    }
                }
            }
        }
    }
}
- (void)beginLocation
{
    if ( [CLLocationManager locationServicesEnabled] == FALSE )
        return;
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [locations firstObject];
    __weak typeof( self ) weakSelf = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ( error )
        {
            [weakSelf.localButton setTitle:@"全国" forState:UIControlStateNormal];
            [weakSelf stopButtonAnimationWithButton:_resetLocalButton];
            
        }
        if ( placemarks.count > 0 )
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *city = placemark.locality;
            if ( !city )
                city = placemark.administrativeArea;
            if ([city rangeOfString:@"市"].location != NSNotFound) {
                NSRange range = [city rangeOfString:@"市"];//匹配得到的下标
                city = [city substringToIndex:range.location];
            }
            weakSelf.selectCity = city;
            [weakSelf.localButton setTitle:city forState:UIControlStateNormal];
            [weakSelf stopButtonAnimationWithButton:_resetLocalButton];
        }
        
    }];
}
- (CLLocationManager *)locationManager
{
    if ( !_locationManager )
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        if ( [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] )
        {
            [_locationManager requestWhenInUseAuthorization];
//            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}
- (UITableView *)matchTableView
{
    if ( !_matchTableView )
    {
        _matchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.viewHeight - 49.0) style:UITableViewStylePlain];
        _matchTableView.delegate = self;
        _matchTableView.dataSource = self;
        _matchTableView.hidden = YES;
        _matchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_matchTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    }
    return _matchTableView;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ( 0 == range.length )
    {
        self.matchString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    }
    else if ( 1 == range.length )
    {
        if ( [textField.text length] > 1 )
            self.matchString = [textField.text substringWithRange:NSMakeRange(0, [textField.text length] - 1)];
        else
        {
            self.tempSearchMatchArray = nil;
            self.matchString = nil;
        }
    }
    [self searMatch:textField.text];
    return YES;
}
#pragma mark 搜索模糊搜索
-(void)searMatch:(NSString*)searchKey{
    self.tempSearchMatchArray = [Region searchRegionWithRegionName:searchKey];
    if(self.tempSearchMatchArray){
        self.matchTableView.hidden = NO;
        self.otherCityBackgroundView.hidden = YES;
        self.localCityBackgroundView.hidden = YES;
        [self.matchTableView reloadData];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tempSearchMatchArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 144/CP_GLOBALSCALE;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CPSearchMatchCell *cell = [CPSearchMatchCell searchMatchCellWithTableView:tableView];
    Region *hotSearchKey = [self.tempSearchMatchArray objectAtIndex:indexPath.row];
    BOOL hideSeparator = indexPath.row == [self.tempSearchMatchArray count] - 1;
    [cell configSearchMatchCell:hotSearchKey.RegionName matchString:self.matchString hideSeparator:hideSeparator];
    self.matchTableView.hidden = YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CPSearchMatchCell *cell = [CPSearchMatchCell searchMatchCellWithTableView:tableView];
    Region *hotSearchKey = [self.tempSearchMatchArray objectAtIndex:indexPath.row];
    BOOL hideSeparator = indexPath.row == [self.tempSearchMatchArray count] - 1;
    [cell configSearchMatchCell:hotSearchKey.RegionName matchString:self.matchString hideSeparator:hideSeparator];
    return cell;
}
- (UIView *)otherCityBackgroundView
{
    if ( !_otherCityBackgroundView )
    {
        _otherCityBackgroundView = [[UIView alloc] init];
        [_otherCityBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        UILabel *otherCityTitleLabel = [[UILabel alloc] init];
        [otherCityTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        [otherCityTitleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        otherCityTitleLabel.text = @"热门城市";
        [_otherCityBackgroundView addSubview:otherCityTitleLabel];
        [otherCityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _otherCityBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _otherCityBackgroundView.mas_left).offset(40/CP_GLOBALSCALE);
            make.height.equalTo( @( otherCityTitleLabel.font.pointSize ) );
        }];
    }
    return _otherCityBackgroundView;
}

- (UIView *)localCityView
{
    if ( !_localCityView )
    {
        _localCityView = [[UIView alloc]init];
        _localCityView.layer.borderWidth = 1;
        _localCityView.layer.borderColor = [[UIColor colorWithHexString:@"288add"] CGColor];
        _localCityView.layer.cornerRadius = 6 / CP_GLOBALSCALE;
        
        UIImageView *locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_location"]];
        CGFloat leftW = locationView.image.size.width / CP_GLOBALSCALE;
        CGFloat leftH = locationView.image.size.height / CP_GLOBALSCALE;
        [_localCityView addSubview:locationView];
        [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_localCityView.mas_left).offset(40/CP_GLOBALSCALE);
            make.width.equalTo(@(leftW));
            make.height.equalTo(@(leftH));
            make.centerY.equalTo(_localCityView.mas_centerY);
        }];
        
        _localCityLabel = [[UILabel alloc] init];
        [_localCityLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_localCityLabel setTextColor:[UIColor colorWithHexString:@"288add" ]];
        _localCityLabel.text = @"广州";
        [_localCityView addSubview:_localCityLabel];
        [_localCityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(locationView.mas_left).offset(20/CP_GLOBALSCALE);
            make.width.equalTo(@(40));
            make.centerY.equalTo(_localCityView.mas_centerY);
        }];
    }
    return _localCityView;
}
#pragma mark - getter methods
- (UIView *)localCityBackgroundView
{
    if ( !_localCityBackgroundView )
    {
        _localCityBackgroundView = [[UIView alloc] init];
        [_localCityBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        _localCityTitleLabel = [[UILabel alloc] init];
        [_localCityTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_localCityTitleLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        _localCityTitleLabel.text=@"定位城市";
        [_localCityBackgroundView addSubview:_localCityTitleLabel];
        [self.localCityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _localCityBackgroundView.mas_top );
            make.left.equalTo( _localCityBackgroundView.mas_left );
            make.bottom.equalTo( _localCityBackgroundView.mas_bottom );
//            make.width.equalTo(@(60));
        }];
        _localButton = [CPResumeEditLocalAddressButton buttonWithType:UIButtonTypeCustom];
        [_localButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [_localButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [_localButton.layer setMasksToBounds:YES];
        [_localButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_localButton.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_localButton setTitle:@"广州" forState:UIControlStateNormal];
        [_localButton.layer setCornerRadius:6 / CP_GLOBALSCALE];
        [_localButton setImage:[UIImage imageNamed:@"ic_location"] forState:UIControlStateNormal];
        [_localCityBackgroundView addSubview:_localButton];
        [_localButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( _localCityTitleLabel.mas_centerY );
            make.width.equalTo( @( 220 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 90 / CP_GLOBALSCALE ) );
            make.left.equalTo( _localCityTitleLabel.mas_right ).offset( 40 / CP_GLOBALSCALE );
        }];
        
        [_localButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
           
            if ([_localButton.titleLabel.text isEqualToString:@"全国"]) {
                Region *region = [Region new];
                region.RegionName = @"全国";
                region.PathCode = @"";
                [self.hotCityfilterChangeDeleger hotCitySelect:region];
                return ;
            }
            
            
            Region *region = [Region searchAddressWithAddressString:_localButton.titleLabel.text];
            if (region) {
//                NSLog(@"regiion=%@",region.RegionName);
                [self.hotCityfilterChangeDeleger hotCitySelect:region];
            }
            
        }];
        
        self.resetLocalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetLocalButton setImage:[UIImage imageNamed:@"ic_repeat"] forState:UIControlStateNormal];
        [_localCityBackgroundView addSubview:_resetLocalButton];
        [_resetLocalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _localCityBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo( _localCityTitleLabel.mas_centerY );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        [_resetLocalButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            [self startButtonAnimationWithButton:sender];
            [self.localButton setTitle:@"定位..." forState:UIControlStateNormal];
            [self beginLocation];
        }];
    }
    return _localCityBackgroundView;
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

- (void)setLocalCityString:(NSString *)cityName
{
    self.localCityLabel.text = cityName;
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
        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        
//        [btn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
//        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateSelected];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
        [btn.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [btn.layer setCornerRadius:6 / CP_GLOBALSCALE];
        
        if (_selectCity && [_selectCity isEqualToString:buttonTitleStr]) {
            [btn setSelected:YES];
            self.citySelectBtn = btn;
        }
        [btn setTitle:buttonTitleStr forState:UIControlStateNormal];
        [btn setTag:index];
        [btn addTarget:self action:@selector(clickCity:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setMasksToBounds:YES];
        
        buttonX = margin + (buttonW + margin ) * (index % 4);
        buttonY = ( 60 + 40 + 42 ) / CP_GLOBALSCALE + (buttonH + margin) * (index / 4);
        
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self.otherCityBackgroundView addSubview:btn];
        
    }
    
    NSInteger intNum = cityNames.count / 4;
    NSInteger floatNum = cityNames.count % 4;
    if ( 0 < floatNum )
        intNum++;
    CGFloat fixldH = ( 60 + 42 ) / CP_GLOBALSCALE;
    fixldH += ( 90 + 40 ) / CP_GLOBALSCALE * intNum;
//    CGFloat topViewHeight = ( 144 + 144 ) / CP_GLOBALSCALE + fixldH;
    [self.otherCityBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_separatorLine.mas_bottom);
        make.left.equalTo( self.mas_left);
        make.height.equalTo(@(fixldH));
        make.right.equalTo( self.mas_right );
    }];
    
    [_separatorLineThird mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.otherCityBackgroundView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
        make.left.equalTo( self.mas_left );
        make.right.equalTo( self.mas_right );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
    }];

    
    [_otherCityTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo( @( _otherCityTitle.font.pointSize ) );
        make.left.equalTo( self.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.top.equalTo(_separatorLineThird.mas_bottom).offset(60/CP_GLOBALSCALE);
    }];
    
    [self.separatorLineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.otherCityTitle.mas_bottom ).offset(40/CP_GLOBALSCALE);
        make.left.equalTo( self.mas_left ).offset( 40 / 3 );
        make.right.equalTo( self.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
    }];

}

-(void)clickCity:(UIButton *)view{
    if(nil!= self.citySelectBtn){
        if (self.citySelectBtn==view) {
            if (!self.citySelectBtn.isSelected) {
                [self.citySelectBtn setSelected:YES];
            }
        }else{
            [self.citySelectBtn setSelected:NO];
            [view setSelected:YES];
            self.citySelectBtn = view;
        }
    }else{
        [view setSelected:YES];
        self.citySelectBtn = view;
    }
    NSInteger tag = view.tag;
    Region *region = self.cityArray[tag];
    [self.hotCityfilterChangeDeleger hotCitySelect:region];
}
//- (CPSearchTextField *)searchTextFiled
//{
//    if(!_searchTextFiled){
//        CPSearchTextField *text = [[CPSearchTextField alloc] initWithFrame:CGRectMake(40/CP_GLOBALSCALE, 40/CP_GLOBALSCALE, self.viewWidth-80/CP_GLOBALSCALE, 90/CP_GLOBALSCALE)];
//        text.backgroundColor = [UIColor colorWithHexString:@"f0f2f5"];
//        UIView *imageBackView = [[UIView alloc] init];
//        [imageBackView setBackgroundColor:[UIColor redColor]];
//        UIImageView *customLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_ic_search"]];
//        CGFloat leftW = customLeftView.image.size.width / CP_GLOBALSCALE;
//        CGFloat leftH = customLeftView.image.size.height / CP_GLOBALSCALE;
//        customLeftView.frame = CGRectMake(0, 40/CP_GLOBALSCALE / 2.0, leftW, leftH);
//        [imageBackView addSubview:customLeftView];
//        text.delegate = self;
//        text.leftView = imageBackView;
//        text.rightViewMode = UITextFieldViewModeAlways;
//        text.leftView.backgroundColor = [UIColor clearColor];
//        text.leftViewMode = UITextFieldViewModeAlways;
//        text.layer.cornerRadius = 90 / CP_GLOBALSCALE / 2.0;
//        text.layer.masksToBounds = YES;
//        text.clearButtonMode = UITextFieldViewModeWhileEditing;
//        text.placeholder = @"请输入城市名称";
//        text.font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
//        text.textColor = [UIColor colorWithHexString:@"404040"];
////        text.background = [[UIImage imageNamed:@"search_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
//        _searchTextFiled = text;
//    }
//    return _searchTextFiled;
//}



@end
