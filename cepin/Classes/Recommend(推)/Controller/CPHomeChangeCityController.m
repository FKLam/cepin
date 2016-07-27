//
//  CPHomeChangeCityController.m
//  cepin
//
//  Created by ceping on 16/1/13.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPHomeChangeCityController.h"
#import "RTNetworking+PublicData.h"
#import "NSDictionary+NetworkBean.h"
#import "RegionDTO.h"
#import "BaseBeanModel.h"
#import "TBAppDelegate.h"
#import "CPCommon.h"
@interface CPWChangeCityButton : UIButton
@end
@implementation CPWChangeCityButton
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
@interface CPHomeChangeCityController ()
@property (nonatomic, strong) UIView *localCityBackgroundView;
@property (nonatomic, strong) UILabel *localCityLabel;
@property (nonatomic, strong) UIView *otherCityBackgroundView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong)NSString *homeCity;
@property (nonatomic,strong)NSString *locationCity;
@end
@implementation CPHomeChangeCityController
#pragma mark - lift cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"切换城市";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.view addSubview:self.localCityBackgroundView];
    [self.localCityBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.view.mas_top );
        make.left.equalTo( self.view.mas_left );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        make.right.equalTo( self.view.mas_right );
    }];
    [self.view addSubview:self.otherCityBackgroundView];
    [self.otherCityBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.localCityBackgroundView.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left );
        make.right.equalTo( self.view.mas_right );
        make.bottom.equalTo( self.view.mas_bottom );
    }];
    self.locationCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCity"];
    if(nil==self.locationCity || [self.locationCity isEqualToString:@""]){
        self.locationCity=@"全国";
    }
    TBAppDelegate *appdelagate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelagate.homeCity) {
        self.homeCity = appdelagate.homeCity ;
    }
    
    [self setLocalCityString:self.locationCity];
    [self.localCityLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLocalCity:)];
    
    [self.localCityLabel addGestureRecognizer:tapGesture];
    TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
    //判断是否已经请求过热门城市的接口 
    if(nil == delegate.cityData){
        // 请求热门城市接口
        RACSignal *companySignal = [[RTNetworking shareInstance] getHotCityData];
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
-(void)clickLocalCity:(UILabel *)sender{
    if (self.locationCity)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            if([self.locationCity isEqualToString:@"全国"]){
                Region *rg = [Region new];
                rg.PathCode = @"";
                rg.RegionName = @"全国";
                [self.cityDelegate changeCity:rg];
                return;
            }
            Region *region = [Region searchAddressWithAddressString:self.locationCity];
            [self.cityDelegate changeCity:region];
        }];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CPWChangeCityButton *changeCityBtn = [CPWChangeCityButton buttonWithType:UIButtonTypeCustom];
    [changeCityBtn setBackgroundColor:[UIColor clearColor]];
    changeCityBtn.viewSize = CGSizeMake(48 / CP_GLOBALSCALE, 48 / CP_GLOBALSCALE);
    [changeCityBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [changeCityBtn addTarget:self action:@selector(clickedChangeCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:changeCityBtn];
    self.navigationItem.leftBarButtonItem = rightBarButton;
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
}
- (void)setLocalCityString:(NSString *)cityName
{
    NSString *preStr = @"当前城市";
    NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", preStr, cityName]];
    [attStrM addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, [preStr length])];
    [attStrM addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"288add"]} range:NSMakeRange([preStr length] + 1, [cityName length])];
    self.localCityLabel.attributedText = [attStrM copy];
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
        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateFocused];
        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateFocused];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
        [btn.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [btn.layer setCornerRadius:6 / CP_GLOBALSCALE];
        [btn setTitle:buttonTitleStr forState:UIControlStateNormal];
        [btn setTag:index];
        [btn addTarget:self action:@selector(clickCity:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setMasksToBounds:YES];
        if (self.homeCity) {
            if ([self.homeCity isEqualToString:buttonTitleStr]) {
                [btn setSelected:YES];
            }
        }
        buttonX = margin + (buttonW + margin ) * (index % 4);
        buttonY = ( 60 + 40 + 42 ) / CP_GLOBALSCALE + (buttonH + margin) * (index / 4);
        
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self.otherCityBackgroundView addSubview:btn];
        
    }
}
-(void)clickCity:(UIButton *)view{
    NSInteger tag = view.tag;
    [MobClick event:@"into_choose_city"];
    [MobClick event:@"choose_city_remeng"];
    Region *region = self.cityArray[tag];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.cityDelegate changeCity:region];
    }];
}
#pragma mark - events
- (void)clickedChangeCity
{
    [MobClick event:@"choose_city_dingwei"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - getter methods
- (UIView *)localCityBackgroundView
{
    if ( !_localCityBackgroundView )
    {
        _localCityBackgroundView = [[UIView alloc] init];
        [_localCityBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [_localCityBackgroundView addSubview:self.localCityLabel];
        [self.localCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _localCityBackgroundView.mas_top );
            make.left.equalTo( _localCityBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _localCityBackgroundView.mas_bottom );
            make.right.equalTo( _localCityBackgroundView.mas_right );
        }];
        
        UIView *separatorLine = [[UIView alloc] init];
        [_localCityBackgroundView addSubview:separatorLine];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _localCityBackgroundView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( _localCityBackgroundView.mas_bottom );
            make.right.equalTo( _localCityBackgroundView.mas_right );
        }];
    }
    return _localCityBackgroundView;
}
- (UILabel *)localCityLabel
{
    if ( !_localCityLabel )
    {
        _localCityLabel = [[UILabel alloc] init];
        [_localCityLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
    }
    return _localCityLabel;
}
- (UIView *)otherCityBackgroundView
{
    if ( !_otherCityBackgroundView )
    {
        _otherCityBackgroundView = [[UIView alloc] init];
        [_otherCityBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        UILabel *otherCityTitleLabel = [[UILabel alloc] init];
        [otherCityTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE ]];
        
        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithString:@"或  切换到以下城市"];
        [attStrM addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"]} range:NSMakeRange(0, 1)];
        [attStrM addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]} range:NSMakeRange(1, [attStrM length] - 1)];
        
        [otherCityTitleLabel setAttributedText:[attStrM copy]];
        [_otherCityBackgroundView addSubview:otherCityTitleLabel];
        [otherCityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _otherCityBackgroundView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _otherCityBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( otherCityTitleLabel.font.pointSize ) );
        }];
    }
    return _otherCityBackgroundView;
}
@end
