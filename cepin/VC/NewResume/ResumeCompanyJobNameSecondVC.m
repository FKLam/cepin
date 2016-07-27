//
//  ExpectFunctionSecondVC.m
//  cepin
//
//  Created by dujincai on 15/6/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//


#import "ResumeCompanyJobNameSecondVC.h"
#import "ExpectFunctionSecondVM.h"

#import "ComChooseCell.h"
#import "TBTextUnit.h"
#import "JobFunctionFilterCell.h"
#import "ResumuEditJobExperienceVC.h"
#import "ResumeAddJobVC.h"
#import "SignupProjectVC.h"
#import "SchoolResumeAddJobVC.h"
@interface ResumeCompanyJobNameSecondVC ()
@property(nonatomic,strong)ExpectFunctionSecondVM *viewModel;
@property(nonatomic,assign)BOOL isFirstSelect;
@property(nonatomic,strong)NSMutableArray *thirdData;
@end

@implementation ResumeCompanyJobNameSecondVC

-(instancetype)initWithData:(NSMutableArray *)data seletedData:(NSMutableArray *)seletedData model:(WorkListDateModel *)model
{
    if (self = [super init])
    {
        self.thirdData = data;
        self.model = model;
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.thirdData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ComChooseCell class])];
    
    if(cell == nil)
    {
        cell = [[ComChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ComChooseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BaseCode *region = self.thirdData[indexPath.row];
    
    [cell configureLableTitleText:region.CodeName];
    
    cell.labelSub.hidden = YES;
    cell.chooseType = ComChooseSelectType;
    
    NSString *str = [NSString stringWithFormat:@"%@",region.CodeKey];
    if ([self.model.JobFunctionKey isEqualToString:str]) {
        cell.isSelected = YES;
    }else
    {
        cell.isSelected = NO;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ResumuEditJobExperienceVC class]]) {
              BaseCode *region = self.thirdData[indexPath.row];
            self.model.JobFunction = region.CodeName;
            self.model.JobFunctionKey = [NSString stringWithFormat:@"%@",region.CodeKey];
            [self.navigationController popToViewController:vc animated:YES];
        }
        
        if ([vc isKindOfClass:[ResumeAddJobVC class]] || [vc isKindOfClass:[SignupProjectVC class]]|| [vc isKindOfClass:[SchoolResumeAddJobVC class]]) {
            BaseCode *region = self.thirdData[indexPath.row];
            self.model.JobFunction = region.CodeName;
            self.model.JobFunctionKey = [NSString stringWithFormat:@"%@",region.CodeKey];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

@end
