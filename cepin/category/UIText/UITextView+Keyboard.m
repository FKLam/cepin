//
//  UITextView+Keyboard.m
//  御品
//
//  Created by 唐 嘉宾 on 13-4-9.
//
//

#import "UITextView+Keyboard.h"

@implementation UITextView (Keyboard)

-(void)setupKeyBoardNoticafition:(BOOL)isSetup
{
    if (isSetup) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}


-(void)keyBoardWillShowOrHide:(NSNotification *)notification
{
    if (![self isFirstResponder]) {
        return;
    }
    
    BOOL isShow = (notification.name == UIKeyboardWillShowNotification) ? YES : NO;
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    CGRect keyboardStartFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardStartFrame];
    
	//superView 是否移动了
    CGRect containerFrame = self.superview.frame;
    CGRect textFieldFrame = self.frame;
    CGFloat originY = 0;
    CGFloat naviBarHeight = 44;
    CGFloat statueBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (containerFrame.origin.y < 0) {
        //superView 移动过就计算textField在原位时是否在keyboard上
        if (self.frame.origin.y > 0) {
            originY = self.frame.origin.y - containerFrame.origin.y;
        }
        else
        {
            originY = -1*(containerFrame.origin.y - self.frame.origin.y);
        }
        
        if (isShow) {
            //如果不在就让superView移动到可以显示textField的地方
            if (keyboardEndFrame.origin.y < (originY + textFieldFrame.size.height + naviBarHeight + statueBarHeight)) {
                NSLog(@"keyboardEndFrame.origin.y ttttt %f",keyboardEndFrame.origin.y);
                NSLog(@"originY + textFieldFrame.size.height %f",originY + textFieldFrame.size.height + naviBarHeight + statueBarHeight);
                if (keyboardEndFrame.origin.y > textFieldFrame.origin.y) {
                    containerFrame.origin.y = -1*((keyboardEndFrame.origin.y - originY) + textFieldFrame.size.height);
                }
                else
                {
                    containerFrame.origin.y = -1*((originY - keyboardEndFrame.origin.y) + textFieldFrame.size.height);
                }
                
            }
            //如果textField在原位时在keyboard上那就让superView回到原位
            else
            {
                containerFrame.origin.y = 0;
            }
        }
        else{
            containerFrame.origin.y = 0;
        }
        
    }
    else{
        if (isShow) {
            //如果不在就让superView移动到可以显示textField的地方
            if (keyboardEndFrame.origin.y < (textFieldFrame.origin.y + textFieldFrame.size.height + naviBarHeight + statueBarHeight)) {
                NSLog(@"keyboardEndFrame.origin.y kkkkk %f",keyboardEndFrame.origin.y);
                
                if (keyboardEndFrame.origin.y > textFieldFrame.origin.y) {
                    containerFrame.origin.y = -1*((keyboardEndFrame.origin.y - textFieldFrame.origin.y) + textFieldFrame.size.height);
                }
                else
                {
                    containerFrame.origin.y = -1*((textFieldFrame.origin.y - keyboardEndFrame.origin.y) + textFieldFrame.size.height);
                }
                
            }
            //如果textField在原位时在keyboard上那就让superView回到原位
            else
            {
                containerFrame.origin.y = 0;
            }
        }
        else{
            containerFrame.origin.y = 0;
        }
    }
    
    
    
	// get a rect for the textView frame
	
    /*if (isShow) {
        containerFrame.origin.y = containerFrame.origin.y - keyboardEndFrame.size.height+(containerFrame.size.height-self.frame.origin.y);
    }
    else{
        containerFrame.origin.y = containerFrame.origin.y + keyboardStartFrame.size.height-(containerFrame.size.height-self.frame.origin.y);
    }*/
    
    //containerFrame.origin.y = self.superview.frame.size.height;
	
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 50 * USEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        // set views with new info
        self.superview.frame = containerFrame;
        
        // commit animations
        [UIView commitAnimations];
    });
}


static char blockKey;
static char blockSegmented;

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
    //prevNext.segmentedControlStyle = UISegmentedControlStyleBar;
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
        block(seg,(int)seg.selectedSegmentIndex);
    }
}
@end
