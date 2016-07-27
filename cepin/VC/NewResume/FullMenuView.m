//
//  FullMenuView.m
//  cepin
//
//  Created by dujincai on 15-4-9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullMenuView.h"
#import "ResumeMenuCell.h"
#import "AllResumeDataModel.h"
@interface FullMenuView ()

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UIButton    *maskButton;
@property(nonatomic,retain)NSArray     *titlesAndImages;

@end

@implementation FullMenuView


-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.titlesAndImages = @[@"设为默认",@"简历删除"];
        
        self.maskButton = [[UIButton alloc]initWithFrame:self.bounds];
        self.maskButton.backgroundColor = [UIColor blackColor];
        self.maskButton.alpha = 0.18;
        [self addSubview:self.maskButton];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, self.viewHeight, kScreenWidth-20, (IS_IPHONE_5?40:48)*2) style:UITableViewStylePlain];
        self.tableView.layer.cornerRadius = 8;
        self.tableView.layer.masksToBounds = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        
        @weakify(self)
        [self.maskButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            [self startDisapper];
        }];
    }
    return self;
}

-(void)startApper
{
    CGRect rect = self.tableView.frame;
    rect.origin.y = self.viewHeight-(IS_IPHONE_5?40:48)*2 - 10;
    self.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.tableView.frame = rect;
    }];
    
}
-(void)startDisapper
{
    CGRect rect = self.tableView.frame;
    rect.origin.y = self.viewHeight;
    [UIView animateWithDuration:.3 animations:^{
        self.tableView.frame = rect;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titlesAndImages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    
    static  NSString *cellIndentify = @"ResumeMenuCell";
    ResumeMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if(cell==nil)
    {
        cell=[[ResumeMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    cell.titleLable.text = self.titlesAndImages[index];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPHONE_5?40:48;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self startDisapper];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didResumeMenuTouch:)])
    {
        [self.delegate didResumeMenuTouch:indexPath.row];
    }
}
@end
