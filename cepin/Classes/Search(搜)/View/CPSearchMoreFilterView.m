//
//  CPSearchMoreFilterView.m
//  cepin
//
//  Created by ceping on 16/1/11.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSearchMoreFilterView.h"
#import "JobSearchVM.h"
#import "CPResumeEditFirstExpectCell.h"
#import "JobFunctionHeaderView.h"
#import "ExpectFunctionVM.h"
#import "TBTextUnit.h"
#import "ComChooseCell.h"
#import "CPCommon.h"
@interface CPSearchMoreFilterView ()<UITableViewDelegate,UITableViewDataSource,CPResumeEditFirstExpectCellDelegate>
@property (nonatomic, strong) UIView *rightBackgroundView;
@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *dutyView;
@property (nonatomic, strong) UILabel *dutyLabel;
@property (nonatomic, strong) UIView *educationBackgroundView;
@property (nonatomic, strong) UIView *workingPropertyBackgroundView;
@property (nonatomic, strong) UIView *recruitmentTypeBackgroundView;
@property (nonatomic, strong) NSArray *educationArray;
@property (nonatomic, strong) NSArray *workingPropertyArray;
@property (nonatomic, strong) NSArray *recruitmenttypeArray;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *ensureButton;
@property(nonatomic,strong)JobSearchVM *viewModel;
@property (nonatomic, strong) UIButton *eduSelectBtn;
@property (nonatomic, strong) NSString *eduStr;//临时保存学历信息
@property (nonatomic, strong) UIButton *workingSelectBtn;
@property (nonatomic, strong) NSString *workStr;//临时保存工作性质信息
@property (nonatomic, strong) UIButton *recruitmentTypeSelectBtn;
@property (nonatomic, strong) NSString *recruitmentTypeStr;//临时保存招聘类型信息
@property (nonatomic, strong) UIButton *eduFirstSelectBtn;//保存第一个按钮
@property (nonatomic, strong) UIButton *workingFirstSelectBtn;//保存第一个按钮
@property (nonatomic, strong) UIButton *recruitmentTypeFirstSelectBtn;//保存第一个按钮
@property (nonatomic, strong) UITableView *functionTableView;//职能类别
@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,strong)NSMutableArray *headView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selectedFirstRow;
@property (nonatomic, assign) NSInteger selectedSecondRow;
@property (nonatomic, assign) CGFloat changeHeight;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)NSMutableArray *jobFunctions;
@property(nonatomic,strong)BaseCode *selectCode;
@end
@implementation CPSearchMoreFilterView

