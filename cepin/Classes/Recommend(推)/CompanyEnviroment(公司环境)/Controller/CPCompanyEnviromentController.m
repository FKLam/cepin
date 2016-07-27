//
//  CPCompanyEnviromentController.m
//  cepin
//
//  Created by ceping on 16/1/14.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyEnviromentController.h"
#import "SDCycleScrollView.h"

@interface CPCompanyEnviromentController ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)NSArray *imgArray;//公司环境的图片

@end

@implementation CPCompanyEnviromentController
#pragma mark - lift cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        [self setTitle:@"公司环境"];
        [self.view setBackgroundColor:[UIColor colorWithHexString:@"000000"]];
    }
    return self;
}

-(void)configImags:(NSArray *)imgsArray{
    if (imgsArray) {
       self.imgArray = [imgsArray copy];
    }else{
        self.imgArray = [[NSArray alloc]init];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    
    // 导航栏右边分享按钮 ic_share
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shareBtn setBackgroundColor:[UIColor clearColor]];
//    [shareBtn setTitle:@"分享微门户" forState:UIControlStateNormal];
//    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    shareBtn.viewSize = CGSizeMake(14.0 * 5, 14.0);
//    [shareBtn addTarget:self action:@selector(clickedShareButton) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
//    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil]; // 模拟网络延时情景
     [self.view addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(250));
        make.centerY.equalTo(self.view.mas_centerY);
        
    }];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
    cycleScrollView.infiniteLoop = NO;
    cycleScrollView.autoScroll = NO;
    
    //    cycleScrollView2.titlesGroup = titles;
    //    cycleScrollView2.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    //    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
   
    
    //             --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = self.imgArray;
    });
    
    
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"---点击了第%ld张图片", index);
}

@end
