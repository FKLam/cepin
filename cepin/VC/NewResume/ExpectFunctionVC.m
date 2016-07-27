//
//  ExpectFunctionVC.m
//  cepin
//
//  Created by dujincai on 15/6/15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExpectFunctionVC.h"
#import "ExpectFunctionVM.h"
#import "CPCommon.h"
#import "TBTextUnit.h"
#import "ComChooseCell.h"
#import "JobFunctionHeaderView.h"
#import "ExpectFunctionSecondVC.h"
#import "AOTag.h"
#import "BaseCodeDTO.h"
#import "UIViewController+NavicationUI.h"
#import "CPResumeGuideExperienceCityButton.h"
#import "CPResumeEditExpectWorkReformer.h"
#import "CPResumeEditFirstExpectCell.h"
@interface ExpectFunctionVC ()<AOTagDelegate,JobFunctionHeaderViewDelegate, CPResumeEditFirstExpectCellDelegate>
@property(nonatomic,strong)ResumeNameModel *resumeNameModel;
@property(nonatomic,strong)ExpectFunctionVM *viewModel;
@property(nonatomic,strong) AOTagList *tagListView;
@property(nonatomic,strong)NSMutableArray *secDatas;
@property(nonatomic,strong)UIView *selectedFunctionView;
@property(nonatomic)int selectedCount;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,strong)NSMutableArray *headView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIImageView *clickImage;
@property (nonatomic, assign) NSInteger selectedFirstRow;
@property (nonatomic, assign) NSInteger selectedSecondRow;
@property (nonatomic, assign) CGFloat changeHeight;
@property (nonatomic, strong) UIView *maxSelecetdTipsView;
@end

@implementation ExpectFunctionVC

-(instancetype)initWithResumeModel:(ResumeNameModel *)model
{
    if (self = [super init]) {
        self.resumeNameModel = model;
        self.viewModel = [[ExpectFunctionVM alloc] initWithResumeModel:model];
        self.secDatas = [NSMutableArray new];
    }
    return self;
}

