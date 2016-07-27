//
//  UIViewController+NavicationUI.h
//  cepin
//
//  Created by Ricky Tang on 14-11-5.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSearchTextField.h"
#import "CPSearchWithRightTextField.h"

typedef enum {
    NavcationBarObjectTypeFilter,
    NavcationBarObjectTypeBooking,
    NavcationBarObjectTypeShare,
    NavcationBarObjectTypeShareAndSave,
    NavcationBarObjectTypeAdd,
    NavcationBarObjectTypeQuestion,
    NavcationBarObjectTypePerson,
    NavcationBarObjectTypeRegister,
    NavcationBarObjectTypeLeft,
    NavcationBarObjectTypeDelete,
    NavcationBarObjectTypeConfirm,
    NavcationBarObjectTypeMore,
    NavcationBarObjectTypeSearch,
    NavcationBarObjectTypeSetting,
    NavcationBarObjectTypeAddExperience,
    NavcationBarObjectTypePreview
} NavcationBarObjectType;

@interface UIViewController (NavicationUI)

-(id)addNavicationObjectWithType:(NavcationBarObjectType)type;

-(UIButton *)addNavicationBarLeftObjectWithImage:(UIImage *)image hightedImage:(UIImage *)hightedImage;


-(UIButton *)addNavicationBarRightObjectWithImage:(UIImage *)image hightedImage:(UIImage *)hightedImage;

-(void)addNavicationCollectionObjectWithImage:(UIButton *)collectionBtn share:(UIButton *)shareBtn;

-(UIButton *)addNavicationBarRightObjectWithTitle:(NSString *)title;


-(CPSearchWithRightTextField *)addNavicationBarCenterSearchBar;

-(UISegmentedControl *)addNavicationBarCenterSegmented;

@end
