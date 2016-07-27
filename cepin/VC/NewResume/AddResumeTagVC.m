//
//  AddResumeTagVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddResumeTagVC.h"
#import "UIViewController+NavicationUI.h"
#import "AOTag.h"
#import "AddResumeTagVM.h"
@interface AddResumeTagVC ()<UITextFieldDelegate,AOTagDelegate>
@property(nonatomic,strong) AddResumeTagVM *viewModel;
@property(nonatomic,strong) AOTagList *tagListView;
@property(nonatomic,strong)UITextField *tagFieldText;
@property(nonatomic,strong)UIButton *addButton;
@property(nonatomic,strong)NSString *TagStr;
@property(nonatomic,strong)NSMutableArray *TagArray;
@end

@implementation AddResumeTagVC

- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.TagArray = [NSMutableArray new];
        self.viewModel = [[AddResumeTagVM alloc]initWithResumeModel:model];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"简历关键字";
    
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.tagFieldText resignFirstResponder];
        //保存标签
        [self.viewModel addResumeTag];
    }];
    
    UIView *shade = [[UIView alloc]initWithFrame:CGRectMake(0, IsIOS7?64:44, self.view.viewWidth, IS_IPHONE_5?18:21)];
    shade.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
    [self.view addSubview:shade];
    
    UIView *whithView = [[UIView alloc]initWithFrame:CGRectMake(0, shade.viewHeight + shade.viewY, self.view.viewWidth, 300)];
    
    whithView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whithView];
    self.tagFieldText = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 200, 40)];
    self.tagFieldText.placeholder = @"输入自创标签";
    self.tagFieldText.delegate = self;
    self.tagFieldText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tagFieldText.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.tagFieldText.font = [[RTAPPUIHelper shareInstance]titleFont];
    [whithView addSubview:self.tagFieldText];
//    self.tagFieldText.
    [[self.tagFieldText rac_textSignal]subscribeNext:^(NSString *text) {
        if (text.length>0) {
            self.TagStr = text;
        }
        
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
    [whithView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.tagFieldText.mas_right);
        make.top.equalTo(self.tagFieldText.mas_bottom).offset(-1);
        make.height.equalTo(@(1));
    }];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = CGRectMake(self.tagFieldText.viewX + self.tagFieldText.viewWidth, self.tagFieldText.viewY + 5, 80, IS_IPHONE_5?30:40);
    self.addButton.backgroundColor = [[RTAPPUIHelper shareInstance]labelColorGreen];
    self.addButton.layer.cornerRadius = 8;
    self.addButton.layer.masksToBounds = YES;
    [self.addButton setTitle:@"添加标签" forState:UIControlStateNormal];
    self.addButton.titleLabel.font = [[RTAPPUIHelper shareInstance] titleFont];
    [whithView addSubview:self.addButton];
    
    [self.addButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self textReturn];
        if (!self.TagStr || [self.TagStr isEqualToString:@""]) {
            [OMGToast showWithText:@"标签不能为空" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            return;
        }
        if (self.viewModel.tagArray.count >9) {
            [OMGToast showWithText:@"标签个数不能超过10个" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            return;
        }
        if (self.TagStr.length > 12) {
            [OMGToast showWithText:@"标签字数不能超过12个" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            return;

        }
        [self.tagListView addTag:self.TagStr withImage:nil withLabelColor:[UIColor whiteColor]  withBackgroundColor:[[RTAPPUIHelper shareInstance] labelColorGreen] withCloseButtonColor:[UIColor whiteColor]];

        [self.viewModel.tagArray addObject:self.TagStr];
        self.TagStr = @"";
        self.tagFieldText.text = @"";
    }];
    
    self.tagListView = [[AOTagList alloc]init];
    [self.tagListView setDelegate:self];
    [whithView addSubview:self.tagListView];
    [self.tagListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(20);
        make.top.equalTo(self.tagFieldText.mas_bottom).offset(10);
        make.height.equalTo(@(200));
    }];
    
    [self.tagListView removeAllTag];
    for (NSInteger i = 0; i < self.viewModel.tagArray.count; i++)
    {
           [self.tagListView addTag:self.viewModel.tagArray[i] withImage:nil withLabelColor:[UIColor whiteColor]  withBackgroundColor:[[RTAPPUIHelper shareInstance] labelColorGreen] withCloseButtonColor:[UIColor whiteColor]];
    }
    
    
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)tagDidRemoveTag:(AOTag *)tag
{
    [self.viewModel.tagArray removeObject:tag.tTitle];

}

//- (void)tagListReflashHeight:(CGFloat)height listView:(AOTagList *)view
//{
//    RTLog(@"%@",view);
//}
- (void)textReturn
{
    [self.tagFieldText resignFirstResponder];
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
