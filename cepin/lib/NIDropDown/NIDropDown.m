//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

#import "SchoolDTO.h"


@interface NIDropDown ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIView *btnSender;
@property(nonatomic, assign) CGRect viewRect;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;


- (instancetype)initShowDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr {
    btnSender = b;
    if (self = [super init])
    {
        CGRect btn = b.frame;
        
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        self.list = [NSArray arrayWithArray:arr];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor lightGrayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(instancetype)initShowDropDown:(CGRect)showRect inView:(UIView *)view changeView:(UIView *)changeView height:(CGFloat)height titles:(NSArray *)arr
{

    if (self = [super init])
    {
        btnSender = changeView;
        self.viewRect = showRect;
        self.frame = CGRectMake(showRect.origin.x, CGRectGetMaxY(showRect), showRect.size.width, 0);
        self.list = [NSArray arrayWithArray:arr];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, showRect.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.separatorColor = [UIColor lightGrayColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.frame = CGRectMake(showRect.origin.x, CGRectGetMaxY(showRect), showRect.size.width, height);
        table.frame = CGRectMake(0, 0, showRect.size.width, height);
        [UIView commitAnimations];
        
        [view addSubview:self];
        [self addSubview:table];
        
        self.maskButton = [[UIButton alloc]initWithFrame:view.bounds];
        self.maskButton.backgroundColor = [UIColor clearColor];
        [view insertSubview:self.maskButton belowSubview:self];
        
        @weakify(self)
        [self.maskButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            [self hideDropDown];
        }];
    }
    return self;

}

-(void)setIsCanTap:(BOOL)isCanTap
{
    _isCanTap = isCanTap;
    
    UIView *view = self.superview;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.tap setDelegate:self];
    [view addGestureRecognizer:self.tap];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.tap != gestureRecognizer) {
        return YES;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    CGPoint point = [gestureRecognizer locationInView:self];
    BOOL b = CGRectContainsPoint(self.frame, point);
    return b;
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self hideDropDown];
    }
}

-(void)reloadData
{
    self.list = nil;
    [self.table reloadData];
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

-(void)hideDropDown:(UIButton *)b rect:(CGRect)rect
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 0);
    table.frame = CGRectMake(0, 0, rect.size.width, 0);
    [UIView commitAnimations];
}

-(void)hideDropDownWithView:(UIView *)b rect:(CGRect)rect
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 0);
    table.frame = CGRectMake(0, 0, rect.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.list == nil && [self.delegate respondsToSelector:@selector(numberOfRowWithView:)]) {
        return [self.delegate numberOfRowWithView:self];
    }
    
    return [self.list count];
}   


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    cell.textLabel.text = [self.delegate dropDownView:self index:indexPath.row];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [[RTAPPUIHelper shareInstance]blueWordColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDownWithView:self.btnSender rect:self.viewRect];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([btnSender isKindOfClass:[UIButton class]]) {
        [(UIButton *)btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    }else if ([btnSender isKindOfClass:[UILabel class]]){
        [(UILabel *)btnSender setText:c.textLabel.text];
    }else if([btnSender isKindOfClass:[UITextField class]]){
        [(UITextField *)btnSender setText:c.textLabel.text];
    }
    
    if ([self.delegate respondsToSelector:@selector(niDropDownDelegateMethod:index:)]) {
        [self.delegate niDropDownDelegateMethod:self index:indexPath.row];
    }
}


-(void)hideDropDown
{
    
    if ([self.delegate respondsToSelector:@selector(niDropDownMenuWillDisplay:)]) {
        [self.delegate niDropDownMenuWillDisplay:self];
    }
    
    [self.maskButton removeFromSuperview];
    [self hideDropDownWithView:self.btnSender rect:self.viewRect];
    //[self.superview removeGestureRecognizer:self.tap];
//    [self.tap removeTarget:self.superview action:@selector(tap:)];
}


-(void)dealloc
{
    self.delegate = nil;
    self.table = nil;
    self.btnSender = nil;
    self.list = nil;
    [self removeGestureRecognizer:self.tap];
    self.tap = nil;
}

@end
