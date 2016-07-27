//
//  BaseViewController+otherUI.m
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseViewController+otherUI.h"


@implementation BaseViewController (otherUI)

-(UIButton *)bottomButtonWithTitle:(NSString *)title
{
    FUIButton *button = [FUIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *maker){
    
        maker.bottom.equalTo(self.view.mas_bottom);
        maker.left.equalTo(self.view.mas_left);
        maker.right.equalTo(self.view.mas_right);
        maker.height.equalTo(@(44));
        
    }];
    
    button.buttonColor = RGBCOLOR(248, 142, 76);
    button.buttonHighlightedColor = UIColorFromRGB(0xe95b3f);

    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}


-(UIButton *)bottomButtonWithTitle:(NSString *)title color:(BottomButtonColor)color
{
    FUILineButton *button = [FUILineButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(10, self.view.viewHeight - 60, self.view.viewWidth - 20, 44);
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    
    switch (color) {
        case BottomButtonColorOrange:
        {
            [button setImage:[UIImage imageNamed:@"btn_orang_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_orang_pressed"] forState:UIControlStateHighlighted];
        }
            break;
        case BottomButtonColorWhite:
        {
            button.buttonColor = [[RTAPPUIHelper shareInstance] backgroundColor];
            button.buttonHighlightedColor = [[RTAPPUIHelper shareInstance] backgroundColor];
            button.buttonBorderColor = [[RTAPPUIHelper shareInstance] lineColor];
            button.buttonBorderWidth = [[RTAPPUIHelper shareInstance] lineWidth];
        }
        default:
            break;
    }
    
    [self.view addSubview:button];
    return button;
}

@end
