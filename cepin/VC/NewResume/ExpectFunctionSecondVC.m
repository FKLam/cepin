//
//  ExpectFunctionSecondVC.m
//  cepin
//
//  Created by dujincai on 15/6/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//


#import "ExpectFunctionSecondVC.h"
#import "ExpectFunctionSecondVM.h"

#import "ChooseCell.h"
#import "TBTextUnit.h"
#import "JobFunctionFilterCell.h"
@interface ExpectFunctionSecondVC ()<AOTagDelegate>
@property(nonatomic,strong)ExpectFunctionSecondVM *viewModel;
@property(nonatomic,strong)NSMutableArray *seleArray;
@property(nonatomic,assign)int cellHight;
@property(nonatomic)BOOL isShrink;
@end

@implementation ExpectFunctionSecondVC

-(instancetype)initWithData:(NSMutableArray *)data seletedData:(NSMutableArray *)seletedData
{
    if (self = [super init])
    {
        self.isShrink = NO;
        self.viewModel = [[ExpectFunctionSecondVM alloc] initWithData:data seletedData:seletedData];
        self.seleArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tagDidRemoveTag:(AOTag *)tag
{
    [self.seleArray removeObject:tag.tTitle];
    
    NSMutableArray *array = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedObject]];
    [self.viewModel.selectedObject removeAllObjects];
    for (BaseCode *item in array) {
        if (![tag.tTitle isEqualToString:item.CodeName]) {
            NSString *str = [NSString stringWithFormat:@"%@",item.CodeKey];
            [self.viewModel.selectedObject addObject:str];
        }
    }
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
        
        cell.countLabel.text = [NSString stringWithFormat:@"已选%ld/3",(unsigned long)self.viewModel.selectedObject.count];
        NSMutableArray *array = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedObject]];
        [self.seleArray removeAllObjects];
        for (int i = 0; i < array.count; i++) {
            BaseCode *item = array[i];
            [self.seleArray addObject:item.CodeName];
        }
        [cell.tagListView setDelegate:self];
        [cell.tagListView removeAllTag];
        for (NSInteger i = 0; i < self.seleArray.count; i++)
        {
            [cell.tagListView addTag:[self.seleArray objectAtIndex:i] withImage:nil withLabelColor:[UIColor whiteColor]  withBackgroundColor:[[RTAPPUIHelper shareInstance] labelColorGreen] withCloseButtonColor:[UIColor whiteColor]];
        }
        
       
        [cell.clickButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.isShrink) {
                self.cellHight = 60;
                cell.tagListView.hidden = YES;
                self.isShrink = !self.isShrink;
                cell.clickImage.image = [UIImage imageNamed:@"ic_down"];
            }else
            {
                self.cellHight = 150;
                cell.tagListView.hidden = NO;
                self.isShrink = !self.isShrink;
                cell.clickImage.image = [UIImage imageNamed:@"ic_up"];
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
    
    NSMutableArray *array = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedObject]];
    NSMutableArray *mutArray = [NSMutableArray new];
    for (int i = 0; i < array.count; i++) {
        BaseCode *item = array[i];
        NSString *str = [NSString stringWithFormat:@"%@",item.CodeKey];
        [mutArray addObject:str];
    }
    
    cell.labelSub.hidden = YES;
    cell.chooseType = ChooseSelectType;
    BOOL isSelected = NO;
    
    for (NSString *item in mutArray) {
        NSString *str = [NSString stringWithFormat:@"%@",region.CodeKey];
        if ([item isEqualToString:str]) {
            isSelected = YES;
            break;
        }
    }
    if (isSelected)
    {
        cell.selectType = ChooseHasSelect;
        cell.isSelected = isSelected;
    }
    else
    {
        if (self.viewModel.selectedObject.count >= 3)
        {
            cell.selectType = ChooseDisable;
        }
        else
        {
            cell.selectType = ChooseEnable;
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
    
    NSMutableArray *array = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.selectedObject]];

    BOOL isSelected = NO;
    for (BaseCode*str in array) {
        if (str.CodeKey.intValue ==  region.CodeKey.intValue) {
            isSelected = YES;
            break;
        }
    }
    
    if (isSelected)
    {
       
        NSString *str = [NSString stringWithFormat:@"%@",region.CodeKey];
        [self.viewModel.selectedObject removeObject:str];
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
            [self.viewModel.selectedObject addObject:str];
            [self.tableView reloadData];
        }
    }
}

@end