#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame modle:(JobSearchVM *)model
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.selectedFirstRow = -1;
        self.viewModel = model;
        [self addSubview:self.rightBackgroundView];
        self.datas = [BaseCode jobFunction];
        self.jobFunctions = [NSMutableArray new];
        if ([self.viewModel.subModel.jobFunctions isEqualToString:@""] || !self.viewModel.subModel.jobFunctions) {
            [self.jobFunctions removeAllObjects];
        }
        else
        {
            self.jobFunctions = [NSMutableArray arrayWithArray:[self.viewModel.subModel.jobFunctionskey componentsSeparatedByString:@","]];
        }
        self.dataArray = [NSMutableArray new];
        for (int i = 0; i < self.datas.count; i++) {
            BaseCode *item = self.datas[i];
            [self.dataArray addObject:item.CodeName];
        }
        CGFloat buttonHeight = 144 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            buttonHeight = 100 / ( 3.0 * ( 1 / 1.29 ) );
        // 顶部标题背景
        [self.rightBackgroundView addSubview:self.topBackgroundView];
        [self.topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.rightBackgroundView.mas_top );
            make.left.equalTo( self.rightBackgroundView.mas_left );
            make.height.equalTo( @( buttonHeight ) );
            make.right.equalTo( self.rightBackgroundView.mas_right );
        }];
        // 顶部返回按钮
        [self.topBackgroundView addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.topBackgroundView.mas_left).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.centerY.equalTo( self.topBackgroundView.mas_centerY );
        }];
        // 顶部标题
        [self.topBackgroundView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topBackgroundView.mas_top );
            make.left.equalTo( self.backButton.mas_right );
            make.bottom.equalTo( self.topBackgroundView.mas_bottom );
            make.right.equalTo( self.topBackgroundView.mas_right );
        }];
        // 顶部分隔线
        UIView *topSeparatoLine = [[UIView alloc] init];
        [topSeparatoLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.topBackgroundView addSubview:topSeparatoLine];
        [topSeparatoLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.topBackgroundView.mas_left );
            make.bottom.equalTo( self.topBackgroundView.mas_bottom );
            make.right.equalTo( self.topBackgroundView.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        // 职能类型
        self.functionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.functionTableView.delegate = self;
        self.functionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.functionTableView.scrollsToTop = YES;
        [self addSubview:self.functionTableView];
        self.functionTableView.dataSource = self;
        self.functionTableView.contentInset = UIEdgeInsetsMake(0, 0, 120 / CP_GLOBALSCALE / 2.0, 0);
        self.functionTableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        [self.functionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topBackgroundView.mas_bottom );
            make.left.equalTo( self.rightBackgroundView.mas_left );
            make.height.equalTo( @(self.rightBackgroundView.viewHeight - 120 / CP_GLOBALSCALE ) );
            make.right.equalTo( self.rightBackgroundView.mas_right );
        }];
        self.functionTableView.hidden = YES;
        // 职能类型
        [self.rightBackgroundView addSubview:self.dutyView];
        [self.dutyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.topBackgroundView.mas_bottom );
            make.left.equalTo( self.rightBackgroundView.mas_left );
            make.height.equalTo( @( buttonHeight ) );
            make.right.equalTo( self.rightBackgroundView.mas_right );
        }];
        [self.dutyLabel setUserInteractionEnabled:YES];
        if (![self isBlank:self.viewModel.subModel.jobFunctions]) {
            self.dutyLabel.text = self.viewModel.subModel.jobFunctions;
        }else{
            self.dutyLabel.text = @"不限";
        }
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFun:)];
        [self.dutyLabel addGestureRecognizer:tapGesture];
        CGFloat tempHeight = 40;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempHeight = 24 ;
        CGFloat tempTop = 60;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempTop = 24;
        // 学历
        [self.rightBackgroundView addSubview:self.educationBackgroundView];
        [self.educationBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.dutyView.mas_bottom );
            make.left.equalTo( self.rightBackgroundView.mas_left );
            make.height.equalTo( @( ( tempTop + 42 + tempHeight + 90 + tempHeight + 90 + tempTop + tempHeight + 90 + tempHeight) / CP_GLOBALSCALE ) );
            make.right.equalTo( self.rightBackgroundView.mas_right );
        }];
        // 工作性质
        [self.rightBackgroundView addSubview:self.workingPropertyBackgroundView];
        [self.workingPropertyBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.educationBackgroundView.mas_bottom );
            make.left.equalTo( self.rightBackgroundView.mas_left );
            make.height.equalTo( @( ( tempTop + 42 + tempHeight + 90 + tempTop ) / CP_GLOBALSCALE ) );
            make.right.equalTo( self.rightBackgroundView.mas_right );
        }];
        // 招聘类型
        [self.rightBackgroundView addSubview:self.recruitmentTypeBackgroundView];
        [self.recruitmentTypeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.workingPropertyBackgroundView.mas_bottom );
            make.left.equalTo( self.rightBackgroundView.mas_left );
            make.height.equalTo( @( ( tempTop + 42 + tempHeight + 90 + tempTop ) / CP_GLOBALSCALE ) );
            make.right.equalTo( self.rightBackgroundView.mas_right );
        }];
        CGFloat bottomButtonHeight = 150 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            buttonHeight = 100 / ( 3.0 * ( 1 / 1.29 ) );
        // 底部两个按钮
        [self.rightBackgroundView addSubview:self.resetButton];
        [self.rightBackgroundView addSubview:self.ensureButton];
        [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.rightBackgroundView.mas_left );
            make.bottom.equalTo( self.rightBackgroundView.mas_bottom );
            make.height.equalTo( @( bottomButtonHeight ) );
            make.right.equalTo( self.ensureButton.mas_left );
        }];
        [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.rightBackgroundView.mas_right );
            make.height.equalTo( @( bottomButtonHeight ) );
            make.bottom.equalTo( self.rightBackgroundView.mas_bottom );
            make.width.equalTo( self.resetButton.mas_width );
            make.left.equalTo( self.resetButton.mas_right );
        }];
        // 底部按钮上的分隔线
        UIView *bottomSeparatorLine = [[UIView alloc] init];
        [bottomSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.rightBackgroundView addSubview:bottomSeparatorLine];
        [bottomSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.rightBackgroundView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( self.resetButton.mas_top );
            make.right.equalTo( self.rightBackgroundView.mas_right );
        }];
    }
    return self;
}
-(void)clickFun:(UIView *)view{
    self.functionTableView.hidden = NO;
    [self.functionTableView reloadData];
}
#pragma mark - CPResumeEditFirstExpectCellDelegate
- (void)editFirstExpectCell:(CPResumeEditFirstExpectCell *)editFirstExpectCell changeHeight:(CGFloat)changeHeight selectedRow:(NSInteger)selectedRow
{
    self.changeHeight = changeHeight;
    self.selectedSecondRow = selectedRow;
    if ( -1 != self.selectedFirstRow )
    {
        [self.functionTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)editFirstExpectCell:(CPResumeEditFirstExpectCell *)editFirstExpectCell selecetdBaseCode:(BaseCode *)selecetdBaseCode isAdd:(BOOL)isAdd
{
    if ( isAdd )
    {
        [MobClick event:@"post_chose_true"];
        if (self.jobFunctions && self.jobFunctions.count>0) {
            [self.jobFunctions removeAllObjects];
        }
        [self.jobFunctions addObject:selecetdBaseCode.CodeKey];
        self.selectCode = selecetdBaseCode;
        self.dutyLabel.text =selecetdBaseCode.CodeName;
        if ( -1 != self.selectedFirstRow )
        {
        }
        self.functionTableView.hidden = YES;
    }
    else
    {
    }
}
#pragma mark UITableViewDataScource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.selectedFirstRow == indexPath.row )
    {
        BaseCode *code = self.datas[indexPath.row];
        NSMutableArray *firstArray = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
        CGFloat height = 144.0 / CP_GLOBALSCALE * ([firstArray count] + 1) + self.changeHeight;
        return height;
    }
    return 144.0 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPResumeEditFirstExpectCell *cell = [CPResumeEditFirstExpectCell editFirstExpectCellWithTableView:tableView];
    BaseCode *code = self.datas[indexPath.row];
    [cell setEditFirstExpectCellDelegate:self];
    NSMutableArray *firstArray = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
    BOOL isSelected = NO;
    if ( self.selectedFirstRow == indexPath.row )
        isSelected = YES;
    NSMutableArray *selectedRegions = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.jobFunctions]];
    [cell configWithTitle:code.CodeName firstChildArray:firstArray isSelected:isSelected selectedRegions:selectedRegions selectedSecondRow:self.selectedSecondRow];
    [cell changeContenTableWidth:self.rightBackgroundView.viewWidth];
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.changeHeight = 0;
    self.selectedSecondRow = -1;
    if ( tableView == self.functionTableView )
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ( indexPath.row != self.selectedFirstRow )
        {
            NSInteger tempRow = -1;
            if ( -1 != self.selectedFirstRow )
                tempRow = self.selectedFirstRow;
            self.selectedFirstRow = indexPath.row;
            [self.functionTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            if ( -1 != tempRow )
            {
                [self.functionTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else
        {
            NSInteger tempRow = -1;
            tempRow = self.selectedFirstRow;
            self.selectedFirstRow = -1;
            if ( -1 != tempRow )
            {
                [self.functionTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}
#pragma mark - events
- (void)clickedBackButton
{
    if(![self.functionTableView isHidden]){
        self.functionTableView.hidden = YES;
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    CGFloat originX = weakSelf.rightBackgroundView.viewX;
    
    [self back];
    [UIView animateWithDuration:0.50 animations:^{
        weakSelf.rightBackgroundView.viewX = weakSelf.viewWidth;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        
        weakSelf.rightBackgroundView.viewX = originX;
    }];
}
-(void)resetView
{
    //设置已选中的学历
    if (![self isBlank:self.viewModel.subModel.Degree]) {
        NSArray *views = [_educationBackgroundView subviews];
        for(UIView *view in views)
        {
            if ([view isKindOfClass:[UIButton class]]) {
                if (((UIButton *)view).titleLabel.text) {
                    
                        if ([((UIButton *)view).titleLabel.text isEqualToString:self.viewModel.subModel.DegreeStr]) {
                            ((UIButton *)view).selected = YES;
                            self.eduSelectBtn = (UIButton *)view;
                        }else{
                            ((UIButton *)view).selected = NO;
                        }
                }
            }
        }
    }
    //设置已选中的工作性质
    if (![self isBlank:self.viewModel.subModel.jobPropertys]) {
        NSArray *views = [_workingPropertyBackgroundView subviews];
        for(UIView *view in views)
        {
            if ([view isKindOfClass:[UIButton class]]) {
                if (((UIButton *)view).titleLabel.text) {
                    
                    if ([((UIButton *)view).titleLabel.text isEqualToString:self.viewModel.subModel.jobPropertys]) {
                        ((UIButton *)view).selected = YES;
                        self.workingSelectBtn = (UIButton *)view;
                    }else{
                        ((UIButton *)view).selected = NO;
                    }
                    
                }
            }
        }
    }
    //设置已选中的招聘类型
    if (![self isBlank:self.viewModel.subModel.positionType]) {
        NSArray *views = [_recruitmentTypeBackgroundView subviews];
        for(UIView *view in views)
        {
            if ([view isKindOfClass:[UIButton class]]) {
                if (((UIButton *)view).titleLabel.text) {
                    
                    if ([((UIButton *)view).titleLabel.text isEqualToString:self.viewModel.subModel.positionType]) {
                        ((UIButton *)view).selected = YES;
                        
                        self.recruitmentTypeSelectBtn  = (UIButton *)view;
                    }else{
                        ((UIButton *)view).selected = NO;
                    }
                }
            }
        }
    }
}
-(void)back{
    [self.eduSelectBtn setSelected:NO];
    [self.workingSelectBtn setSelected:NO];
    [self.recruitmentTypeSelectBtn setSelected:NO];
    [self.eduFirstSelectBtn setSelected:YES];
    [self.workingFirstSelectBtn setSelected:YES];
    [self.recruitmentTypeFirstSelectBtn setSelected:YES];
    self.eduSelectBtn = self.eduFirstSelectBtn;
    self.workingSelectBtn = self.workingFirstSelectBtn;
    self.recruitmentTypeSelectBtn= self.recruitmentTypeFirstSelectBtn;
    self.eduStr = @"";
    self.workStr=@"";
    self.recruitmentTypeStr=@"";
    [self.jobFunctions removeAllObjects];
    if (nil == self.viewModel.subModel.jobFunctions || NULL == self.viewModel.subModel.jobFunctions || [self.viewModel.subModel.jobFunctions isEqualToString:@""]) {
        self.dutyLabel.text = @"不限";
    }else{
        self.dutyLabel.text=self.viewModel.subModel.jobFunctions;
    }
    self.selectCode = nil;
}
-(void)resetBtn{
    [self.eduSelectBtn setSelected:NO];
    [self.workingSelectBtn setSelected:NO];
    [self.recruitmentTypeSelectBtn setSelected:NO];
    [self.eduFirstSelectBtn setSelected:YES];
    [self.workingFirstSelectBtn setSelected:YES];
    [self.recruitmentTypeFirstSelectBtn setSelected:YES];
    self.eduSelectBtn = self.eduFirstSelectBtn;
    self.workingSelectBtn = self.workingFirstSelectBtn;
    self.recruitmentTypeSelectBtn= self.recruitmentTypeFirstSelectBtn;
    self.eduStr = @"";
    self.workStr=@"";
    self.recruitmentTypeStr=@"";
    [self.jobFunctions removeAllObjects];
    self.viewModel.subModel.DegreeStr = @"";
    self.viewModel.subModel.Degree = @"";
    self.viewModel.subModel.positionType = @"";
    self.viewModel.subModel.positionTypekey = @"";
    self.viewModel.subModel.jobPropertys = @"";
    self.viewModel.subModel.jobFunctionskey = @"";
    self.viewModel.subModel.jobFunctions = @"";
    self.viewModel.subModel.jobFunctionskey = @"";
    self.dutyLabel.text = @"不限";
    self.selectCode = nil;
}
#pragma mark - getter methods
- (UIView *)rightBackgroundView
{
    if ( !_rightBackgroundView )
    {
        _rightBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(120 / CP_GLOBALSCALE, 0, self.viewWidth - 120 / CP_GLOBALSCALE, self.viewHeight)];
        [_rightBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        
        [_rightBackgroundView addSubview:self.topBackgroundView];
    }
    return _rightBackgroundView;
}
- (UIView *)topBackgroundView
{
    if ( !_topBackgroundView )
    {
        _topBackgroundView = [[UIView alloc] init];
        [_topBackgroundView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    }
    return _topBackgroundView;
}
- (UIButton *)backButton
{
    if ( !_backButton )
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"filter_ic_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickedBackButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setText:@"更多筛选"];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}
- (UIView *)dutyView
{
    if ( !_dutyView )
    {
        _dutyView = [[UIView alloc] init];
        UILabel *dutyTitleLabel = [[UILabel alloc] init];
        [dutyTitleLabel setText:@"职能类型"];
        [dutyTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [dutyTitleLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [_dutyView addSubview:dutyTitleLabel];
        [dutyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _dutyView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( _dutyView.mas_top );
            make.height.equalTo( _dutyView.mas_height );
            make.width.equalTo( @( 42 / CP_GLOBALSCALE * 5 ) );
        }];
        
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.image = [UIImage imageNamed:@"ic_next"];
        [_dutyView addSubview:arrowView];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _dutyView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.centerY.equalTo( _dutyView.mas_centerY );
            make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
        }];
        
        [_dutyView addSubview:self.dutyLabel];
        [self.dutyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _dutyView.mas_top );
            make.left.equalTo( dutyTitleLabel.mas_right ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( arrowView.mas_left ).offset( 0 );
            make.height.equalTo( _dutyView.mas_height );
        }];
        
        // 分隔线
        UIView *bottomSeparatorLine = [[UIView alloc] init];
        [bottomSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_dutyView addSubview:bottomSeparatorLine];
        [bottomSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _dutyView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( _dutyView.mas_bottom );
            make.right.equalTo( _dutyView.mas_right );
        }];
    }
    return _dutyView;
}

- (UILabel *)dutyLabel
{
    if ( !_dutyLabel )
    {
        _dutyLabel = [[UILabel alloc] init];
        [_dutyLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_dutyLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_dutyLabel setTextAlignment:NSTextAlignmentRight];
//        [_dutyLabel setText:@"多媒体／游戏开发工程师，语言录音师，后台开发"];
    }
    return _dutyLabel;
}
- (UIButton *)resetButton
{
    if ( !_resetButton )
    {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetButton setTitle:@"重置选项" forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_resetButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_resetButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_resetButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"efeff4"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_resetButton addTarget:self action:@selector(resetParams:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}
#pragma 重置
-(void)resetParams:(UIButton *)btn{
   
    [self resetBtn];
}
- (UIButton *)ensureButton
{
    if ( !_ensureButton )
    {
        _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_ensureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_ensureButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_ensureButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_ensureButton addTarget:self action:@selector(ensuerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureButton;
}

#pragma mark 确定
-(void)ensuerClick:(UIButton *)btn{
    
    if(nil != self.viewModel.subModel){
        //学历
        if(nil != self.eduStr){
            if([self.eduStr isEqualToString:@"中专及以下"]){
                self.viewModel.subModel.Degree = @"12";
            }else if([self.eduStr isEqualToString:@"大专"]){
                self.viewModel.subModel.Degree = @"13";
            }else if([self.eduStr isEqualToString:@"本科"]){
                self.viewModel.subModel.Degree = @"14";
            }else if([self.eduStr isEqualToString:@"MBA"]){
                self.viewModel.subModel.Degree = @"15";
            }else if([self.eduStr isEqualToString:@"硕士"]){
                self.viewModel.subModel.Degree = @"16";
            }else if([self.eduStr isEqualToString:@"博士及以上"]){
                self.viewModel.subModel.Degree = @"17";
            }else if([self.eduStr isEqualToString:@"EMBA"]){
                self.viewModel.subModel.Degree = @"7065";
            }else{
                self.viewModel.subModel.Degree = @"";
            }
        }else{
            self.viewModel.subModel.Degree = @"";
        }
        self.viewModel.subModel.DegreeStr = self.eduStr;
        //工作性质
        if(nil != self.workStr){
            self.viewModel.subModel.jobPropertys = self.workStr;
            if([self.workStr isEqualToString:@"全职"]){
                self.viewModel.subModel.jobPropertyskey = @"1";
            }else if([self.workStr isEqualToString:@"实习"]){
                self.viewModel.subModel.jobPropertyskey = @"4";
            }else{
                self.viewModel.subModel.jobPropertyskey = @"";
            }
        }else{
            self.viewModel.subModel.jobPropertyskey = @"";
        }
        //招聘类型
        if(nil != self.recruitmentTypeStr){
            self.viewModel.subModel.positionType = self.recruitmentTypeStr;
            if([self.recruitmentTypeStr isEqualToString:@"校园招聘"]){
                self.viewModel.subModel.positionTypekey = @"1";
            }else if([self.recruitmentTypeStr isEqualToString:@"社会招聘"]){
                self.viewModel.subModel.positionTypekey = @"2";
            }else{
                self.viewModel.subModel.positionTypekey = @"";
            }
        }else
        {
            self.viewModel.subModel.positionTypekey = @"";
        }
    }
    if (self.selectCode) {
        self.viewModel.subModel.jobFunctions = self.selectCode.CodeName;
        self.viewModel.subModel.jobFunctionskey = [NSString stringWithFormat:@"%d",self.selectCode.CodeKey.intValue ];
    }
    [self.filterChangeDeleger moreSure];
    __weak typeof(self) weakSelf = self;
    CGFloat originX = weakSelf.rightBackgroundView.viewX;
    [UIView animateWithDuration:0.50 animations:^{
        weakSelf.rightBackgroundView.viewX = weakSelf.viewWidth;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        
        weakSelf.rightBackgroundView.viewX = originX;
    }];
}
- (NSArray *)educationArray
{
    if ( !_educationArray )
    {
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObject:@"全部"];
        [temp addObject:@"中专及以下"];
        [temp addObject:@"大专"];
        [temp addObject:@"本科"];
        [temp addObject:@"硕士"];
        [temp addObject:@"MBA"];
        [temp addObject:@"EMBA"];
        [temp addObject:@"博士及以上"];
        _educationArray = [temp copy];
    }
    return _educationArray;
}
- (NSArray *)workingPropertyArray
{
    if ( !_workingPropertyArray )
    {
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObject:@"全部"];
        [temp addObject:@"全职"];
        [temp addObject:@"实习"];
        _workingPropertyArray = [temp copy];
    }
    return _workingPropertyArray;
}
- (NSArray *)recruitmenttypeArray
{
    if ( !_recruitmenttypeArray )
    {
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObject:@"全部"];
        [temp addObject:@"社会招聘"];
        [temp addObject:@"校园招聘"];
        _recruitmenttypeArray = [temp copy];
    }
    return _recruitmenttypeArray;
}
- (UIView *)educationBackgroundView
{
    if ( !_educationBackgroundView )
    {
        _educationBackgroundView = [[UIView alloc] init];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [titleLabel setText:@"学历"];
        [_educationBackgroundView addSubview:titleLabel];
        CGFloat topMarge = 60 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            topMarge = 24 / CP_GLOBALSCALE;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _educationBackgroundView.mas_top ).offset( topMarge );
            make.left.equalTo( _educationBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( titleLabel.font.pointSize * 2 ) );
            make.height.equalTo( @( titleLabel.font.pointSize ) );
        }];
        
        CGFloat buttonX = 40 / CP_GLOBALSCALE;
        CGFloat buttonY = topMarge;
        CGFloat buttonW = 242 / CP_GLOBALSCALE;
        CGFloat margin = ((self.viewWidth - 120 / CP_GLOBALSCALE) - buttonW * 3 - 40 / CP_GLOBALSCALE * 2) / 2.0;
        CGFloat buttonH = 90 / CP_GLOBALSCALE;
        for( NSUInteger index = 0; index < [self.educationArray count]; index++ )
        {
            NSString *buttonTitleStr = self.educationArray[index];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitleStr forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
            [button setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateHighlighted];
            [button.layer setCornerRadius:6 / CP_GLOBALSCALE];
            [button.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
            [button.layer setBorderWidth:2 / CP_GLOBALSCALE];
            [button.layer setMasksToBounds:YES];
            [button setTag:index];
            [button addTarget:self action:@selector(eduClick:) forControlEvents:UIControlEventTouchUpInside];
            if(self.viewModel.subModel.Degree && [self.viewModel.subModel.Degree isEqualToString:buttonTitleStr]){
                [button setSelected:YES];
                self.eduSelectBtn = button;
                self.eduFirstSelectBtn = button;
            }
            if ( (index > 2 && index < 4) || (index>5 && index<7))
            {
                buttonX = 40 / CP_GLOBALSCALE;
                buttonY += topMarge + buttonH;
            }
            if ( 0 == index && [self isBlank:self.viewModel.subModel.Degree]){
                [button setSelected:YES];
                self.eduSelectBtn = button;
                self.eduFirstSelectBtn = button;
            }
            if(0 == index){
                self.eduFirstSelectBtn = button;
            }
            [_educationBackgroundView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( titleLabel.mas_bottom ).offset( buttonY );
                make.left.equalTo( _educationBackgroundView.mas_left ).offset( buttonX );
                make.height.equalTo( @( buttonH ) );
                make.width.equalTo( @( buttonW ) );
            }];
            
            buttonX += margin + buttonW;
        }
        // 分隔线
        UIView *bottomSeparatorLine = [[UIView alloc] init];
        [bottomSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_educationBackgroundView addSubview:bottomSeparatorLine];
        [bottomSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _educationBackgroundView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.top.equalTo( _educationBackgroundView.mas_bottom );
            make.right.equalTo( _educationBackgroundView.mas_right );
        }];
    }
    return _educationBackgroundView;
}
-(BOOL)isBlank:(NSString *)content{
    if (nil == content || NULL == content || [content isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
#pragma 学历点击监听
-(void)eduClick:(UIButton *)btn{
    if(self.eduSelectBtn==btn){
        if(self.eduSelectBtn.isSelected){
            return;
        }else{
            [self.eduSelectBtn setSelected:YES];
            self.eduStr = self.educationArray[[btn tag]];
        }
    }else{
        [self.eduSelectBtn setSelected:NO];
        [btn setSelected:YES];
        self.eduSelectBtn  = btn;
        self.eduStr = self.educationArray[[btn tag]];
    }
    
    if([btn tag]==0){
        self.eduStr = @"";
    }
    [MobClick event:@"education_choose"];
}
#pragma 工作性质点击监听
-(void)workClick:(UIButton *)btn{
    if(self.workingSelectBtn==btn){
        if(self.workingSelectBtn.isSelected){
            return;
        }else{
            [self.workingSelectBtn setSelected:YES];
            self.workStr = self.workingPropertyArray[[btn tag]];
        }
    }else{
        [self.workingSelectBtn setSelected:NO];
        [btn setSelected:YES];
        self.workingSelectBtn  = btn;
        self.workStr = self.workingPropertyArray[[btn tag]];
    }
    if([btn tag]==0){
        self.workStr = @"";
    }
}
#pragma 招聘类型点击监听
-(void)zhaopinClick:(UIButton *)btn{
    if(self.recruitmentTypeSelectBtn==btn){
        if(self.recruitmentTypeSelectBtn.isSelected){
            return;
        }
        else
        {
            [self.recruitmentTypeSelectBtn setSelected:YES];
            self.recruitmentTypeStr = self.recruitmenttypeArray[[btn tag]];
        }
    }
    else
    {
        [self.recruitmentTypeSelectBtn setSelected:NO];
        [btn setSelected:YES];
        self.recruitmentTypeSelectBtn  = btn;
        self.recruitmentTypeStr = self.recruitmenttypeArray[[btn tag]];
    }
    if([btn tag]==0){
        self.recruitmentTypeStr = @"";
    }
    [MobClick event:@"choose_zplx"];
}
- (UIView *)workingPropertyBackgroundView
{
    if ( !_workingPropertyBackgroundView )
    {
        CGFloat tempHeight = 40 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempHeight = 24 / CP_GLOBALSCALE;
        CGFloat buttonHeight = 144 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            buttonHeight = 100 / ( 3.0 * ( 1 / 1.29 ) );
        CGFloat tempTop = 60 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempTop = 24 / CP_GLOBALSCALE;
        _workingPropertyBackgroundView = [[UIView alloc] init];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [titleLabel setText:@"工作性质"];
        [_workingPropertyBackgroundView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _workingPropertyBackgroundView.mas_top ).offset( tempTop );
            make.left.equalTo( _workingPropertyBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( titleLabel.font.pointSize * 5 ) );
            make.height.equalTo( @( titleLabel.font.pointSize ) );
        }];
        CGFloat buttonX = 40 / CP_GLOBALSCALE;
        CGFloat buttonY = tempHeight;
        CGFloat buttonW = 242 / CP_GLOBALSCALE;
        CGFloat margin = ((self.viewWidth - 120 / CP_GLOBALSCALE) - buttonW * 3 - 40 / CP_GLOBALSCALE * 2) / 2.0;
        CGFloat buttonH = 90 / CP_GLOBALSCALE;
        for( NSUInteger index = 0; index < [self.workingPropertyArray count]; index++ )
        {
            NSString *buttonTitleStr = self.workingPropertyArray[index];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitleStr forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
            [button setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateHighlighted];
            [button.layer setCornerRadius:6 / CP_GLOBALSCALE];
            [button.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
            [button.layer setBorderWidth:2 / CP_GLOBALSCALE];
            [button.layer setMasksToBounds:YES];
            [button setTag:index];
            if(self.viewModel.subModel.jobPropertys && [self.viewModel.subModel.jobPropertys isEqualToString:buttonTitleStr]){
                [button setSelected:YES];
                self.workingSelectBtn = button;
                self.workingFirstSelectBtn = button;
            }
            if(0 == index)
            {
                self.workingFirstSelectBtn = button;
            }
            [button addTarget:self action:@selector(workClick:) forControlEvents:UIControlEventTouchUpInside];
            if ( 0 == index && [self isBlank:self.viewModel.subModel.jobPropertys]){
                [button setSelected:YES];
                self.workingSelectBtn = button;
                self.workingFirstSelectBtn = button;
            }
            [_workingPropertyBackgroundView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( titleLabel.mas_bottom ).offset( buttonY );
                make.left.equalTo( _workingPropertyBackgroundView.mas_left ).offset( buttonX );
                make.height.equalTo( @( buttonH ) );
                make.width.equalTo( @( buttonW ) );
            }];
            buttonX += margin + buttonW;
        }
        // 分隔线
        UIView *bottomSeparatorLine = [[UIView alloc] init];
        [bottomSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [_workingPropertyBackgroundView addSubview:bottomSeparatorLine];
        [bottomSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _workingPropertyBackgroundView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.bottom.equalTo( _workingPropertyBackgroundView.mas_bottom );
            make.right.equalTo( _workingPropertyBackgroundView.mas_right );
        }];
    }
    return _workingPropertyBackgroundView;
}
- (UIView *)recruitmentTypeBackgroundView
{
    if ( !_recruitmentTypeBackgroundView )
    {
        CGFloat tempHeight = 40 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempHeight = 24 / CP_GLOBALSCALE;
        CGFloat buttonHeight = 144 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            buttonHeight = 100 / ( 3.0 * ( 1 / 1.29 ) );
        CGFloat tempTop = 60 / CP_GLOBALSCALE;
        if ( CP_IS_IPHONE_4_OR_LESS )
            tempTop = 24 / CP_GLOBALSCALE;
        _recruitmentTypeBackgroundView = [[UIView alloc] init];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
        [titleLabel setText:@"招聘类型"];
        [_recruitmentTypeBackgroundView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _recruitmentTypeBackgroundView.mas_top ).offset( tempTop );
            make.left.equalTo( _recruitmentTypeBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( titleLabel.font.pointSize * 5 ) );
            make.height.equalTo( @( titleLabel.font.pointSize ) );
        }];
        CGFloat buttonX = 40 / CP_GLOBALSCALE;
        CGFloat buttonY = tempHeight;
        CGFloat buttonW = 242 / CP_GLOBALSCALE;
        CGFloat margin = ((self.viewWidth - 120 / CP_GLOBALSCALE) - buttonW * 3 - 40 / CP_GLOBALSCALE * 2) / 2.0;
        CGFloat buttonH = 90 / CP_GLOBALSCALE;
        for( NSUInteger index = 0; index < [self.recruitmenttypeArray count]; index++ )
        {
            NSString *buttonTitleStr = self.recruitmenttypeArray[index];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitleStr forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
            [button setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"] cornerRadius:0.0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateHighlighted];
            [button.layer setCornerRadius:6 / CP_GLOBALSCALE];
            [button.layer setBorderColor:[UIColor colorWithHexString:@"e1e1e3"].CGColor];
            [button.layer setBorderWidth:2 / CP_GLOBALSCALE];
            [button.layer setMasksToBounds:YES];
            [button setTag:index];
            if(self.viewModel.subModel.positionType && [self.viewModel.subModel.positionType isEqualToString:buttonTitleStr]){
                [button setSelected:YES];
                self.recruitmentTypeSelectBtn = button;
                self.recruitmentTypeFirstSelectBtn = button;
            }
            [button addTarget:self action:@selector(zhaopinClick:) forControlEvents:UIControlEventTouchUpInside];
            if ( 0 == index && [self isBlank:self.viewModel.subModel.positionType])
            {
                [button setSelected:YES];
                self.recruitmentTypeSelectBtn = button;
                self.recruitmentTypeFirstSelectBtn = button;
            }
            if(0 == index){
                self.recruitmentTypeFirstSelectBtn = button;
            }
            [_recruitmentTypeBackgroundView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( titleLabel.mas_bottom ).offset( buttonY );
                make.left.equalTo( _recruitmentTypeBackgroundView.mas_left ).offset( buttonX );
                make.height.equalTo( @( buttonH ) );
                make.width.equalTo( @( buttonW ) );
            }];
            buttonX += margin + buttonW;
        }
    }
    return _recruitmentTypeBackgroundView;
}
@end
