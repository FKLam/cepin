//
//  AboutMenuView.m
//  cepin
//
//  Created by dujincai on 15/5/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AboutMenuView.h"
#import "AboutViewCell.h"
@interface AboutMenuView ()

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UIButton    *maskButton;
@property(nonatomic,strong) NSArray *titles;
@end

@implementation AboutMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titles = @[@"关于",@"分享App"];
        self.maskButton = [[UIButton alloc]initWithFrame:self.bounds];
        self.maskButton.backgroundColor = [UIColor blackColor];
        self.maskButton.alpha = 0.18;
        [self addSubview:self.maskButton];
        @weakify(self)
        [self.maskButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            [self startDisapper];
        }];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(200,IsIOS7?20:0, 110, 88) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
    }
    return self;
}
-(void)startApper
{
    CGRect rect = self.tableView.frame;
    rect.origin.x = 310 - 110;
    self.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.tableView.frame = rect;
    }];
}
-(void)startDisapper
{
    CGRect rect = self.tableView.frame;
    rect.origin.x = self.viewWidth;
    [UIView animateWithDuration:.3 animations:^{
        self.tableView.frame = rect;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AboutViewCell class])];
    if (cell == nil) {
        cell = [[AboutViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([AboutViewCell class])];
    }
    cell.nameLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.aboutDelegate respondsToSelector:@selector(didTouchAboutMenue:)]) {
        [self.aboutDelegate didTouchAboutMenue:indexPath.row];
    }
}
@end
