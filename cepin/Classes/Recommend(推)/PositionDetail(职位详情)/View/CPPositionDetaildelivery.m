//
//  CPPositionDetaildelivery.m
//  cepin
//
//  Created by ceping on 16/3/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionDetaildelivery.h"
#import "CPDeliveryResumeCell.h"
#import "CPCommon.h"
@interface CPPositionDetaildelivery ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *resumeName;
@property (nonatomic, strong) UILabel *resumeState;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) UIButton *deliveryButton;
@property (nonatomic, strong) NSMutableArray *resumeArrayM;
@property (nonatomic, strong) ResumeNameModel *selectedResume;
@property (nonatomic, strong) NSIndexPath *selectedIndexPatch;
@end
@implementation CPPositionDetaildelivery
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.selectedIndexPatch = [NSIndexPath indexPathForRow:0 inSection:0];
        [self setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat H = ( 60 + 60 + 155 + 2 + 144 + 144 ) / CP_GLOBALSCALE;
        CGFloat X = 40 / CP_GLOBALSCALE;
        CGFloat Y = ( kScreenHeight - H ) / 2.0;
        UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [tipsView.layer setMasksToBounds:YES];
        [self addSubview:tipsView];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( tipsView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( tipsView.mas_left );
            make.height.equalTo( @( 60 / CP_GLOBALSCALE ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        [tipsView addSubview:self.contentTableView];
        [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.titleLabel.mas_bottom ).offset( 11 / CP_GLOBALSCALE );
            make.left.equalTo( tipsView.mas_left ).offset( 80 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE * 2 ) );
            make.right.equalTo( tipsView.mas_right ).offset( -80 / CP_GLOBALSCALE );
        }];
        [tipsView addSubview:self.separatorLine];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
            make.right.equalTo( tipsView.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [tipsView addSubview:self.deliveryButton];
        [self.deliveryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.right.equalTo( tipsView.mas_right );
            make.top.equalTo( self.separatorLine.mas_bottom );
        }];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ( [self.positionDetailDeliveryViewDelegate respondsToSelector:@selector(positionDetailDeliveryViewTouchFreeArea)] )
    {
        [self.positionDetailDeliveryViewDelegate positionDetailDeliveryViewTouchFreeArea];
    }
}
#pragma mark - UITableViewDatasource - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resumeArrayM count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPDeliveryResumeCell *cell = [CPDeliveryResumeCell deliveryRsumeCellWithTableView:tableView];
    ResumeNameModel *resume = self.resumeArrayM[indexPath.row];
    BOOL isSelecetd = NO;
    if ( self.selectedIndexPatch.row == indexPath.row )
        isSelecetd = YES;
    [cell configDeliveryCellWithResume:resume isSelected:isSelecetd];
    BOOL isHide = NO;
    if ( indexPath.row == [self.resumeArrayM count] - 1 )
        isHide = YES;
    [cell hideSeparatorIsHide:isHide];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedResume = self.resumeArrayM[indexPath.row];
    NSIndexPath *tempIndexPath = [self.selectedIndexPatch copy];
    self.selectedIndexPatch = indexPath;
    [tableView reloadRowsAtIndexPaths:@[tempIndexPath, self.selectedIndexPatch] withRowAnimation:UITableViewRowAnimationFade];
    [self changeButtonTitile];
}
- (void)configWithArray:(NSArray *)resumeArray
{
    [self.resumeArrayM removeAllObjects];
    [self.resumeArrayM addObjectsFromArray:resumeArray];
    [self.contentTableView reloadData];
    if ( 0 < [self.resumeArrayM count] )
        self.selectedResume = self.resumeArrayM[0];
    [self changeButtonTitile];
}
- (void)changeButtonTitile
{
    NSString *buttonTitle = @"确定";
    if ( [self.selectedResume.IsCompleteResume intValue] != 1 )
    {
        buttonTitle = @"请完善简历后投递";
        [self.deliveryButton setTitleColor:[UIColor colorWithHexString:@"ff5252"] forState:UIControlStateNormal];
    }
    else
    {
        [self.deliveryButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
    }
    [self.deliveryButton setTitle:buttonTitle forState:UIControlStateNormal];
}
#pragma mark - getter methods
- (UITableView *)contentTableView
{
    if ( !_contentTableView )
    {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_contentTableView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_contentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_contentTableView setDataSource:self];
        [_contentTableView setDelegate:self];
        [_contentTableView setShowsVerticalScrollIndicator:NO];
    }
    return _contentTableView;
}
- (UIButton *)deliveryButton
{
    if ( !_deliveryButton )
    {
        _deliveryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deliveryButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_deliveryButton setTitle:@"确定" forState:UIControlStateNormal];
        [_deliveryButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_deliveryButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( [self.positionDetailDeliveryViewDelegate respondsToSelector:@selector(positionDetailDeliveryView:selectedResume:)] )
            {
                [self.positionDetailDeliveryViewDelegate positionDetailDeliveryView:self selectedResume:self.selectedResume];
            }
        }];
    }
    return _deliveryButton;
}
- (NSMutableArray *)resumeArrayM
{
    if ( !_resumeArrayM )
    {
        _resumeArrayM = [NSMutableArray array];
    }
    return _resumeArrayM;
}
- (UILabel *)titleLabel
{
    if ( !_titleLabel )
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"选择简历"];
        [_titleLabel setFont:[UIFont systemFontOfSize:60 / CP_GLOBALSCALE]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"选择简历"]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}
- (UILabel *)resumeName
{
    if ( !_resumeName )
    {
        _resumeName = [[UILabel alloc] init];
        [_resumeName setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
    }
    return _resumeName;
}
- (UILabel *)resumeState
{
    if ( !_resumeState )
    {
        _resumeState = [[UILabel alloc] init];
        [_resumeState setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    }
    return _resumeState;
}
- (UIView *)separatorLine
{
    if ( !_separatorLine )
    {
        _separatorLine = [[UIView alloc] init];
        [_separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    }
    return _separatorLine;
}
@end
