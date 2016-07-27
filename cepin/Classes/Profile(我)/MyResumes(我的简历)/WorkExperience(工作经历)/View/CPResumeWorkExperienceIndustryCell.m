//
//  CPResumeWorkExperienceIndustryCell.m
//  cepin
//
//  Created by ceping on 16/2/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeWorkExperienceIndustryCell.h"
#import "CPResumeWorkExperienceSecondIndustryCell.h"
#import "CPCommon.h"
@interface CPResumeWorkExperienceIndustryCell ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,retain)UILabel *labelTitle;
@property(nonatomic,retain)UIImageView *imageViewArrow;
@property (nonatomic, strong) NSMutableArray *childArray;
@property (nonatomic, assign) BOOL isSeleceted;
@property (nonatomic, strong) UITableView *secondTabelView;
@property (nonatomic, strong) BaseCode *selectedBasecode;
@end
@implementation CPResumeWorkExperienceIndustryCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 0, self.viewWidth - ( 40 + 70 + 35 ) / CP_GLOBALSCALE, 144 / CP_GLOBALSCALE)];
        self.labelTitle.textColor = [UIColor colorWithHexString:@"404040"];
        self.labelTitle.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        self.imageViewArrow = [[UIImageView alloc] init];
        self.imageViewArrow.backgroundColor = [UIColor clearColor];
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_down_gray"];
        [self.contentView addSubview:self.imageViewArrow];
        [self.imageViewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.mas_right ).offset( -35 / CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( (144 - 70) / 2.0 / CP_GLOBALSCALE );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.contentView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [self.contentView addSubview:self.secondTabelView];
    }
    return self;
}
+ (instancetype)workExperienceIndustryCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"CPResumeWorkExperienceIndustryCell";
    CPResumeWorkExperienceIndustryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumeWorkExperienceIndustryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configWithTitle:(NSString *)titleStr childArray:(NSMutableArray *)childArray isSelected:(BOOL)isSelected selectedBaseode:(BaseCode *)selectedBaseode
{
    self.selectedBasecode = selectedBaseode;
    if ( 0 < [self.childArray count] )
    {
        [self.childArray removeAllObjects];
    }
    [self.childArray addObjectsFromArray:[childArray copy]];
    _isSeleceted = isSelected;
    [self.labelTitle setText:titleStr];
    if ( _isSeleceted )
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_up_gray"];
        [self.secondTabelView setHidden:NO];
        self.secondTabelView.viewHeight = 144 / CP_GLOBALSCALE * [self.childArray count];
        [self.secondTabelView reloadData];
    }
    else
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_down_gray"];
        [self.secondTabelView setHidden:YES];
        self.secondTabelView.viewHeight = 0;
    }
}
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.childArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144.0 / CP_GLOBALSCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPResumeWorkExperienceSecondIndustryCell *cell = [CPResumeWorkExperienceSecondIndustryCell workExperienceCellWithTableView:tableView];
    BaseCode *region = self.childArray[indexPath.row];
    BOOL isSelected = NO;
    if ( [region.CodeName isEqualToString:self.selectedBasecode.CodeName] )
        isSelected = YES;
    [cell configWithTitle:region.CodeName isSelected:isSelected];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *selectedRegion = self.childArray[indexPath.row];
    if ( [self.workExperienceDelegate respondsToSelector:@selector(workExperienceCell:didSelectedBasecode:)] )
    {
        [self.workExperienceDelegate workExperienceCell:self didSelectedBasecode:selectedRegion];
    }
}
- (UITableView *)secondTabelView
{
    if ( !_secondTabelView )
    {
        _secondTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144 / 3.0, kScreenWidth, 0) style:UITableViewStylePlain];
        _secondTabelView.dataSource = self;
        _secondTabelView.delegate = self;
        [_secondTabelView setBackgroundColor:[UIColor clearColor]];
        [_secondTabelView setHidden:YES];
        [_secondTabelView setScrollEnabled:NO];
        [_secondTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _secondTabelView;
}
- (NSMutableArray *)childArray
{
    if ( !_childArray )
    {
        _childArray = [NSMutableArray array];
    }
    return _childArray;
}@end
