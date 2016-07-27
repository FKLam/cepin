//
//  FirstLoadVC.m
//  cepin
//
//  Created by ceping on 14-12-24.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "FirstLoadVC.h"
#import "CircleView.h"
#import "LoginVC.h"
#import "SignupVC.h"
@interface FirstLoadVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,retain)NSArray *imageArray;
@property(nonatomic,strong)UIView *viewBottom;
@property(nonatomic,strong)FUIButton *LoginButton;
@property(nonatomic,strong)FUIButton *RegisterButton;
@property(nonatomic,strong)NSMutableArray *viewsArray;
@property(nonatomic,strong)NSArray *imageArray0;
@property (nonatomic, assign) CGRect tempFrame;
@end
@implementation FirstLoadVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)panHnale:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    UIView *thisView = (UIView*)recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self didUpdatePos:translation.x sender:thisView];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self didEndUpadatePos:recognizer];
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}

-(void)didUpdatePos:(int)xPos sender:(UIView*)sender
{
    CGRect rect = sender.frame;
    int totalOffset = rect.origin.x + xPos;
    rect.origin.x = totalOffset;
    sender.frame = rect;
    NSInteger count = [self.viewsArray count];
    for (int i = 0; i < count; i++)
    {
        UIView *cache = [self.viewsArray objectAtIndex:i];
        if (cache != sender)
        {
            rect = cache.frame;
            rect.origin.x = rect.origin.x + xPos;
            if (rect.origin.x > (count - 1) * kScreenWidth)
            {
                rect.origin.x = totalOffset - kScreenWidth;
            }
            else if(rect.origin.x < -kScreenWidth * (count - 1))
            {
                rect.origin.x = kScreenWidth + totalOffset;
            }
            cache.frame = rect;
        }
    }
}
-(void)didEndUpadatePos:(UIPanGestureRecognizer*)recognizer
{
    int offset = 0;
    CGRect rect;
    
    UIView *view = (UIView*)recognizer.view;
    
    if (view.frame.origin.x < -kScreenWidth/3)
    {
        offset = -(kScreenWidth + view.frame.origin.x);
    }
    else if(view.frame.origin.x > kScreenWidth/3)
    {
        offset = kScreenWidth - view.frame.origin.x;
    }
    else
    {
        offset = -view.frame.origin.x;
    }
    
    for (int i = 0; i < 3; i++)
    {
        CircleView *circle = [self.imageArray objectAtIndex:i];
        circle.type = CircleTypeDefualt;
    }
    
    for (int i = 0; i < [self.viewsArray count]; i++)
    {
        UIView *btn = [self.viewsArray objectAtIndex:i];
        rect = btn.frame;
        rect.origin.x += offset;
        if (rect.origin.x > 320)
        {
            rect.origin.x = -320;
        }
        int a = 0;
        a++;
        [UIView animateWithDuration:0.2 animations:^{
            btn.frame = rect;
        } completion:^(BOOL finished) {
            if (rect.origin.x == -kScreenWidth)
            {
                CircleView *circle = [self.imageArray objectAtIndex:i];
                circle.type = CircleTypeChecked;
            }
        }];
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
#pragma mark - 纪录运行程序的情况
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"launchButNotLogin"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewsArray = [[NSMutableArray alloc] initWithCapacity:4];
    if ( IS_IPHONE_5 )
    {
        self.imageArray0 = @[@"intro_1.jpg", @"intro_2.jpg", @"intro_3.jpg"];
    }
    else
    {
      self.imageArray0 = @[@"intro_1_960.jpg", @"intro_2_960.jpg", @"intro_3_960.jpg"];
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.userInteractionEnabled = YES;
    for ( int i = 0; i < 4; i ++ )
    {
        if( i < 3 )
        {
            UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0,
                                                                               self.view.viewWidth, self.view.viewHeight)];
            images.image = [UIImage imageNamed:[self.imageArray0 objectAtIndex:i]];
            [self.scrollView addSubview:images];
        }
        else
        {
            SignupVC *signVC = [[SignupVC alloc] initWithComeFormString:@"first"];
            [signVC.view setFrame:CGRectMake(kScreenWidth*i, 0, self.view.viewWidth, self.view.viewHeight)];
            [self.scrollView addSubview:signVC.view];
        }
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 4, self.view.frame.size.height);
    //底部按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(2*kScreenWidth, self.view.viewHeight - 70, self.view.viewWidth, 60)];
    view.backgroundColor = [UIColor clearColor];
    self.viewBottom = view;
    self.tempFrame = self.viewBottom.frame;
    [self.scrollView addSubview:view];
    //红点
    CircleView *center = [[CircleView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:center];
    [center mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(view.mas_top);
        make.width.equalTo(@(10));
        make.height.equalTo(@(10));
    }];
    center.type = CircleTypeDefualt;
    CircleView *left = [[CircleView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-15);
        make.top.equalTo(center.mas_top);
        make.width.equalTo(center.mas_width);
        make.height.equalTo(center.mas_height);
    }];
    left.type = CircleTypeChecked;
    CircleView *right = [[CircleView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(center.mas_centerX).offset(15);
        make.top.equalTo(center.mas_top);
        make.width.equalTo(center.mas_width);
        make.height.equalTo(center.mas_height);
    }];
    right.type = CircleTypeDefualt;
    CircleView *right1 = [[CircleView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:right1];
    [right1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(center.mas_centerX).offset(30);
        make.top.equalTo(center.mas_top);
        make.width.equalTo(center.mas_width);
        make.height.equalTo(center.mas_height);
    }];
    right1.type = CircleTypeDefualt;
    self.imageArray = @[left,center,right,right1];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/4)/pagewidth)+2;
    page --;  // 默认从第二页开始
//    self.pageControl.currentPage = page;
    for (int i = 0; i < 4; i++) {
        CircleView *circleType = [self.imageArray objectAtIndex:i];
        if (page == i) {
            circleType.type = CircleTypeChecked;
        }else{
            circleType.type = CircleTypeDefualt;
        }
        if( page == 3 ) {
            if ( !self.viewBottom.isHidden )
            {
                self.viewBottom.hidden = YES;
                self.viewBottom.frame = CGRectZero;
            }
        }
        else {
            if ( self.viewBottom.isHidden )
            {
                self.viewBottom.hidden = NO;
                self.viewBottom.frame = self.tempFrame;
            }
        }
    }
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if(offsetX == kScreenWidth*3){
        self.scrollView.scrollEnabled = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        // 设置导航栏颜色
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    }
}
@end
