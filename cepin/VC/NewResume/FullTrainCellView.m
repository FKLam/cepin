//
//  FullTrainCellView.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullTrainCellView.h"
#import "TrainCell.h"
#import "TBTextUnit.h"
#import "NSString+Extension.h"

@implementation FullTrainCellView

- (instancetype)initWithFrame:(CGRect)frame model:(ResumeNameModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.trainModel = model;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.scrollsToTop = NO;
        [self addSubview:self.tableView];
        
        int a = 0;
        CGFloat lineY = 40 / 3.0 - (21.0 - [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont].pointSize) / 2.0 + 21.0 / 2.0;
        for (int i = 0; i < self.trainModel.TrainingList.count - 1; i++) {
            TrainingDataModel *model = [TrainingDataModel beanFromDictionary:self.trainModel.TrainingList[i]];
            CGFloat maxMarge = self.viewWidth - 40 - 40 / 3.0;
            
            CGFloat fixdHeight = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont].pointSize * 2 + 40 / 3.0 * 2 + 5.0 * 2;
            NSString *str = model.Content?model.Content:@"";
            
            if ( str.length == 0 )
            {
                a += fixdHeight;
                continue;
            }
            
            int height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultTipsHeadFont] text:str andWith:maxMarge].height + 5.0;
            a += height + fixdHeight;
        }
       
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake( 40 / 3.0 + 21 / 2.0 - 1 / 2.0, lineY, 1, a)];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self insertSubview:line belowSubview:self.tableView];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingDataModel *model = [TrainingDataModel beanFromDictionary:self.trainModel.TrainingList[indexPath.row]];

    CGFloat fixdHeight = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont].pointSize * 2 + 40 / 3.0 * 2 + 5.0 * 2;
    
    if (model.Content && ![model.Content isEqualToString:@""]) {
        CGFloat maxMarge = self.viewWidth - 40 - 40 / 3.0;
        NSString *str = model.Content?model.Content:@"";
        int height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultTipsHeadFont] text:str andWith:maxMarge].height + 5.0;
        return height + fixdHeight;
    }
    
    return fixdHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trainModel.TrainingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TrainCell class])];
    if (cell == nil) {
        cell = [[TrainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TrainCell class])];
    }
    TrainingDataModel *model = [TrainingDataModel beanFromDictionary:self.trainModel.TrainingList[indexPath.row]];
    [cell getModel:model];
    
    if ( indexPath.row == self.trainModel.TrainingList.count - 1 )
        cell.separatorView.hidden = YES;
    else
        cell.separatorView.hidden = NO;
    
    return cell;
}

@end
