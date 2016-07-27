//
//  UIViewController+NavicationUI.m
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UIViewController+NavicationUI.h"
#import "TKRoundedView.h"
#import "FUISegmentedControl.h"
#import "CPCommon.h"
@interface CPWNavigationButton : UIButton

@end
@implementation CPWNavigationButton
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
@implementation UIViewController (NavicationUI)

-(id)addNavicationObjectWithType:(NavcationBarObjectType)type
{
    switch (type) {
        case NavcationBarObjectTypeFilter:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"ic_filter"] hightedImage:nil];
        }
            break;
        case NavcationBarObjectTypeBooking:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"condition"] hightedImage:nil];
        }
            break;
        case NavcationBarObjectTypeShare:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"ic_share"] hightedImage:nil];
        }
            break;
        case NavcationBarObjectTypeAdd:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"ic_addresume"] hightedImage:nil];
        }
            break;
        case NavcationBarObjectTypeQuestion:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"question_icon"] hightedImage:nil];
        }
            break;
        case NavcationBarObjectTypeRegister:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"tb_spinner_border_bg.9"] hightedImage:nil];
        }
            break;
        case NavcationBarObjectTypePerson:
        {
            return [self addNavicationBarLeftObjectWithImage:[UIImage imageNamed:@"ic_menu"] hightedImage:nil];
        }
        case NavcationBarObjectTypeLeft:
        {
            return [self addNavicationBarLeftObjectWithImage:[UIImage imageNamed:@"filter_ic_back"] hightedImage:nil];
        }
        case NavcationBarObjectTypeDelete:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"tb_del_icon"] hightedImage:nil];
        }
        case NavcationBarObjectTypeConfirm:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"ic_confirm"] hightedImage:nil];
        }
        case NavcationBarObjectTypeMore:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"ic_more"] hightedImage:nil];
        }
        case NavcationBarObjectTypeSearch:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"ic_search"] hightedImage:nil];
        }
        case NavcationBarObjectTypeSetting:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"center_ic_setting_white"] hightedImage:nil];
        }
            break;
        case NavcationBarObjectTypeAddExperience:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"ic_add_white" ] hightedImage:nil];
        }
            break;
        case NavcationBarObjectTypePreview:
        {
            return [self addNavicationBarRightObjectWithImage:[UIImage imageNamed:@"ic_preview"] hightedImage:nil];
        }
            break;
        default:
            break;
    }
    return nil;
}

-(void)addNavicationCollectionObjectWithImage:(UIButton *)collectionBtn share:(UIButton *)shareBtn
{
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:collectionBtn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
  
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: item1,item2,nil]];
}

-(UIButton *)addNavicationBarLeftObjectWithImage:(UIImage *)image hightedImage:(UIImage *)hightedImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:hightedImage forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, self.navigationController.navigationBar.center.y+ 84 / 6.0, 84 / 3.0, 84 / 3.0);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = item;
    
    return btn;
}

-(UIButton *)addNavicationBarRightObjectWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(self.view.viewSize.width-50-5, self.navigationController.navigationBar.center.y+25/2, 50, 25);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = item;
    
    return btn;
}
-(UIButton *)addNavicationBarRightObjectWithImage:(UIImage *)image hightedImage:(UIImage *)hightedImage
{
    int hight = 70.0 / CP_GLOBALSCALE;
    CPWNavigationButton *btn = [CPWNavigationButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:hightedImage forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, self.navigationController.navigationBar.center.y+hight/2, hight, hight);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    return btn;
}
- (CPSearchWithRightTextField *)addNavicationBarCenterSearchBar
{
    CGFloat tempScale = 3.0;
    CPSearchWithRightTextField *text = [[CPSearchWithRightTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth - 40 / tempScale * 2, 90 / tempScale)];
    UIView *imageBackView = [[UIView alloc] init];
    [imageBackView setBackgroundColor:[UIColor redColor]];
    UIImageView *customLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_ic_search"]];
    CGFloat leftW = customLeftView.image.size.width / tempScale;
    CGFloat leftH = customLeftView.image.size.height / tempScale;
    customLeftView.frame = CGRectMake(0.0, ( 90 - 48 ) / tempScale / 2.0, leftW, leftH);
    [imageBackView addSubview:customLeftView];
    text.leftView = imageBackView;
    text.leftView.backgroundColor = [UIColor clearColor];
    text.leftViewMode = UITextFieldViewModeAlways;
    text.layer.cornerRadius = 90 / tempScale / 2.0;
    text.layer.masksToBounds = YES;
    text.rightViewMode = UITextFieldViewModeWhileEditing;
    text.font = [UIFont systemFontOfSize:36 / ( 3.0 * ( 1 / 1.29 ) )];
    text.textColor = [UIColor colorWithHexString:@"404040"];
    text.background = [[UIImage imageNamed:@"search_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.navigationItem.titleView = text;
    return text;
}
-(UISegmentedControl *)addNavicationBarCenterSegmented
{
    FUISegmentedControl *seg = [[FUISegmentedControl alloc]initWithItems:@[@"工作订阅",@"宣讲会"]];
    seg.selectedColor = [UIColor whiteColor];
    seg.deselectedColor = UIColorFromRGB(0x1d80dd);
    seg.selectedFontColor = UIColorFromRGB(0x74b0e7);
    seg.deselectedFontColor = UIColorFromRGB(0x74b0e7);
    seg.frame = CGRectMake(0, 0, 150, 30);
    self.navigationItem.titleView = seg;
    return seg;
}
@end
