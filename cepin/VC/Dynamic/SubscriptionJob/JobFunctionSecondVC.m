//
//  JobFunctionSecondVC.m
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobFunctionSecondVC.h"
#import "JobFunctionSecondVM.h"

#import "ComChooseCell.h"
#import "TBTextUnit.h"
#import "JobFunctionFilterCell.h"
#import "BookingJobFilterModel.h"
#import "ChooseCell.h"
@interface JobFunctionSecondVC ()<AOTagDelegate>
@property(nonatomic,strong)JobFunctionSecondVM *viewModel;
@property(nonatomic,assign)BOOL isFirstSelect;
@property(nonatomic,strong)NSMutableArray *tagArray;
@property(nonatomic,assign)int cellHight;
@property(nonatomic)BOOL isShrink;
@end

@implementation JobFunctionSecondVC
- (instancetype)initWithData:(NSMutableArray *)data seletedData:(NSMutableArray *)seletedData jobFunctionsKey:(NSMutableArray *)jobFunctionskey
{
    self = [super init];
    if (self) {
        self.isShrink = NO;
        self.viewModel = [[JobFunctionSecondVM alloc]initWithData:data seletedData:seletedData jobFunctionsKey:jobFunctionskey];
        BaseCode *region = self.viewModel.datas[0];
        self.tagArray = [NSMutableArray new];
        BOOL isSelected = NO;
        for (NSString *item in self.viewModel.selectedObject) {
            if ([item isEqualToString:region.PathCode]) {
                isSelected = YES;
                break;
            }
        }
        self.isFirstSelect = isSelected;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNoHeadImageTable];
    
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tagDidRemoveTag:(AOTag *)tag
{
    [self.viewModel.selectedObject removeObject:tag.tTitle];
    NSMutableArray *array = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctionsKey]];
    BaseCode *temp = nil;
    for (BaseCode *item in array) {
        if ([item.CodeName isEqualToString:tag.tTitle]) {
            temp = item;
            break;
        }
    }
    NSString *str = [NSString stringWithFormat:@"%@",temp.CodeKey];
    [self.viewModel.jobFunctionsKey removeObject:str];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.cellHight?self.cellHight:60;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JobFunctionFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JobFunctionFilterCell class])];
        if (cell == nil) {
            cell = [[JobFunctionFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JobFunctionFilterCell class])];
        }
        
        cell.countLabel.text = [NSString stringWithFormat:@"已选%lu/3",(unsigned long)self.viewModel.selectedObject.count];
        [cell.tagListView setDelegate:self];
        [cell.tagListView removeAllTag];
        for (NSInteger i = 0; i < self.viewModel.selectedObject.count; i++)
        {
            [cell.tagListView addTag:[self.viewModel.selectedObject objectAtIndex:i] withImage:nil withLabelColor:[UIColor whiteColor]  withBackgroundColor:[[RTAPPUIHelper shareInstance]labelColorGreen] withCloseButtonColor:[UIColor whiteColor]];
        }
        [cell.clickButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.isShrink) {
                self.cellHight = 60;
                cell.tagListView.hidden = YES;
                cell.clickImage.image = [UIImage imageNamed:@"ic_down"];
                self.isShrink = !self.isShrink;
            }else
            {
                self.cellHight = 150;
                cell.tagListView.hidden = NO;
                cell.clickImage.image = [UIImage imageNamed:@"ic_up"];
                self.isShrink = !self.isShrink;
            }
            [self.tableView reloadData];
        }];
        return cell;
    }
    
    ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseCell class])];
    
    if(cell == nil)
    {
        cell = [[ChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ChooseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BaseCode *region = self.viewModel.datas[indexPath.row - 1];
    
    [cell configureLableTitleText:region.CodeName];
    
    
    
    cell.labelSub.hidden = YES;
    cell.chooseType = ComChooseSelectType;
    BOOL isSelected = NO;
    for (NSString *item in self.viewModel.jobFunctionsKey) {
        NSString *str = [NSString stringWithFormat:@"%@",region.CodeKey];
        if ([item isEqualToString:str]) {
            isSelected = YES;
            break;
        }
    }
    if (isSelected)
    {
        cell.selectType = ComChooseHasSelect;
        cell.isSelected = isSelected;
    }
    else
    {
        if (self.viewModel.selectedObject.count >= 3)
        {
            cell.selectType = ComChooseDisable;
        }
        else
        {
            cell.selectType = ComChooseEnable;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    BaseCode *region = self.viewModel.datas[indexPath.row - 1];
    BOOL isSelected = NO;
//    BaseCode *tempCode = nil;
    for (NSString*str in self.viewModel.jobFunctionsKey) {
        NSString *codeStr = [NSString stringWithFormat:@"%@",region.CodeKey];
        if ([str isEqualToString:codeStr]) {
            isSelected = YES;
//            tempCode = region;
            break;
        }
    }
    
    if (isSelected)
    {
        NSString *str = [NSString stringWithFormat:@"%@",region.CodeKey];
        [self.viewModel.selectedObject removeObject:region.CodeName];
        [self.viewModel.jobFunctionsKey removeObject:str];
        [self.tableView reloadData];
    }
    else
    {
        if (self.viewModel.selectedObject.count >= 3)
        {
            [OMGToast showWithText:@"最多可选3个条件" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%@",region.CodeKey];
            [self.viewModel.selectedObject addObject:region.CodeName];
            [self.viewModel.jobFunctionsKey addObject:str];
            [self.tableView reloadData];
        }
    }
}


@end
