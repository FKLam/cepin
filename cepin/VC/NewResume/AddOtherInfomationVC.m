//
//  AddOtherInfomationVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddOtherInfomationVC.h"
#import "AddOtherInfomationVM.h"
#import "UIViewController+NavicationUI.h"
#import "CPPositionDetailDescribeLabel.h"
#import "RTPhotoHelper.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "CPResumeAdditionalImageButton.h"
#import "CPCommon.h"
#import "CPTipsView.h"
@interface AddOtherInfomationVC ()<UITextViewDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate, UINavigationControllerDelegate, CPResumeAdditionalImageButtonDelegate, CPTipsViewDelegate>
@property (nonatomic, strong) UITextView *describeText;
@property (nonatomic, strong) AddOtherInfomationVM *viewModel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *tipsLabel;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIView *imagesBackgroundView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *AdditionalImageArrayM;
@property (nonatomic, strong) NSMutableArray *additionalImageNameM;
@property (nonatomic, strong) NSMutableArray *attachmentDictArrayM;
@property (nonatomic, assign) NSInteger selectTag;
@property (nonatomic, strong) CPTipsView *tipsView;
@end
#define CP_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define CPAdditionalImageWH ((kScreenWidth - 40 / CP_GLOBALSCALE * 5) / 4.0)
#define CPAdditionalImageMager (40 / CP_GLOBALSCALE)
@implementation AddOtherInfomationVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[AddOtherInfomationVM alloc] initWithResumeModel:model];
        NSMutableArray *dict = model.ResumeAttachmentList;
        if ( 0 < [dict count] )
        {
            [self.attachmentDictArrayM addObjectsFromArray:dict];
        }
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附加信息";
    self.selectTag = -1;
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.describeText resignFirstResponder];
        [self.viewModel saveInfo];
        [MobClick event:@"edit_addition"];
    }];
    self.view = self.contentScrollView;
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, (IsIOS7)?44+30:44 + (IS_IPHONE_5?18:21), kScreenWidth, 495 / CP_GLOBALSCALE + 30.0)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    self.describeText = [[UITextView alloc] initWithFrame:CGRectMake(40 / CP_GLOBALSCALE - 4.0, 0, 300, 495 / CP_GLOBALSCALE)];
    self.describeText.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.describeText.textColor = [UIColor colorWithHexString:@"404040"];
    self.describeText.backgroundColor = [UIColor whiteColor];
    self.describeText.delegate = self;
    self.describeText.text = self.viewModel.resumeModel.AdditionInfo;
    [[self.describeText rac_textSignal] subscribeNext:^(NSString *text) {
        self.viewModel.resumeModel.AdditionInfo = text;
    }];
    [back addSubview:self.describeText];
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
          
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [RACObserve(self.viewModel, updateImageStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self resetImageBackgroundWithImage];
        }
    }];
    [RACObserve(self.viewModel, deleteAttachmentStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.attachmentDictArrayM removeObjectAtIndex:self.selectTag];
            for ( id obj in self.AdditionalImageArrayM )
            {
                [obj removeFromSuperview];
            }
            [self.AdditionalImageArrayM removeAllObjects];
            [self setupImageBackground];
//            [self.AdditionalImageArrayM removeObjectAtIndex:self.selectTag];
//            [self.additionalImageNameM removeObjectAtIndex:self.selectTag];
//            [self resetAfterDelImageBackground];
            self.selectTag = -1;
        }
    }];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"你可以添加证书信息或你觉得有意思的经历（最多500字）";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"9d9d9d"];
    self.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.titleLabel setNumberOfLines:0];
    [back addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( back.mas_top ).offset( 20 / CP_GLOBALSCALE );
        make.left.equalTo( back.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo( back.mas_right ).offset( -20 / CP_GLOBALSCALE );
    }];
    self.titleLabel.hidden = YES;
    if (!self.viewModel.resumeModel.AdditionInfo || [self.viewModel.resumeModel.AdditionInfo isEqualToString:@""]) {
        self.titleLabel.hidden = NO;
    }
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    countLabel.textColor = [UIColor colorWithHexString:@"9d9d9d"];
    countLabel.font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
    [back addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(back.mas_bottom).offset(-10);
        make.right.equalTo(back.mas_right).offset(-20);
    }];
    UIView *separatorLine = [[UIView alloc] init];
    [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
    [back addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( back.mas_left );
        make.bottom.equalTo( back.mas_bottom );
        make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        make.right.equalTo( back.mas_right );
    }];
    [[self.describeText rac_textSignal] subscribeNext:^(NSString *text) {
        if ( 0 == [text length] )
            [self.titleLabel setHidden:NO];
        else
            [self.titleLabel setHidden:YES];
        if (text) {
            NSInteger len = 500 - text.length;
            if( len < 0 ){
                self.describeText.text = [self.describeText.text substringToIndex:500];
                NSString *des = [NSString stringWithFormat:@"您还可以输入0个字符"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
                //设置：在0-3个单位长度内的内容显示成红色
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, 1)];
                countLabel.attributedText = str;
                self.viewModel.resumeModel.AdditionInfo = [text substringToIndex:500];
                return ;
            }
            NSString *des = [NSString stringWithFormat:@"您还可以输入%ld个字符",(long)len];
            NSString *lenStr = [NSString stringWithFormat:@"%ld",len];
            NSInteger end = lenStr.length;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
            //设置：在0-3个单位长度内的内容显示成红色
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, end)];
            countLabel.attributedText = str;
            self.viewModel.resumeModel.AdditionInfo = text;
        }
    }];
    UIView *whiteBackgroundView = [[UIView alloc] init];
    [whiteBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.contentScrollView addSubview:whiteBackgroundView];
    self.whiteBackgroundView = whiteBackgroundView;
    [whiteBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( back.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left );
        make.height.equalTo( @( kScreenHeight - (32 + 495 + 30) / CP_GLOBALSCALE) );
        make.width.equalTo( @( kScreenWidth ) );
    }];
    CGFloat imagesBackgroundH = 0.0;
    [self.whiteBackgroundView addSubview:self.imagesBackgroundView];
    [self.imagesBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( whiteBackgroundView.mas_top ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( whiteBackgroundView.mas_left );
        make.right.equalTo( whiteBackgroundView.mas_right );
        make.height.equalTo( @( imagesBackgroundH ) );
    }];
    [whiteBackgroundView addSubview:self.uploadButton];
    [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.imagesBackgroundView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( whiteBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo( whiteBackgroundView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
    [whiteBackgroundView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.uploadButton.mas_bottom ).offset( 30 / CP_GLOBALSCALE );
        make.left.equalTo( self.uploadButton.mas_left );
        make.right.equalTo( self.uploadButton.mas_right );
    }];
    [self setupImageBackground];
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.describeText setInputAccessoryView:topView];
}
//关闭键盘
-(void) dismissKeyBoard
{
    [self.describeText resignFirstResponder];
}
- (void)resetAfterDelImageBackground
{
    NSInteger tag = 0;
    for ( CPResumeAdditionalImageButton *imageView in self.AdditionalImageArrayM )
    {
        [imageView setTag:tag];
        [imageView.clickButton setTag:tag];
        [imageView.clickButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeAdditionalImageButton *sender) {
            [sender setSelected:YES];
            [self aletDeleteImageWithTag:sender.tag];
        }];
        CGFloat imageViewHeight = CPAdditionalImageWH + ( 20 + 30 + 20 + 30 ) / CP_GLOBALSCALE;
        [self.imagesBackgroundView addSubview:imageView];
        if ( 0 < tag )
        {
            UIImageView *imageViewTemp = [self.AdditionalImageArrayM lastObject];
            if ( 4 <= tag )
            {
                CGFloat x = CGRectGetMaxX(imageViewTemp.frame) + 40 / CP_GLOBALSCALE;
                if ( kScreenWidth <= x )
                    x = 40 / CP_GLOBALSCALE;
                CGFloat y = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
                [imageView setFrame:CGRectMake(x, y, CPAdditionalImageWH, imageViewHeight)];
            }
            else
            {
                [imageView setFrame:CGRectMake(CGRectGetMaxX(imageViewTemp.frame) + 40 / CP_GLOBALSCALE, 0, CPAdditionalImageWH, imageViewHeight)];
            }
        }
        else
        {
            [imageView setFrame:CGRectMake(CPAdditionalImageMager, 0, CPAdditionalImageWH, imageViewHeight)];
        }
        CGFloat height = 0;
        if ( 4 <= tag )
        {
            height = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE;
            height += CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
        }
        else
        {
            height = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE;
        }
        [self.imagesBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.whiteBackgroundView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.whiteBackgroundView.mas_left );
            make.right.equalTo( self.whiteBackgroundView.mas_right );
            make.height.equalTo( @( height ) );
        }];
        tag++;
    }
}
- (void)setupImageBackground
{
    if ( 0 == [self.attachmentDictArrayM count] )
    {
        [self.imagesBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.whiteBackgroundView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.whiteBackgroundView.mas_left );
            make.right.equalTo( self.whiteBackgroundView.mas_right );
            make.height.equalTo( @( 0.0 ) );
        }];
        return;
    }
    for ( NSDictionary *dict in self.attachmentDictArrayM )
    {
        NSInteger tag = [self.AdditionalImageArrayM count];
        CPResumeAdditionalImageButton *imageView = [[CPResumeAdditionalImageButton alloc] initWithFrame:CGRectZero];
        [imageView configWithAttachment:dict];
        [imageView setTag:tag];
        [imageView.clickButton setTag:tag];
        [imageView.clickButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeAdditionalImageButton *sender) {
            [sender setSelected:YES];
            [self aletDeleteImageWithTag:sender.tag];
        }];
        CGFloat imageViewHeight = CPAdditionalImageWH + ( 20 + 30 + 20 + 30 ) / CP_GLOBALSCALE;
        [self.imagesBackgroundView addSubview:imageView];
        if ( 0 < tag )
        {
            UIImageView *imageViewTemp = [self.AdditionalImageArrayM lastObject];
            if ( 4 <= tag )
            {
                CGFloat x = CGRectGetMaxX(imageViewTemp.frame) + 40 / CP_GLOBALSCALE;
                if ( kScreenWidth <= x )
                    x = 40 / CP_GLOBALSCALE;
                else
                    x = 40 / CP_GLOBALSCALE;
                CGFloat y = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
                [imageView setFrame:CGRectMake(x, y, CPAdditionalImageWH, imageViewHeight)];
            }
            else
            {
                [imageView setFrame:CGRectMake(CGRectGetMaxX(imageViewTemp.frame) + 40 / CP_GLOBALSCALE, 0, CPAdditionalImageWH, imageViewHeight)];
            }
        }
        else
        {
            [imageView setFrame:CGRectMake(CPAdditionalImageMager, 0, CPAdditionalImageWH, imageViewHeight)];
        }
        CGFloat height = 0;
        if ( 4 <= tag )
        {
            height = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE;
            height += CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
        }
        else
        {
            height = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE;
        }
        [self.imagesBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.whiteBackgroundView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( self.whiteBackgroundView.mas_left );
            make.right.equalTo( self.whiteBackgroundView.mas_right );
            make.height.equalTo( @( height ) );
        }];
        [self.AdditionalImageArrayM addObject:imageView];
    }
}
- (void)resetImageBackgroundWithImage
{
    NSInteger tag = [self.AdditionalImageArrayM count];
    CPResumeAdditionalImageButton *imageView = [[CPResumeAdditionalImageButton alloc] initWithFrame:CGRectZero];
    NSDictionary *dict = [self.viewModel.attachmentArrayM lastObject];
    [self.attachmentDictArrayM addObject:dict];
    [imageView configWithAttachment:dict];
    [imageView setTag:tag];
    [imageView.clickButton setTag:tag];
    [imageView.clickButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeAdditionalImageButton *sender) {
        [sender setSelected:YES];
        [self aletDeleteImageWithTag:sender.tag];
    }];
    CGFloat imageViewHeight = CPAdditionalImageWH + ( 20 + 30 + 20 + 30 ) / CP_GLOBALSCALE;
    [self.imagesBackgroundView addSubview:imageView];
    if ( 0 < tag )
    {
        UIImageView *imageViewTemp = [self.AdditionalImageArrayM lastObject];
        if ( 4 <= tag )
        {
            CGFloat x = CGRectGetMaxX(imageViewTemp.frame) + 40 / CP_GLOBALSCALE;
            if ( kScreenWidth <= x )
                x = 40 / CP_GLOBALSCALE;
            CGFloat y = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
            [imageView setFrame:CGRectMake(x, y, CPAdditionalImageWH, imageViewHeight)];
        }
        else
        {
            [imageView setFrame:CGRectMake(CGRectGetMaxX(imageViewTemp.frame) + 40 / CP_GLOBALSCALE, 0, CPAdditionalImageWH, imageViewHeight)];
        }
        [[UIScreen mainScreen] scale];
    }
    else
    {
        [imageView setFrame:CGRectMake(CPAdditionalImageMager, 0, CPAdditionalImageWH, imageViewHeight)];
    }
    CGFloat height = 0;
    if ( 4 <= tag )
    {
        height = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE;
        height += CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    }
    else
    {
        height = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE;
    }
    [self.imagesBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.whiteBackgroundView.mas_top ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.whiteBackgroundView.mas_left );
        make.right.equalTo( self.whiteBackgroundView.mas_right );
        make.height.equalTo( @( height ) );
    }];
    [self.AdditionalImageArrayM addObject:imageView];
}
- (void)resetImageBackgroundWithImage:(UIImage *)image imageName:(NSString *)imageName
{
    NSInteger tag = [self.AdditionalImageArrayM count];
    CPResumeAdditionalImageButton *imageView = [[CPResumeAdditionalImageButton alloc] initWithFrame:CGRectZero];
    [imageView configWithImage:image imageName:imageName];
    [imageView setTag:tag];
    [imageView.clickButton setTag:tag];
    [imageView.clickButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeAdditionalImageButton *sender) {
        [sender setSelected:YES];
        [self aletDeleteImageWithTag:sender.tag];
    }];
    [imageView setResumeAdditionalImageButtonDelegate:self];
    CGFloat imageViewHeight = CPAdditionalImageWH + ( 20 + 30 + 20 + 30 ) / CP_GLOBALSCALE;
    [self.imagesBackgroundView addSubview:imageView];
    if ( 0 < tag )
    {
        UIImageView *imageViewTemp = [self.AdditionalImageArrayM lastObject];
        if ( 4 <= tag )
        {
            CGFloat x = CGRectGetMaxX(imageViewTemp.frame) + 40 / CP_GLOBALSCALE;
            if ( kScreenWidth <= x )
                x = 40 / CP_GLOBALSCALE;
            else
                x = 40 / CP_GLOBALSCALE;
            CGFloat y = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
            [imageView setFrame:CGRectMake(x, y, CPAdditionalImageWH, imageViewHeight)];
        }
        else
        {
            [imageView setFrame:CGRectMake(CGRectGetMaxX(imageViewTemp.frame) + 40 / CP_GLOBALSCALE, 0, CPAdditionalImageWH, imageViewHeight)];
        }
    }
    else
    {
        [imageView setFrame:CGRectMake(CPAdditionalImageMager, 0, CPAdditionalImageWH, imageViewHeight)];
    }
    CGFloat height = 0;
    if ( 4 <= tag )
    {
        height = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE;
        height += CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    }
    else
    {
        height = CPAdditionalImageWH + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE + 30 / CP_GLOBALSCALE;
    }
    [self.imagesBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.whiteBackgroundView.mas_top ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( self.whiteBackgroundView.mas_left );
        make.right.equalTo( self.whiteBackgroundView.mas_right );
        make.height.equalTo( @( height ) );
    }];
    [self.AdditionalImageArrayM addObject:imageView];
}
- (void)aletDeleteImageWithTag:(NSInteger)tag
{
    self.selectTag = tag;
    if ( CP_SYSTEM_VERSION >= 8.0 )
    {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除选择的附件" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *dict = [self.attachmentDictArrayM objectAtIndex:tag];
            NSNumber *attachmentID =[dict objectForKey:@"Id"];
            [self.viewModel deleteAttachment:attachmentID];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.selectTag = -1;
        }];
        [alertCtrl addAction:cancelAction];
        [alertCtrl addAction:okAction];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:@"附件最多上传5个" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [alerView show];
    }
}
- (void)uploadImage
{
    // 从相册中选取
    if ([RTPhotoHelper isPhotoLibraryAvailable])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        controller.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWithBlock:^(id sender){
            [controller dismissViewControllerAnimated:YES completion:^(void){
                
            }];
        }];
        controller.title = NSLocalizedString(@"相簿", nil);
        controller.navigationItem.leftBarButtonItem.tintColor = [[RTAPPUIHelper shareInstance] backgroundColor];
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             RTLog(@"Picker View Controller is presented");
                         }];
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( [navigationController isKindOfClass:[UIImagePickerController class]] )
    {
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:46 / CP_GLOBALSCALE]}];
    }
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        __block NSString *imageFileName;
        __block long long realSize = 0.0;
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            realSize = [representation size];
            if ( realSize / ( 1000.0 * 1000.0 ) >= 5.0 )
            {
                [self showMessageTips:@"请选择5M以内大小的图片"];
            }
            else
            {
                imageFileName = [representation filename];
                [self.additionalImageNameM addObject:imageFileName];
                NSString *imageName = [self.additionalImageNameM lastObject];
                [self uploadImageProgressWithImage:portraitImg imageName:imageName];
            }
        };
        ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    UIGraphicsEndImageContext();
    return newImage;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    self.titleLabel.hidden = YES;
    return YES;
}
- (void)uploadImageProgressWithImage:(UIImage *)image imageName:(NSString *)imageName
{
    [self resetImageBackgroundWithImage:image imageName:imageName];
    CPResumeAdditionalImageButton *imageView = [self.AdditionalImageArrayM lastObject];
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strUserTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    //得到图片的data
    NSDictionary *dataToPost = @{ @"tokenId" : strUserTocken, @"userId" : strUser , @"upFile" : image , @"resumeId" : self.viewModel.resumeId, @"imageName" : imageName , @"imageView" : imageView };
    [self uploadAttachmentWithParams:dataToPost success:^(id responseObject) {
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic resultObject])
        {
            [self.viewModel.attachmentArrayM addObject:[dic resultObject]];
            [self.attachmentDictArrayM addObject:[dic resultObject]];
            [imageView configWithAttachment:[dic resultObject]];
        }
    } failure:^(id responseObject) {
        [imageView configError];
    }];
}
- (void)uploadAttachmentWithParams:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(id responseObject))failure
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ThridEdition/Resume/UploadResumeAttachmentFile",kHostUrl]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image = [params objectForKey:@"upFile"];
    NSString *imageName = [params objectForKey:@"imageName"];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(image, 1.0);
    if ( [imageName rangeOfString:@".png"].location != NSNotFound || [imageName rangeOfString:@".PNG"].location != NSNotFound )
    {
        data = UIImagePNGRepresentation(image);
    }
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"upFile"] && ![key isEqualToString:@"imageName"] && ![key isEqualToString:@"imageView"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"upFile\"; filename=\"%@\"\r\n", imageName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png, image/jpg, image/jpeg, image/gif, image/xls, image/doc, image/ppt, image/pdf\r\n\r\n"];
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    CPResumeAdditionalImageButton *imageView = [params valueForKey:@"imageView"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( responseObject )
            success( responseObject );
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure( nil );
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat totalWritten = totalBytesWritten;
        totalWritten /= ( 1024 * 1024 );
        CGFloat totalExpectedWrite = totalBytesExpectedToWrite;
        totalExpectedWrite /= ( 1024 * 1024 );
        if ( imageView )
        {
            [imageView setPrograssWithTotalBytesWritten:totalWritten totalBytesExpectedToWrite:totalExpectedWrite];
        }
    }];
    [operation start];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (UIButton *)uploadButton
{
    if ( !_uploadButton )
    {
        _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadButton setTitle:@"上传附件" forState:UIControlStateNormal];
        [_uploadButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_uploadButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE ]];
        [_uploadButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [_uploadButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [_uploadButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_uploadButton.layer setMasksToBounds:YES];
        [_uploadButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"send_file"];
            NSInteger count = [self.AdditionalImageArrayM count];
            if ( 5 == count )
            {
                if ( CP_SYSTEM_VERSION >= 8.0 )
                {
                    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"" message:@"附件最多上传5个" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertCtrl addAction:okAction];
                    [self presentViewController:alertCtrl animated:YES completion:nil];
                }
                else
                {
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:@"附件最多上传5个" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
                    [alerView show];
                }
                return;
            }
            [self uploadImage];
        }];
    }
    return _uploadButton;
}
- (void)retryUploadAdditionImageWithTag:(NSInteger)tag
{
    CPResumeAdditionalImageButton *imageView = [self.AdditionalImageArrayM objectAtIndex:tag];
    UIImage *image = [imageView getPlaceholderImage];
    NSString *imageName = [imageView getStorageImageName];
    NSString *strUser = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strUserTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    //得到图片的data
    NSDictionary *dataToPost = @{ @"tokenId" : strUserTocken, @"userId" : strUser , @"upFile" : image , @"resumeId" : self.viewModel.resumeId, @"imageName" : imageName , @"imageView" : imageView };
    [self uploadAttachmentWithParams:dataToPost success:^(id responseObject) {
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic resultObject])
        {
            [self.viewModel.attachmentArrayM addObject:[dic resultObject]];
            [self.attachmentDictArrayM addObject:[dic resultObject]];
            [imageView configWithAttachment:[dic resultObject]];
        }
    } failure:^(id responseObject) {
        [imageView configError];
    }];
}
#pragma mark - CPResumeAdditionalImageButtonDelegate
- (void)resumeAdditionalImageButton:(CPResumeAdditionalImageButton *)resumeAdditionalImageButton retryButton:(CPWResumeAdditionImageRetryButton *)retryButton
{
    [self retryUploadAdditionImageWithTag:retryButton.tag];
}
- (void)showMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    self.tipsView = nil;
}
- (CPPositionDetailDescribeLabel *)tipsLabel
{
    if ( !_tipsLabel )
    {
        _tipsLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [_tipsLabel setVerticalAlignment:VerticalAlignmentTop];
        [_tipsLabel setNumberOfLines:0];
        [_tipsLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
        NSString *str = @"提示 : 支持添加图片文件，5M以内；如JPEG、PNG、GIF";
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineSpacing:30 / CP_GLOBALSCALE];
        NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"], NSParagraphStyleAttributeName : paragraph}];
        [_tipsLabel setAttributedText:strM];
    }
    return _tipsLabel;
}
- (UIView *)imagesBackgroundView
{
    if ( !_imagesBackgroundView )
    {
        _imagesBackgroundView = [[UIView alloc] init];
    }
    return _imagesBackgroundView;
}
- (UIScrollView *)contentScrollView
{
    if ( !_contentScrollView )
    {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_contentScrollView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_contentScrollView setContentSize:self.view.bounds.size];
        [_contentScrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _contentScrollView;
}
- (NSMutableArray *)AdditionalImageArrayM
{
    if ( !_AdditionalImageArrayM )
    {
        _AdditionalImageArrayM = [NSMutableArray array];
    }
    return _AdditionalImageArrayM;
}
- (NSMutableArray *)additionalImageNameM
{
    if ( !_additionalImageNameM )
    {
        _additionalImageNameM = [NSMutableArray array];
    }
    return _additionalImageNameM;
}
- (NSMutableArray *)attachmentDictArrayM
{
    if ( !_attachmentDictArrayM )
    {
        _attachmentDictArrayM = [NSMutableArray array];
    }
    return _attachmentDictArrayM;
}
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"确定"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
@end