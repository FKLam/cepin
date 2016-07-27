//
//  UITextField+Keyboard.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-24.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "UITextField+Keyboard.h"
#import <objc/runtime.h>

static char blockKey;
static char blockSegmented;

@implementation UITextField (Keyboard)


-(void)setupCancelActionBarWithBlock:(void(^)(UIBarButtonItem *item))block
{
    UIToolbar *actionBar = [[UIToolbar alloc] init];
    actionBar.translucent = YES;
    [actionBar sizeToFit];
    actionBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickedCancel:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [actionBar setItems:[NSArray arrayWithObjects:flexible, doneButton, nil]];
    
    if (block) {
        objc_setAssociatedObject(self, &blockKey, block, OBJC_ASSOCIATION_COPY);
    }
    
    self.inputAccessoryView = actionBar;
}

-(void)clickedCancel:(id)sender
{
    void(^block)(id item) = objc_getAssociatedObject(self, &blockKey);
    
    [self resignFirstResponder];
    if (block) {
        block(sender);
    }
}

-(void)setupDoneActionBarWithBlock:(void(^)(UIBarButtonItem *item))block
{
    UIToolbar *actionBar = [[UIToolbar alloc] init];
    actionBar.translucent = YES;
    [actionBar sizeToFit];
    actionBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickedCancel:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [actionBar setItems:[NSArray arrayWithObjects:flexible, doneButton, nil]];
    
    if (block) {
        objc_setAssociatedObject(self, &blockKey, block, OBJC_ASSOCIATION_COPY);
    }
    
    self.inputAccessoryView = actionBar;
}


-(void)setupDoneActionBarWithTitle:(NSString *)title block:(void (^)(UIBarButtonItem *))block
{
    UIToolbar *actionBar = [[UIToolbar alloc] init];
    actionBar.translucent = YES;
    [actionBar sizeToFit];
    actionBar.barStyle = UIBarStyleBlackTranslucent;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 35)];
    lable.text = title;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:15];
    lable.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:lable];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickedCancel:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [actionBar setItems:[NSArray arrayWithObjects:titleItem,flexible, doneButton, nil]];
    
    if (block) {
        objc_setAssociatedObject(self, &blockKey, block, OBJC_ASSOCIATION_COPY);
    }
    
    self.inputAccessoryView = actionBar;
}


-(void)setupNextAndPreviousWithBlock:(void(^)(UISegmentedControl *Segmented , NextAndPreviousType index))SegmentedBlock cancel:(void(^)(id sender))block
{
    UIToolbar *actionBar = [[UIToolbar alloc] init];
    actionBar.translucent = YES;
    [actionBar sizeToFit];
    actionBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", @"")
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(clickedCancel:)];
    
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UISegmentedControl* prevNext = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"前一项", @""), NSLocalizedString(@"下一项", @""), nil]];
    
    prevNext.momentary = YES;
    prevNext.segmentedControlStyle = UISegmentedControlStyleBar;
    prevNext.tintColor = actionBar.tintColor;
    [prevNext addTarget:self action:@selector(segmentedChange:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *prevNextWrapper = [[UIBarButtonItem alloc] initWithCustomView:prevNext];
    
    [actionBar setItems:@[prevNextWrapper, flexible, doneButton]];
    
    if (block) {
        objc_setAssociatedObject(self, &blockKey, block, OBJC_ASSOCIATION_COPY);
    }
    
    if (SegmentedBlock) {
        objc_setAssociatedObject(self, &blockSegmented, SegmentedBlock, OBJC_ASSOCIATION_COPY);
    }
    
    self.inputAccessoryView = actionBar;
}


-(void)segmentedChange:(id)sender
{
    void(^block)(UISegmentedControl *Segmented , NextAndPreviousType index) = objc_getAssociatedObject(self, &blockSegmented);
    
    [self resignFirstResponder];
    
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    
    if (block) {
        block(seg,seg.selectedSegmentIndex);
    }
}

@end