-(void)clickedBackBtn:(id)sender
{
    if (!self.viewModel.resumeJobFunction || [self.viewModel.resumeJobFunction isEqualToString:@""]) {
        self.resumeNameModel.ExpectJobFunction = @"";
    }else{
        self.resumeNameModel.ExpectJobFunction = self.viewModel.resumeJobFunction;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职能类别";
    self.selectedFirstRow = -1;
    self.selectedSecondRow = -1;
    self.changeHeight = 0;
    self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(clickedBackBtn:)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self createSelectedFunctionView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight, self.view.viewWidth, (self.view.viewHeight)-144-((IsIOS7)?20:0)) style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight, self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120 / CP_GLOBALSCALE / 2.0, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.dataArray = [NSMutableArray new];
    for (int i = 0; i < self.viewModel.datas.count; i++) {
        BaseCode *item = self.viewModel.datas[i];
        [self.dataArray addObject:item.CodeName];
    }
    [RACObserve(self.viewModel, isShrink) subscribeNext:^(id isShrink) {
        if (!self.viewModel.isShrink) {
            self.selectedFunctionView.frame = CGRectMake(0, 64.0, self.view.viewWidth, 144 / CP_GLOBALSCALE);
            self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight, self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
            self.tagListView.hidden = YES;
            self.clickImage.image = [UIImage imageNamed:@"ic_down"];
            [self.tableView reloadData];
        }else
        {
            CGFloat expectWorkH = [CPResumeEditExpectWorkReformer selecteExpectWorkHeight:self.secDatas];
            self.selectedFunctionView.frame = CGRectMake(0, 64.0, self.view.viewWidth, (144 ) / CP_GLOBALSCALE + expectWorkH);
            self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight, self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
            self.tagListView.hidden = NO;
            self.clickImage.image = [UIImage imageNamed:@"ic_up"];
            [self.tagListView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.selectedFunctionView.mas_left);
                make.right.equalTo(self.selectedFunctionView.mas_right);
                make.top.equalTo( self.selectedFunctionView.mas_top ).offset( 144 / CP_GLOBALSCALE );
                make.height.equalTo( @( expectWorkH ) );
            }];
            [self.tableView reloadData];
        }
    }];
    [self.view addSubview:self.maxSelecetdTipsView];
}
- (void)loadModel
{
    self.headView = [NSMutableArray new];
    for (int i = 0; i < self.dataArray.count; i ++ ) {
        JobFunctionHeaderView *headView = [[JobFunctionHeaderView alloc]init];
        headView.delegate = self;
        headView.section = i;
        headView.jobName.text = [NSString stringWithFormat:@"%@",self.dataArray[i]];
        [self.headView addObject:headView];
    }
}
#pragma mark - CPResumeEditFirstExpectCellDelegate
- (void)editFirstExpectCell:(CPResumeEditFirstExpectCell *)editFirstExpectCell changeHeight:(CGFloat)changeHeight selectedRow:(NSInteger)selectedRow
{
    self.changeHeight = changeHeight;
    self.selectedSecondRow = selectedRow;
    if ( -1 != self.selectedFirstRow )
    {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)editFirstExpectCell:(CPResumeEditFirstExpectCell *)editFirstExpectCell selecetdBaseCode:(BaseCode *)selecetdBaseCode isAdd:(BOOL)isAdd
{
    if ( isAdd )
    {
        if ( 3 == [self.viewModel.jobFunctions count] )
        {
            if ( !self.maxSelecetdTipsView.isHidden )
                return;
            [self.maxSelecetdTipsView setHidden:NO];
            [self.maxSelecetdTipsView setAlpha:1.0];
            __weak typeof( self ) weakSelf = self;
            [UIView animateWithDuration:1.50 animations:^{
                [weakSelf.maxSelecetdTipsView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [weakSelf.maxSelecetdTipsView setHidden:YES];
            }];
            return;
        }
        [self.viewModel.jobFunctions addObject:selecetdBaseCode.CodeKey];
        [self setTagListViewContent];
    }
    else
    {
        BOOL isMax = YES;
        for ( NSString *codeKey in self.viewModel.jobFunctions )
        {
            if ( [codeKey isKindOfClass:[NSString class]] )
            {
                if ( [codeKey isEqualToString:[selecetdBaseCode.CodeKey stringValue]] )
                {
                    [self.viewModel.jobFunctions removeObject:codeKey];
                    isMax = NO;
                    break;
                }
            }
            else if ( [codeKey isKindOfClass:[NSNumber class]] )
            {
                NSNumber *codeKeyStr = (NSNumber *)codeKey;
                if ( [[codeKeyStr stringValue] isEqualToString:[selecetdBaseCode.CodeKey stringValue]] )
                {
                    [self.viewModel.jobFunctions removeObject:codeKey];
                    isMax = NO;
                    break;
                }
            }
        }
        if ( isMax )
        {
            if ( 3 == [self.viewModel.jobFunctions count] )
            {
                if ( !self.maxSelecetdTipsView.isHidden )
                    return;
                [self.maxSelecetdTipsView setHidden:NO];
                [self.maxSelecetdTipsView setAlpha:1.0];
                __weak typeof( self ) weakSelf = self;
                [UIView animateWithDuration:1.50 animations:^{
                    [weakSelf.maxSelecetdTipsView setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [weakSelf.maxSelecetdTipsView setHidden:YES];
                }];
                return;
            }
        }
        [self setTagListViewContent];
    }
}
#pragma mark - HeadViewdelegate
-(void)selectedWith:(JobFunctionHeaderView *)view
{
    //    self.currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[self.headView count];i++)
        {
            JobFunctionHeaderView *head = [self.headView objectAtIndex:i];
            head.open = NO;
        }
        [self.tableView reloadData];
        return;
    }
    self.currentSection = view.section;
    [self reset];
    
}
//界面重置
- (void)reset
{
    for(int i = 0;i<[self.headView count];i++)
    {
        JobFunctionHeaderView *head = [self.headView objectAtIndex:i];
        
        if(head.section == self.currentSection)
        {
            head.open = YES;
        }else {
            head.open = NO;
        }
        
    }
    [self.tableView reloadData];
}
- (void)createSelectedFunctionView
{
    self.selectedFunctionView = [[UIView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.viewWidth, 144 / CP_GLOBALSCALE)];
    self.selectedFunctionView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self.view addSubview:self.selectedFunctionView];
    NSString *staticTitle = @"编辑已选条件";
    UILabel *staticTitleLabel = [[UILabel alloc] init];
    [staticTitleLabel setText:staticTitle];
    [staticTitleLabel setTextColor:[UIColor colorWithHexString:@"288add"]];
    [staticTitleLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
    [self.selectedFunctionView addSubview:staticTitleLabel];
    [staticTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.selectedFunctionView.mas_top );
        make.left.equalTo( self.selectedFunctionView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
    CPResumeGuideExperienceCityButton *click = [CPResumeGuideExperienceCityButton buttonWithType:UIButtonTypeCustom];
    click.backgroundColor = [UIColor clearColor];
    [click setImage:[UIImage imageNamed:@"ic_down_blue"] forState:UIControlStateNormal];
    [click setImage:[UIImage imageNamed:@"ic_up_blue"] forState:UIControlStateSelected];
    [self.selectedFunctionView addSubview:click];
    [click mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo( self.selectedFunctionView.mas_right ).offset( -10 / CP_GLOBALSCALE );
        make.centerY.equalTo( staticTitleLabel.mas_centerY );
        make.width.equalTo( @( 144 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
    [click handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        sender.selected = !sender.isSelected;
        self.viewModel.isShrink = !self.viewModel.isShrink;
    }];
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textColor = [UIColor colorWithHexString:@"288add"];
    self.countLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.countLabel setTextAlignment:NSTextAlignmentRight];
    [self.selectedFunctionView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo( click.mas_left );
        make.height.equalTo( staticTitleLabel );
        make.top.equalTo( staticTitleLabel.mas_top );
    }];
    UIView *separatorLine = [[UIView alloc] init];
    [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    [self.selectedFunctionView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( staticTitleLabel.mas_bottom ).offset( -2 / CP_GLOBALSCALE );
        make.left.equalTo( staticTitleLabel.mas_left );
        make.right.equalTo( self.selectedFunctionView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
    }];
    self.tagListView = [[AOTagList alloc]init];
    [self.tagListView setDelegate:self];
    [self.selectedFunctionView addSubview:self.tagListView];
    [self.tagListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedFunctionView.mas_left);
        make.right.equalTo(self.selectedFunctionView.mas_right);
        make.top.equalTo(separatorLine.mas_bottom);
        make.height.equalTo( @( (60 + 90 + 60) / CP_GLOBALSCALE ) );
    }];
}
- (void)tagListRemoveTagWithTitle:(NSString *)title
{
    [self.secDatas removeObject:title];
    NSMutableArray *array = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctions]];
    [self.viewModel.jobFunctions removeAllObjects];
    for (BaseCode *item in array) {
        if (![title isEqualToString:item.CodeName]) {
            [self.viewModel.jobFunctions addObject:item.CodeKey];
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/3",(unsigned long)self.viewModel.jobFunctions.count];
    self.resumeNameModel.ExpectJobFunction = [TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctions];
    if (!self.viewModel.isShrink) {
        self.selectedFunctionView.frame = CGRectMake(0, 64.0, self.view.viewWidth, 144 / CP_GLOBALSCALE);
        self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight, self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
        self.tagListView.hidden = YES;
        self.clickImage.image = [UIImage imageNamed:@"ic_down"];
    }
    else
    {
        CGFloat expectWorkH = [CPResumeEditExpectWorkReformer selecteExpectWorkHeight:self.secDatas];
        self.selectedFunctionView.frame = CGRectMake(0, 64.0, self.view.viewWidth, (144 ) / CP_GLOBALSCALE + expectWorkH);
        self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight, self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
        self.tagListView.hidden = NO;
        self.clickImage.image = [UIImage imageNamed:@"ic_up"];
        [self.tagListView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectedFunctionView.mas_left);
            make.right.equalTo(self.selectedFunctionView.mas_right);
            make.top.equalTo( self.selectedFunctionView.mas_top ).offset( 144 / CP_GLOBALSCALE );
            make.height.equalTo( @( expectWorkH ) );
        }];
    }
    if ( -1 != self.selectedFirstRow )
    {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)tagDidRemoveTag:(AOTag *)tag
{
    [self tagListRemoveTagWithTitle:tag.tTitle];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setTagListViewContent];
}
- (void)setTagListViewContent
{
    NSMutableArray *array = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctions]];
    [self.secDatas removeAllObjects];
    for (int i = 0; i < array.count; i++) {
        BaseCode *item = array[i];
        [self.secDatas addObject:item.CodeName];
    }
    [self.tagListView removeAllTag];
    self.resumeNameModel.ExpectJobFunction = [TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctions];
    if (!self.viewModel.isShrink) {
        self.selectedFunctionView.frame = CGRectMake(0, 64.0, self.view.viewWidth, 144 / CP_GLOBALSCALE);
        self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight, self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
        self.tagListView.hidden = YES;
    }
    else
    {
        CGFloat expectWorkH = [CPResumeEditExpectWorkReformer selecteExpectWorkHeight:self.secDatas];
        self.selectedFunctionView.frame = CGRectMake(0, 64.0, self.view.viewWidth, (144 ) / CP_GLOBALSCALE + expectWorkH);
        self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight, self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
        self.tagListView.hidden = NO;
        [self.tagListView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectedFunctionView.mas_left);
            make.right.equalTo(self.selectedFunctionView.mas_right);
            make.top.equalTo( self.selectedFunctionView.mas_top ).offset( 144 / CP_GLOBALSCALE );
            make.height.equalTo( @( expectWorkH ) );
        }];
    }
    for (NSInteger i = 0; i < self.secDatas.count; i++)
    {
        [self.tagListView addTag:[self.secDatas objectAtIndex:i] withImage:nil withLabelColor:[UIColor whiteColor]  withBackgroundColor:[UIColor colorWithHexString:@"288add"] withCloseButtonColor:[UIColor whiteColor] isExpectWork:YES];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/3",(unsigned long)self.viewModel.jobFunctions.count];
    self.resumeNameModel.ExpectJobFunction = [TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctions];
    if ( -1 != self.selectedFirstRow )
    {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark UITableViewDataScource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.selectedFirstRow == indexPath.row )
    {
        BaseCode *code = self.viewModel.datas[indexPath.row];
        NSMutableArray *firstArray = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
        CGFloat height = 144 / CP_GLOBALSCALE * ([firstArray count] + 1) + self.changeHeight;
        return height;
    }
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.datas count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPResumeEditFirstExpectCell *cell = [CPResumeEditFirstExpectCell editFirstExpectCellWithTableView:tableView];
    BaseCode *code = self.viewModel.datas[indexPath.row];
    [cell setEditFirstExpectCellDelegate:self];
    NSMutableArray *firstArray = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
    BOOL isSelected = NO;
    if ( self.selectedFirstRow == indexPath.row )
        isSelected = YES;
    NSMutableArray *selectedRegions = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctions]];
    [cell configWithTitle:code.CodeName firstChildArray:firstArray isSelected:isSelected selectedRegions:selectedRegions selectedSecondRow:self.selectedSecondRow];
    [cell changeContenTableWidth:kScreenWidth];
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.changeHeight = 0;
    self.selectedSecondRow = -1;
    if ( tableView == self.tableView )
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ( indexPath.row != self.selectedFirstRow )
        {
            NSInteger tempRow = -1;
            if ( -1 != self.selectedFirstRow )
                tempRow = self.selectedFirstRow;
            self.selectedFirstRow = indexPath.row;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            if ( -1 != tempRow )
            {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else
        {
            NSInteger tempRow = -1;
            tempRow = self.selectedFirstRow;
            self.selectedFirstRow = -1;
            if ( -1 != tempRow )
            {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}
- (UIView *)maxSelecetdTipsView
{
    if ( !_maxSelecetdTipsView )
    {
        CGFloat W = 575 / CP_GLOBALSCALE;
        CGFloat H = 170 / CP_GLOBALSCALE;
        CGFloat X = ( kScreenWidth - W ) / 2.0;
        CGFloat Y = kScreenHeight - 144 / CP_GLOBALSCALE * 3 - H;
        _maxSelecetdTipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [_maxSelecetdTipsView.layer setCornerRadius:H / 2.0];
        [_maxSelecetdTipsView.layer setMasksToBounds:YES];
        [_maxSelecetdTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000"]];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [titleLabel setText:@"最多可选择3个！"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_maxSelecetdTipsView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _maxSelecetdTipsView.mas_top );
            make.left.equalTo( _maxSelecetdTipsView.mas_left );
            make.bottom.equalTo( _maxSelecetdTipsView.mas_bottom );
            make.right.equalTo( _maxSelecetdTipsView.mas_right );
        }];
        [_maxSelecetdTipsView setAlpha:0.0];
        [_maxSelecetdTipsView setHidden:YES];
    }
    return _maxSelecetdTipsView;
}
@end