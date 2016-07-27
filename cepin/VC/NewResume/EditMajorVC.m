//
//  EditMajorVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditMajorVC.h"
#import "BaseCodeDTO.h"
#import "ResumeChooseCell.h"
#import "EditMajorVM.h"
@interface EditMajorVC ()<UITextFieldDelegate>
@property (nonatomic, strong) EditMajorVM *viewModel;
@property (nonatomic, strong) UITextField *search;
@property (nonatomic, strong) NSString *majorName;
@end
@implementation EditMajorVC
- (instancetype)initWithEduModel:(EducationListDateModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[EditMajorVM alloc] initWithselectedMajor:model.Major];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专业";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, 50)];
    topView.backgroundColor = [[RTAPPUIHelper shareInstance] whiteColor];
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
        self.majorName = text;
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
    if (!self.majorName || [self.majorName isEqualToString:@""]) {
        self.viewModel.majors = [BaseCode AllMajor];
    }
    else{
        self.viewModel.majors = [BaseCode majorWithName:self.majorName];
    }
    [textField resignFirstResponder];
    [self.tableView reloadData];
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / 3.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.majors.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BaseCode *major = self.viewModel.majors[indexPath.row];
    cell.titleLabel.text = major.CodeName;
    BOOL isSelected = NO;
    for (BaseCode *item in self.viewModel.selectMajor)
    {
        if ( [item.CodeName isEqualToString:major.CodeName] )
        {
            isSelected = YES;
            break;
        }
    }
    if ( isSelected )
    {
       
        cell.isSelect = isSelected;
    }
    else
    {
        cell.isSelect = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *item = self.viewModel.majors[indexPath.row];
    self.model.Major = item.CodeName;
    self.model.MajorKey = [NSString stringWithFormat:@"%@",item.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
