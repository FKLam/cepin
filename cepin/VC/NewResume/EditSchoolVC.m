//
//  EditSchoolVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditSchoolVC.h"
#import "ResumeChooseCell.h"
#import "SchoolDTO.h"
#import "ChooseCell.h"
#import "EditSchoolVM.h"
@interface EditSchoolVC ()<UITextFieldDelegate>
@property (nonatomic, strong) EditSchoolVM *viewModel;
@property (nonatomic, strong) UITextField *search;
@property (nonatomic, strong) NSString *schoolName;
@end
@implementation EditSchoolVC
- (instancetype)initWithEduModel:(EducationListDateModel *)model
{
    self = [super init];
    if (self)
    {
        self.viewModel = [[EditSchoolVM alloc] initWithselectedSchool:model.School];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"学校";
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, 50)];
    topView.backgroundColor = [[RTAPPUIHelper shareInstance]whiteColor];
    [self.view addSubview:topView];
    self.search = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,self.view.viewWidth-20 - 10 , 30)];
    self.search.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon_2x"]];
    self.search.rightViewMode = UITextFieldViewModeAlways;
    self.search.leftView.backgroundColor = [UIColor clearColor];
    self.search.leftViewMode = UITextFieldViewModeAlways;
    self.search.layer.cornerRadius = 8;
    self.search.layer.masksToBounds = YES;
    self.search.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.search.placeholder = @"请输入搜索内容";
    self.search.font = [[RTAPPUIHelper shareInstance]titleFont];
    self.search.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.search.delegate = self;
    self.search.returnKeyType = UIReturnKeySearch;
    self.search.backgroundColor = [[RTAPPUIHelper shareInstance]grapColor];
    [topView addSubview:self.search];
    [[self.search rac_textSignal] subscribeNext:^(NSString *text) {
        self.schoolName = text;
    }];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.viewY + topView.viewHeight + (IS_IPHONE_5?18:21), self.view.viewWidth, (self.view.viewHeight)-44 - 70-((IsIOS7)?20:0)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.rowHeight = 77.0f;
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!self.schoolName || [self.schoolName isEqualToString:@""]) {
        [textField resignFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
   self.viewModel.schools = [School schoolWithName:self.schoolName];
    [self.tableView reloadData];
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / 3.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.schools.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseCell class])];
    if (cell == nil) {
        cell = [[ChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ChooseCell class])];
    }
//    School *item = self.schoolData[indexPath.row];
//    cell.titleLabel.text = item.Name;
//    BOOL isSelect = NO;
//    for (School *school in self.schoolData) {
//        if ([self.model.School isEqualToString:school.Name]) {
//            isSelect = YES;
//            break;
//        }
//    }
//    
//    if (isSelect) {
//        cell.isSelect = isSelect;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    School *school = self.viewModel.schools[indexPath.row];
    [cell configureLableTitleText:school.Name];
    cell.labelSub.hidden = YES;
    cell.chooseType = ChooseSelectType;
    BOOL isSelected = NO;
    for (School *item in self.viewModel.selectSchool) {
        if ([item.Name isEqualToString:school.Name]) {
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
        cell.isSelected = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    School *item = self.viewModel.schools[indexPath.row];
    self.model.School = item.Name;
    self.model.SchoolCode = item.SchoolId;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
