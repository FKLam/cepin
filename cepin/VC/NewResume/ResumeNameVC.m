//
//  ResumeNameVC.m
//  cepin
//
//  Created by dujincai on 15/6/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeNameVC.h"
#import "ResumeArrowCell.h"
#import "ResumeAddMoreCell.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeNameHeadCell.h"
#import "FullResumeMenuView.h"
#import "AllResumeDataModel.h"
#import "FullResumeVC.h"
#import "ResumeNameVM.h"
#import "AddResumeVC.h"
#import "AddResumeTagVC.h"
#import "AddExpectJobVC.h"
#import "AddJobStatusVC.h"
#import "ResumeJobExperienceVC.h"
#import "AddEducationVC.h"
#import "AddProjectVC.h"
#import "AddLanguangeVC.h"
#import "AddPracticeVC.h"
#import "AddTrainVC.h"
#import "AddOtherInfomationVC.h"
#import "AddDescriptionVC.h"
#import "ResumeNameModel.h"
#import "BaseCodeDTO.h"
#import "TBTextUnit.h"
#import "FullResumeVC.h"
#import "ResumeNameTagCell.h"
#import "SchoolAddResumeVC.h"
#import "BaseViewController+otherUI.h"
#import "JobSendResumeSucessVC.h"
#import "CreateSchoolResumeByInfoVC.h"
#import "CreateResumeByInfoVC.h"
#import "NewJobDetialVC.h"
#import "CPTestEnsureTextFiled.h"
#import "CPResumeInformationView.h"
#import "CPResumeExpectWorkView.h"
#import "CPResumeWorkExperienceView.h"
#import "CPResumeEducationView.h"
#import "CPResumeProjectExperienceView.h"
#import "CPResumeSelfDescribeView.h"
#import "CPResumeAboutSkillView.h"
#import "CPResumeAttachInformationView.h"
#import "CPResumeMoreButton.h"
#import "CPResumeEditReformer.h"
#import "ProjectListVC.h"
#import "SchoolResumeAddJobVC.h"
#import "ResumeAddJobVC.h"
#import "EducationListVC.h"
#import "RTPhotoHelper.h"
#import "VPImageCropperViewController.h"
#import "AllResumeVC.h"
#import "AddThridEditionResumeVM.h"
#import "CPSocialResumeReviewController.h"
#import "CPEditResumeRightMenuButton.h"
#import "CPTipsView.h"
#import "RTNetworking+Position.h"
#import "DynamicExamModelDTO.h"
#import "DynamicExamDetailVC.h"
#import "CPJobTestView.h"
#import "CPCommon.h"
#import "SDPhotoBrowser.h"
#define CP_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define ResumeBaseInfor_Height ( ( 40 + 120 + 60 + 36 * 9 + 50 * 8 + 20 + 36 * 2 + 60 + 6) / CP_GLOBALSCALE )
#define ResumeExpectWork_Height ( ( 40 + 120 + 60 + 42 * 2 + 18 * 2 + 60 + 6) / CP_GLOBALSCALE )
#define ResumeWorkExperience_Height ( ( 40 + 120 + 60) / CP_GLOBALSCALE )
#define ResumeEditFixd_Height ( (140 + 144 + 2) / CP_GLOBALSCALE )
@interface ResumeNameVC ()<FullResumeMenuViewDelegate,UIAlertViewDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate, UITextFieldDelegate, CPTipsViewDelegate, CPResumeAttachInformationViewDelegate, SDPhotoBrowserDelegate>
@property(nonatomic)BOOL addMore;
@property(nonatomic,retain)FullResumeMenuView *fullMenuView;
@property(nonatomic,strong)ResumeNameVM *viewModel;
@property(nonatomic,strong)ResumeNameModel *resumeModel;
@property(nonatomic,strong)FUIButton *sendResumeButton;
@property (nonatomic, strong) AddThridEditionResumeVM *saveResumeNameReformer;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;
@property (nonatomic, strong) UIView *firstHeaderView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) CPTestEnsureTextFiled *resumeTitleTextField;
@property (nonatomic, strong) CPResumeInformationView *resumeInformationView;
@property (nonatomic, strong) CPResumeExpectWorkView *resumeExpectWorkView;
@property (nonatomic, strong) CPResumeWorkExperienceView *resumeWorkExperienceView;
@property (nonatomic, strong) CPResumeEducationView *resumeEducationView;
@property (nonatomic, strong) CPResumeMoreButton *moreButton;
@property (nonatomic, strong) CPResumeProjectExperienceView *projectExperienceView;
@property (nonatomic, strong) CPResumeSelfDescribeView *selfDescribeView;
@property (nonatomic, strong) CPResumeAboutSkillView *aboutSkillView;
@property (nonatomic, strong) CPResumeAttachInformationView *attachInformationView;
@property (nonatomic, strong) CPJobTestView *jobTestView;
@property (nonatomic, assign) BOOL resumeNameChange;
@property (nonatomic, strong) UIView *rightMenuView;
@property (nonatomic, strong) UIButton *redMenuButton;
@property (nonatomic, assign) BOOL isShowRightMenu;
@property (nonatomic, strong) CPTipsView *tipsView;
@property (nonatomic, strong) UIButton *checkTestReportButton;
@property (nonatomic, strong) NSDictionary *examFinishDict;
@property (nonatomic, strong) NSString *deliveryString;
@property (nonatomic, strong) UIButton *deliveryButton;
@property (nonatomic, strong) UIView *maxSelecetdTipsView;
@end
@implementation ResumeNameVC
- (instancetype)initWithResumeId:(NSString *)resumeId
{
    self = [super init];
    if (self) {
        self.addMore = YES;
        self.viewModel = [[ResumeNameVM alloc] initWithResumeId:resumeId];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithResumeId:(NSString *)resumeId deliveryString:(NSString *)deliveryString
{
    self = [self initWithResumeId:resumeId];
    self.deliveryString = deliveryString;
    return self;
}
-(instancetype)initWithResumeId:(NSString *)resumeId JobId:(NSString *)jobId{
    self = [super init];
    if (self) {
        self.addMore = YES;
        self.viewModel = [[ResumeNameVM alloc] initWithResumeId:resumeId];
        self.viewModel.jobId = jobId;
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithResumeModel:(ResumeNameModel *)resumeModel
{
    self = [super init];
    if (self) {
        self.addMore = YES;
        self.viewModel = [[ResumeNameVM alloc] initWithResumeId:resumeModel.ResumeId];
        self.resumeModel = resumeModel;
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getResumeInfo];
    self.title = [self.viewModel.resumeNameModel.ResumeName length] > 0 ? self.viewModel.resumeNameModel.ResumeName : @"简历";
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = [self.viewModel.resumeNameModel.ResumeName length] > 0 ? self.viewModel.resumeNameModel.ResumeName : @"简历";
    self.saveResumeNameReformer = [[AddThridEditionResumeVM alloc] initWithResumeModel:self.viewModel.resumeNameModel];
    self.saveResumeNameReformer.resumeName = self.viewModel.resumeNameModel.ResumeName;
    self.saveResumeNameReformer.showMessageVC = self;
    [RACObserve(self.saveResumeNameReformer, changeResumeNameStateCode ) subscribeNext:^(id stateCode ) {
        if ( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess )
        {
            self.resumeNameChange = NO;
            // 简历是否可投状态
            if ( self.viewModel.resumeNameModel.IsCompleteResume.intValue == 1 )
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self shomMessageTips:@"简历还不够完整哦，看到心仪的职位会无法投递，确认退出吗？" buttonTitleArray:@[@"取消", @"确定"]];
            }
        }
    }];
    [RACObserve( self.saveResumeNameReformer, changeResumeNameEditStateCode) subscribeNext:^(id stateCode) {
        if ( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess )
        {
            self.title = self.saveResumeNameReformer.resumeName;
        }
    }];
    self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(clickedBackButton:)];
    //修改跳转逻辑 不进入编辑页面
    NSUInteger count = self.navigationController.viewControllers.count;
    UIViewController *vc = self.navigationController.viewControllers[count-2];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if ([vc isKindOfClass:[CreateSchoolResumeByInfoVC class]] || [vc isKindOfClass:[CreateResumeByInfoVC class]])
    {
        [array removeObject:vc];
    }
    self.navigationController.viewControllers  = [array copy];
}
- (void)viewDidLoad {
    [MobClick event:@"start_resume_edit"];
    [super viewDidLoad];
    self.resumeNameChange = NO;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.view addSubview:self.backgroundScrollView];
    [self.view addSubview:self.rightMenuView];
    [self.view addSubview:self.deliveryButton];
    [self hideRightMenu];
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight + 150 * 20)];
    if (self.viewModel.jobId) {
         self.tableView.frame = CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, (self.view.viewHeight)-44-((IsIOS7)?20:0)-40);
        self.sendResumeButton = (FUIButton*)[self bottomButtonWithTitle:@"简历已完善,立即投递"];
        self.sendResumeButton.hidden = YES;
        @weakify(self)
        [[self.sendResumeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
            @strongify(self);
            [self.viewModel sendResume];
            [MobClick event:@"perfect_and_send_resume"];
        }];
    }
    self.fullMenuView = [[FullResumeMenuView alloc]initWithFrame:self.view.bounds];
    self.fullMenuView.hidden = YES;
    self.fullMenuView.delegate = self;
    [self.view addSubview:self.fullMenuView];
    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            if (self.viewModel.jobId && self.viewModel.resumeNameModel.IsCompleteResume.intValue==1) {
                self.sendResumeButton.hidden = NO;
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.resumeNameModel.PhotoUrlPath] placeholderImage:[UIImage imageNamed:@"portrait_edit"]];
            [self.resumeTitleTextField setText:self.viewModel.resumeNameModel.ResumeName];
            [self.resumeInformationView configWithResume:self.viewModel.resumeNameModel];
            [self.resumeExpectWorkView configWithResume:self.viewModel.resumeNameModel];
            [self.resumeWorkExperienceView configWithResume:self.viewModel.resumeNameModel];
            [self.resumeEducationView configWithResume:self.viewModel.resumeNameModel];
            [self.projectExperienceView configWithResume:self.viewModel.resumeNameModel];
            [self.selfDescribeView configWithResume:self.viewModel.resumeNameModel title:nil hideMustWriteFlag:YES];
            [self.aboutSkillView configWithResume:self.viewModel.resumeNameModel];
            [self.attachInformationView configWithResume:self.viewModel.resumeNameModel];
            [self resetFrame];
            [self checkIsExam];
            [self checkDeliveryButton];
        }
        else if ([self requestStateWithStateCode:stateCode] == HUDCodeNetWork)
        {
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
        }
        self.title = [self.viewModel.resumeNameModel.ResumeName length] > 0 ? self.viewModel.resumeNameModel.ResumeName : @"简历";
        [self.resumeTitleTextField setText:self.viewModel.resumeNameModel.ResumeName];
        if ( 16 < [self.viewModel.resumeNameModel.ResumeName length] )
        {
            self.resumeNameChange = YES;
        }
    }];
    [RACObserve(self.viewModel,deleteStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [RACObserve(self.viewModel,SendResumeStateCode) subscribeNext:^(id stateCode) {
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            self.sendResumeButton.hidden = YES;
            JobSendResumeSucessVC *vc = [[JobSendResumeSucessVC alloc]initWithPositionId:self.viewModel.jobId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(code == HUDCodeNone)
        {
                UIAlertView *sendAlert =[[UIAlertView alloc]initWithTitle:nil message:self.viewModel.message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [sendAlert show];
        }
    }];
    [[self addNavicationObjectWithType:NavcationBarObjectTypePreview] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //        ResumeType;//(1社招，2校招)
        if ( 2 == [self.viewModel.resumeNameModel.ResumeType intValue] )
        {
            FullResumeVC *vc = [[FullResumeVC alloc] initWithResumeId:self.viewModel.resumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( 1 == [self.viewModel.resumeNameModel.ResumeType intValue] )
        {
            CPSocialResumeReviewController *vc = [[CPSocialResumeReviewController alloc] initWithResumeId:self.viewModel.resumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    __weak typeof( self ) weakSelf = self;
    [self.redMenuButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf showOrHideRightMenu];
        [MobClick event:@"slid_btn_click"];
        [MobClick event:@"start_slide"];
    }];
    [self.viewModel getExamReport];
    [RACObserve( self.viewModel, reportStateCode) subscribeNext:^(id stateCode ) {
        @strongify( self );
        if ( stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess )
        {
            [self checkIsExam];
        }
    }];
    [self.view addSubview:self.maxSelecetdTipsView];
}
- (void)checkIsExam
{
    if ( self.examFinishDict )
        self.examFinishDict = nil;
    NSString *strUserID = [MemoryCacheData shareInstance].userLoginData.UserId;
    NSString *strTocken = [MemoryCacheData shareInstance].userLoginData.TokenId;
    if ( 0 == [strUserID length] || 0 == [strTocken length] )
        return;
    __weak typeof( self ) weakSelf = self;
    RACSignal *checkExamSignal = [[RTNetworking shareInstance] isExamWithTokenId:strTocken userId:strUserID];
    [checkExamSignal subscribeNext:^(RACTuple *tuple) {
        NSDictionary *dict = (NSDictionary *)tuple.second;
        if ( [dict resultSucess] )
        {
            weakSelf.examFinishDict = [dict resultObject];
        }
        [weakSelf resetFrame];
    }];
}
- (void)clickedBackButton:(id)sender
{
    if ( self.resumeNameChange )
    {
        self.resumeNameChange = NO;
        [self.view endEditing:YES];
        [self.saveResumeNameReformer saveBackEditBaseInfo:self.viewModel.resumeId];
        return;
    }
    [self.view endEditing:YES];
    // 简历是否可投状态
    if ( self.viewModel.resumeNameModel.IsCompleteResume.intValue == 1 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self shomMessageTips:@"简历还不够完整哦，看到心仪的职位会无法投递，确认退出吗？" buttonTitleArray:@[@"取消", @"确定"]];
    }
}
- (void)uploadImage
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从手机相册中选择", nil), nil];
    [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex){
        if (sheet.cancelButtonIndex == buttonIndex)
        {
            //[(MMDrawerController *)ROOTVIEWCONTROLLER setMaximumLeftDrawerWidth:MinLeftSlideWidth animated:YES completion:nil];
            return;
        }
        if (buttonIndex == 0)
        {
            // 拍照
            if ([RTPhotoHelper isCameraAvailable] && [RTPhotoHelper doesCameraSupportTakingPhotos])
            {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([RTPhotoHelper isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     RTLog(@"Picker View Controller is presented");
                                 }];
            }
            
        } else if (buttonIndex == 1)
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
    }];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( [navigationController isKindOfClass:[UIImagePickerController class]] )
    {
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        viewController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:60 / CP_GLOBALSCALE]}];
    }
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    self.headerImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
    [self.viewModel uploadUserHeadImageWithImage:editedImage];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        //UIImage *portraitImg = UIIMAGE(UIImagePickerControllerOriginalImage);
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
        }];
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
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
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
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
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
- (CGFloat)contentHeight
{
    CGFloat tempHeight = 0;
    tempHeight =  ResumeEditFixd_Height + [CPResumeEditReformer informationHeight:self.viewModel.resumeNameModel] + [CPResumeEditReformer expectWorkHeight:self.viewModel.resumeNameModel] + [CPResumeEditReformer workExperienceTotalHeight:self.viewModel.resumeNameModel] + [CPResumeEditReformer educationTotalHeight:self.viewModel.resumeNameModel] + ( 40 + 144 + 40 ) / CP_GLOBALSCALE + 64.0;
    if ( self.moreButton.isSelected )
    {
        tempHeight += [CPResumeEditReformer projectExperienceTotalHeight:self.viewModel.resumeNameModel] + [CPResumeEditReformer selfDescribeTotalHeight:self.viewModel.resumeNameModel] + [CPResumeEditReformer aboutSkillHeight:self.viewModel.resumeNameModel] + [CPResumeEditReformer resumeEditAdditionHeight:self.viewModel.resumeNameModel];
        if ( self.examFinishDict )
        {
            NSString *finishExam = nil;
            if ( ![[self.examFinishDict objectForKey:@"IsFinshed"] isKindOfClass:[NSNull class]] )
            {
                finishExam = [self.examFinishDict objectForKey:@"IsFinshed"];
            }
            if ( finishExam.intValue == 1 && 0 < [self.viewModel.reportDatas count] )
            {
                tempHeight += ( 144 + 40 ) / CP_GLOBALSCALE;
            }
            else
            {
                tempHeight += ( 120 + 2 + 6 + 60 + 42 + 40 + 120 + 60 + 40 ) / CP_GLOBALSCALE;
            }
        }
        else
        {
            tempHeight += ( 120 + 2 + 6 + 60 + 42 + 40 + 120 + 60 + 40 ) / CP_GLOBALSCALE;
        }
    }
    return tempHeight;
}
- (void)resetFrame
{
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth, [self contentHeight])];
    [self.resumeInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.firstHeaderView.mas_bottom );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( [CPResumeEditReformer informationHeight:self.viewModel.resumeNameModel] ) );
    }];
    [self.resumeExpectWorkView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.resumeInformationView.mas_bottom );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( [CPResumeEditReformer expectWorkHeight:self.viewModel.resumeNameModel] ) );
    }];
    [self.resumeWorkExperienceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.resumeExpectWorkView.mas_bottom );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( [CPResumeEditReformer workExperienceTotalHeight:self.viewModel.resumeNameModel] ) );
    }];
    [self.resumeEducationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.resumeWorkExperienceView.mas_bottom );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( [CPResumeEditReformer educationTotalHeight:self.viewModel.resumeNameModel] ) );
    }];
    if ( self.moreButton.isSelected && CPResumeEditDefaultBlock !=
        [CPResumeEditReformer resumeEditBlock] )
    {
        [self resetOtherFrame];
    }
    [CPResumeEditReformer saveResumeEditBlock:CPResumeEditDefaultBlock];
}
- (void)resetOtherFrame
{
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth, [self contentHeight])];
    CPResumeEditBlockType tempBlockType = [CPResumeEditReformer resumeEditBlock];
    CGFloat projectExperienceH = 0;
    CGFloat selfDescribeH = 0;
    CGFloat aboutSkillH = 0;
    CGFloat attachH = 0;
    projectExperienceH = [CPResumeEditReformer projectExperienceTotalHeight:self.viewModel.resumeNameModel];
    selfDescribeH = [CPResumeEditReformer selfDescribeTotalHeight:self.viewModel.resumeNameModel];
    aboutSkillH = [CPResumeEditReformer aboutSkillHeight:self.viewModel.resumeNameModel];
    attachH = [CPResumeEditReformer resumeEditAdditionHeight:self.viewModel.resumeNameModel];
    switch ( tempBlockType )
    {
        case CPResumeEditProjectExperienceBlock:
        {
            [self.projectExperienceView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.moreButton.mas_bottom );
                make.left.equalTo( _backgroundScrollView.mas_left );
                make.width.equalTo( @( kScreenWidth ) );
                make.height.equalTo( @( projectExperienceH ) );
            }];
            break;
        }
        case CPResumeEditSelfDescribeBlock:
        {
            [self.selfDescribeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.projectExperienceView.mas_bottom );
                make.left.equalTo( _backgroundScrollView.mas_left );
                make.width.equalTo( @( kScreenWidth ) );
                make.height.equalTo( @( selfDescribeH ) );
            }];
            break;
        }
        case CPResumeEditAboutSkillBlock:
        {
            [self.aboutSkillView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.selfDescribeView.mas_bottom );
                make.left.equalTo( _backgroundScrollView.mas_left );
                make.width.equalTo( @( kScreenWidth ) );
                make.height.equalTo( @( aboutSkillH ) );
            }];
            break;
        }
        case CPResumeEditAttachInforBlock:
        {
            [self.attachInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( self.aboutSkillView.mas_bottom );
                make.left.equalTo( _backgroundScrollView.mas_left );
                make.width.equalTo( @( kScreenWidth ) );
                make.height.equalTo( @( attachH ) );
            }];
            break;
        }
        default:
            break;
    }
}
- (void)respondMoreButton
{
    [self.backgroundScrollView setContentSize:CGSizeMake(kScreenWidth, [self contentHeight])];
    CGFloat projectExperienceH = 0;
    CGFloat selfDescribeH = 0;
    CGFloat aboutSkillH = 0;
    CGFloat attachH = 0;
    CGFloat checkTestH = 0;
    CGFloat doTestH = 0;
    [self.checkTestReportButton setHidden:YES];
    [self.jobTestView setHidden:YES];
    if ( self.moreButton.isSelected )
    {
        projectExperienceH = [CPResumeEditReformer projectExperienceTotalHeight:self.viewModel.resumeNameModel];
        selfDescribeH = [CPResumeEditReformer selfDescribeTotalHeight:self.viewModel.resumeNameModel];
        aboutSkillH = [CPResumeEditReformer aboutSkillHeight:self.viewModel.resumeNameModel];
        attachH = [CPResumeEditReformer resumeEditAdditionHeight:self.viewModel.resumeNameModel];
        [self.backgroundScrollView scrollRectToVisible:CGRectMake(0, self.moreButton.viewY - 40 / CP_GLOBALSCALE - 64.0, kScreenWidth, kScreenHeight) animated:YES];
        if ( self.examFinishDict )
        {
            NSString *finishExam = nil;
            if ( ![[self.examFinishDict objectForKey:@"IsFinshed"] isKindOfClass:[NSNull class]] )
            {
                finishExam = [self.examFinishDict objectForKey:@"IsFinshed"];
            }
            if ( finishExam.intValue == 1 && 0 < [self.viewModel.reportDatas count] )
            {
                [self.checkTestReportButton setHidden:NO];
                [self.jobTestView setHidden:YES];
            }
            else
            {
                [self.checkTestReportButton setHidden:YES];
                [self.jobTestView setHidden:NO];
            }
        }
        else
        {
            [self.checkTestReportButton setHidden:YES];
            [self.jobTestView setHidden:NO];
        }
        if ( !self.checkTestReportButton.isHidden )
            checkTestH = ( 144 ) / CP_GLOBALSCALE;
        if ( !self.jobTestView.isHidden )
            doTestH = ( 120 + 2 + 6 + 60 + 42 + 40 + 120 + 60 + 40 ) / CP_GLOBALSCALE;
    }
    [self.projectExperienceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.moreButton.mas_bottom );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( projectExperienceH ) );
    }];
    [self.selfDescribeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.projectExperienceView.mas_bottom );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( selfDescribeH ) );
    }];
    [self.aboutSkillView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.selfDescribeView.mas_bottom );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( aboutSkillH ) );
    }];
    [self.attachInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.aboutSkillView.mas_bottom );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        make.height.equalTo( @( attachH ) );
    }];
    [self.checkTestReportButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.attachInformationView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
        make.left.equalTo( _backgroundScrollView.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.width.equalTo( @( kScreenWidth - 40 / CP_GLOBALSCALE * 2 ) );
        //            make.height.equalTo( @( 144 / 3.0 ) );
        make.height.equalTo( @( checkTestH ) );
    }];
    [self.jobTestView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.attachInformationView.mas_bottom ).offset( 0 / 3.0 );
        make.left.equalTo( _backgroundScrollView.mas_left );
        make.width.equalTo( @( kScreenWidth ) );
        //            make.height.equalTo( @( ( 120 + 2 + 6 + 60 + 42 + 40 + 120 + 60 + 40 ) / 3.0 ) );
        make.height.equalTo( @( doTestH ) );
    }];
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getResumeInfo];
}
-(void)didFullResumeMenuTouch:(int)index
{
    switch (index)
    {
        case 0:
        {
            FullResumeVC *vc = [[FullResumeVC alloc]initWithResumeId:self.viewModel.resumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            [self.viewModel toTop];
        }
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除简历" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self hideRightMenu];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( textField == self.resumeTitleTextField && self.resumeNameChange )
    {
        [self.saveResumeNameReformer editBaseInfo:self.viewModel.resumeId];
        self.resumeNameChange = NO;
    }
}
#pragma mark - 右侧菜单弹出 收起
- (void)hideRightMenu
{
    if ( self.rightMenuView.viewX == kScreenWidth - 80 / CP_GLOBALSCALE)
        return;
    __weak typeof( self ) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.rightMenuView.viewX = kScreenWidth - 80 / CP_GLOBALSCALE;
        weakSelf.isShowRightMenu = NO;
    }];
}
- (void)showRightMenu
{
    CGFloat rightMenuViewW = (kScreenWidth / 2.0 - 180 / CP_GLOBALSCALE / 2.0 ) + 80 / CP_GLOBALSCALE;
    CGFloat rightMenuViewX = kScreenWidth - rightMenuViewW;
    if ( self.rightMenuView.viewX == rightMenuViewX )
        return;
    __weak typeof( self ) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat rightMenuViewW = (kScreenWidth / 2.0 - 180 / CP_GLOBALSCALE / 2.0 ) + 80 / CP_GLOBALSCALE;
        CGFloat rightMenuViewX = kScreenWidth - rightMenuViewW;
        weakSelf.rightMenuView.viewX = rightMenuViewX;
        weakSelf.isShowRightMenu = YES;
    }];
}
- (void)showOrHideRightMenu
{
    if ( self.isShowRightMenu )
    {
        [self hideRightMenu];
    }
    else
    {
        [self showRightMenu];
        [MobClick event:@"slid_show"];
    }
}
- (void)checkDeliveryButton
{
    if ( !self.deliveryString || 0 == [self.deliveryString length] )
        return;
    BOOL hideDeliveryButton = NO;
    if ( !self.viewModel.resumeNameModel.ExpectCity || 0 == [self.viewModel.resumeNameModel.ExpectCity length])
    {
        hideDeliveryButton = YES;
        [self.deliveryButton setHidden:hideDeliveryButton];
        return;
    }
    if ( !self.viewModel.resumeNameModel.WorkList || 0 == [self.viewModel.resumeNameModel.WorkList count] )
    {
        hideDeliveryButton = YES;
        [self.deliveryButton setHidden:hideDeliveryButton];
        return;
    }
    if ( !self.viewModel.resumeNameModel.EducationList || 0 == [self.viewModel.resumeNameModel.EducationList count] )
    {
        hideDeliveryButton = YES;
        [self.deliveryButton setHidden:hideDeliveryButton];
        return;
    }
    [self.deliveryButton setHidden:hideDeliveryButton];
}
#pragma mark - CPResumeAttachInformationViewDelegate
- (void)resumeAttachInformationView:(CPResumeAttachInformationView *)resumeAttachInformationView reviewImageButton:(UIButton *)reviewImageButton imageArray:(NSArray *)imageArray isImage:(BOOL)isImage originArray:(NSArray *)originArray
{
    if ( 0 == [imageArray count] || 0 == [originArray count] )
        return;
    if ( isImage )
    {
        NSInteger tempTag = 0;
        NSDictionary *dict = [originArray objectAtIndex:reviewImageButton.tag];
        NSString *tempNameString = [dict valueForKey:@"FilePath"];
        for( NSDictionary *tempDict in imageArray )
        {
            NSString *nameString = [tempDict valueForKey:@"FilePath"];
            if ( [tempNameString isEqualToString:nameString] )
                break;
            tempTag++;
        }
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.sourceImagesContainerView = self.view;
        browser.imageCount = [imageArray count];
        browser.currentImageIndex = tempTag;
        browser.delegate = self;
        [browser show];
    }
    else
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
    }
}
#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImage *placeholderImage = [UIImage imageNamed:@"null_pic"];
    return placeholderImage;
}
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSMutableArray *attachArray = self.viewModel.resumeNameModel.ResumeAttachmentList;
    NSDictionary *attachmentDict = attachArray[index];
    NSString *filePathString = [attachmentDict valueForKey:@"FilePath"];
    NSURL *filePathURL = [NSURL URLWithString:filePathString];
    return filePathURL;
}
#pragma mark - getter methods
- (UIView *)firstHeaderView
{
    if ( !_firstHeaderView )
    {
        _firstHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 140 + 144 + 144 ) / CP_GLOBALSCALE )];
        [_firstHeaderView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        CALayer *topBackgroundLayer = [[CALayer alloc] init];
        [topBackgroundLayer setBackgroundColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [topBackgroundLayer setFrame:CGRectMake(0, 0, kScreenWidth, 140 / CP_GLOBALSCALE + kScreenHeight)];
        [_firstHeaderView.layer addSublayer:topBackgroundLayer];
        [_firstHeaderView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _firstHeaderView.mas_centerX );
            make.top.equalTo( _firstHeaderView.mas_top ).offset( (140 - 180 / 2.0) / CP_GLOBALSCALE + kScreenHeight );
            make.width.equalTo( @( 180 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 180 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
        [_firstHeaderView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _firstHeaderView ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( _firstHeaderView.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.top.equalTo( self.headerImageView.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
        }];
        
        UILabel *resumeTitleLable = [[UILabel alloc] init];
        [resumeTitleLable setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [resumeTitleLable setTextColor:[UIColor colorWithHexString:@"707070"]];
        [resumeTitleLable setText:@"简历名称"];
        [_firstHeaderView addSubview:resumeTitleLable];
        [resumeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( _firstHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _firstHeaderView.mas_bottom );
        }];
        
        [_firstHeaderView addSubview:self.resumeTitleTextField];
        [self.resumeTitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( _firstHeaderView.mas_right ).offset( -80 / CP_GLOBALSCALE );
            make.height.equalTo( resumeTitleLable );
            make.bottom.equalTo( _firstHeaderView.mas_bottom );
            make.left.equalTo( resumeTitleLable.mas_right ).offset( 40 / CP_GLOBALSCALE );
        }];
        
        UIView *separatorLineSecond = [[UIView alloc] init];
        [separatorLineSecond setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
        [_firstHeaderView addSubview:separatorLineSecond];
        [separatorLineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _firstHeaderView );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( _firstHeaderView.mas_right );
            make.bottom.equalTo( _firstHeaderView.mas_bottom );
        }];
    }
    return _firstHeaderView;
}
- (CPTestEnsureTextFiled *)resumeTitleTextField
{
    if ( !_resumeTitleTextField )
    {
        _resumeTitleTextField = [[CPTestEnsureTextFiled alloc] init];
        [_resumeTitleTextField setTextAlignment:NSTextAlignmentRight];
        [_resumeTitleTextField setPlaceholder:@"请输入简历名称"];
        [_resumeTitleTextField setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_resumeTitleTextField setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_resumeTitleTextField setTextAlignment:NSTextAlignmentRight];
        [_resumeTitleTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_resumeTitleTextField setTag:-1];
        [_resumeTitleTextField setKeyboardType:UIKeyboardTypeDefault];
        [_resumeTitleTextField setDelegate:self];
        @weakify(self);
        [[_resumeTitleTextField rac_textSignal]subscribeNext:^(NSString *text)
         {
             @strongify(self)
             if ( -1 != _resumeTitleTextField.tag )
                 return;
             self.saveResumeNameReformer.resumeName = text;
             if ( 0 < [self.viewModel.resumeNameModel.ResumeName length] )
                 self.resumeNameChange = YES;
             [MobClick event:@"edit_resume_name"];
         }];
    }
    return _resumeTitleTextField;
}
- (UIImageView *)headerImageView
{
    if ( !_headerImageView )
    {
        _headerImageView = [[UIImageView alloc] init];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.resumeNameModel.PhotoUrlPath] placeholderImage:[UIImage imageNamed:@"portrait_edit"]];
        [_headerImageView.layer setCornerRadius:186 / CP_GLOBALSCALE / 2.0];
        [_headerImageView.layer setMasksToBounds:YES];
        [_headerImageView setUserInteractionEnabled:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [_headerImageView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _headerImageView.mas_top );
            make.left.equalTo( _headerImageView.mas_left );
            make.bottom.equalTo( _headerImageView.mas_bottom );
            make.right.equalTo( _headerImageView.mas_right );
        }];
        [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self uploadImage];
            [MobClick event:@"img_btn_click"];
        }];
    }
    return _headerImageView;
}
- (UIScrollView *)backgroundScrollView
{
    if ( !_backgroundScrollView )
    {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0, kScreenWidth, self.view.viewHeight - 64.0)];
        [_backgroundScrollView setDelegate:self];
        [_backgroundScrollView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_backgroundScrollView addSubview:self.firstHeaderView];
        [self.firstHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _backgroundScrollView.mas_top ).offset( -kScreenHeight );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @((140 + 90 + 84 + 144) / CP_GLOBALSCALE + kScreenHeight ) );
        }];
        [_backgroundScrollView addSubview:self.resumeInformationView];
        [self.resumeInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.firstHeaderView.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( ResumeBaseInfor_Height ) );
        }];
        [_backgroundScrollView addSubview:self.resumeExpectWorkView];
        [self.resumeExpectWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.resumeInformationView.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( ResumeExpectWork_Height ) );
        }];
        [_backgroundScrollView addSubview:self.resumeWorkExperienceView];
        [self.resumeWorkExperienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.resumeExpectWorkView.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( 150 * 3 ) );
        }];
        [_backgroundScrollView addSubview:self.resumeEducationView];
        [self.resumeEducationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.resumeWorkExperienceView.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( 150 * 2 ) );
        }];
        [_backgroundScrollView addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.resumeEducationView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( (144) / CP_GLOBALSCALE ) );
            make.width.equalTo( @( kScreenWidth - 40 / CP_GLOBALSCALE * 2 ) );
            make.centerX.equalTo( self.resumeEducationView.mas_centerX );
        }];
        [_backgroundScrollView addSubview:self.projectExperienceView];
        [self.projectExperienceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.moreButton.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( 0 ) );
        }];
        [_backgroundScrollView addSubview:self.selfDescribeView];
        [self.selfDescribeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.projectExperienceView.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( 0 ) );
        }];
        [_backgroundScrollView addSubview:self.aboutSkillView];
        [self.aboutSkillView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.selfDescribeView.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( 0 ) );
        }];
        [_backgroundScrollView addSubview:self.attachInformationView];
        [self.attachInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.aboutSkillView.mas_bottom );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            make.height.equalTo( @( 0 ) );
        }];
        [_backgroundScrollView addSubview:self.checkTestReportButton];
        [self.checkTestReportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.attachInformationView.mas_bottom ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _backgroundScrollView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.width.equalTo( @( kScreenWidth - 40 / CP_GLOBALSCALE * 2 ) );
            //            make.height.equalTo( @( 144 / 3.0 ) );
            make.height.equalTo( @( 0 ) );
        }];
        [_backgroundScrollView addSubview:self.jobTestView];
        [self.jobTestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.attachInformationView.mas_bottom ).offset( 0 / 3.0 );
            make.left.equalTo( _backgroundScrollView.mas_left );
            make.width.equalTo( @( kScreenWidth ) );
            //            make.height.equalTo( @( ( 120 + 2 + 6 + 60 + 42 + 40 + 120 + 60 + 40 ) / 3.0 ) );
            make.height.equalTo( @( 0 ) );
        }];
    }
    return _backgroundScrollView;
}
- (CPResumeInformationView *)resumeInformationView
{
    if ( !_resumeInformationView )
    {
        _resumeInformationView = [[CPResumeInformationView alloc] initWithFrame:self.view.bounds];
        [_resumeInformationView.editResumeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"edit_base_info"];
            if ( 0 == [self.viewModel.resumeNameModel.ResumeName length] )
            {
                [self shomMessageTips:@"请输入简历名称" buttonTitleArray:@[@"确定"]];
                return;
            }
            else if ( 16 < [self.viewModel.resumeNameModel.ResumeName length] )
            {
                [self shomMessageTips:@"简历名称不能超过16个字符" buttonTitleArray:@[@"确定"]];
                return;
            }
            if( self.viewModel.resumeNameModel.ResumeType.integerValue == 2 )
            {
                SchoolAddResumeVC *vc = [[SchoolAddResumeVC alloc] initWithModel:self.viewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                AddResumeVC *vc = [[AddResumeVC alloc] initWithModel:self.viewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _resumeInformationView;
}
- (CPResumeExpectWorkView *)resumeExpectWorkView
{
    if ( !_resumeExpectWorkView )
    {
        _resumeExpectWorkView = [[CPResumeExpectWorkView alloc] initWithFrame:self.view.bounds];
        [_resumeExpectWorkView.editResumeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"edit_expect_work"];
            if (self.viewModel.resumeNameModel.ResumeType.intValue == 2)
            {
                AddExpectJobVC *vc = [[AddExpectJobVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                AddExpectJobVC *vc = [[AddExpectJobVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }
         }];
        [_resumeExpectWorkView.addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.viewModel.resumeNameModel.ResumeType.intValue == 2)
            {
                AddExpectJobVC *vc = [[AddExpectJobVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                AddExpectJobVC *vc = [[AddExpectJobVC alloc] initWithModel:self.viewModel.resumeNameModel isSocial:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _resumeExpectWorkView;
}
- (CPResumeWorkExperienceView *)resumeWorkExperienceView
{
    if ( !_resumeWorkExperienceView )
    {
        _resumeWorkExperienceView = [[CPResumeWorkExperienceView alloc] initWithFrame:self.view.bounds];
        [_resumeWorkExperienceView.editResumeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"edit_work_experience"];
            ResumeJobExperienceVC *vc = [[ResumeJobExperienceVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
            [MobClick event:@"openlist_work_experience"];
        }];
        [_resumeWorkExperienceView.addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"add_work_experience"];
            if(self.viewModel.resumeNameModel.ResumeType.intValue == 2)
            {
                SchoolResumeAddJobVC *vc = [[SchoolResumeAddJobVC alloc]initWithResumeId:self.viewModel.resumeId];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                ResumeAddJobVC *vc = [[ResumeAddJobVC alloc] initWithResume:self.viewModel.resumeNameModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _resumeWorkExperienceView;
}
- (CPResumeEducationView *)resumeEducationView
{
    if ( !_resumeEducationView )
    {
        _resumeEducationView = [[CPResumeEducationView alloc] initWithFrame:self.view.bounds];
        [_resumeEducationView.editResumeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"edit_education_experience"];
            AddEducationVC *vc = [[AddEducationVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_resumeEducationView.addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if(self.viewModel.resumeNameModel.ResumeType.intValue == 2)
            {
                EducationListVC *vc = [[EducationListVC alloc] initWithResume:self.viewModel.resumeNameModel isSocial:NO];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                EducationListVC *vc = [[EducationListVC alloc] initWithResume:self.viewModel.resumeNameModel isSocial:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _resumeEducationView;
}
- (CPResumeMoreButton *)moreButton
{
    if ( !_moreButton )
    {
        _moreButton = [CPResumeMoreButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_moreButton setTitle:@"展开更多模块" forState:UIControlStateNormal];
        [_moreButton setTitle:@"收起更多模块" forState:UIControlStateSelected];
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_moreButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_moreButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_moreButton.layer setMasksToBounds:YES];
        [_moreButton setImage:[UIImage imageNamed:@"ic_down"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"ic_up"] forState:UIControlStateSelected];
        [_moreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeMoreButton *sender) {
            sender.selected = !sender.isSelected;
            [self respondMoreButton];
        }];
    }
    return _moreButton;
}
- (CPResumeProjectExperienceView *)projectExperienceView
{
    if ( !_projectExperienceView )
    {
        _projectExperienceView = [[CPResumeProjectExperienceView alloc] initWithFrame:self.view.bounds];
        [_projectExperienceView.editResumeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"edit_project_experience"];
            [CPResumeEditReformer saveResumeEditBlock:CPResumeEditProjectExperienceBlock];
            AddProjectVC *vc = [[AddProjectVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
            [MobClick event:@"openlist_project_experience"];
        }];
        [_projectExperienceView.addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [CPResumeEditReformer saveResumeEditBlock:CPResumeEditProjectExperienceBlock];
            ProjectListVC *vc = [[ProjectListVC alloc] initWithResume:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _projectExperienceView;
}
- (CPResumeSelfDescribeView *)selfDescribeView
{
    if ( !_selfDescribeView )
    {
        _selfDescribeView = [[CPResumeSelfDescribeView alloc] initWithFrame:self.view.bounds];
        [_selfDescribeView.editResumeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"edit_describ"];
            [CPResumeEditReformer saveResumeEditBlock:CPResumeEditSelfDescribeBlock];
            AddDescriptionVC *vc = [[AddDescriptionVC alloc] initWithModelId:self.viewModel.resumeNameModel.ResumeId defaultDes:self.viewModel.resumeNameModel.UserRemark];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_selfDescribeView.addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [CPResumeEditReformer saveResumeEditBlock:CPResumeEditSelfDescribeBlock];
            AddDescriptionVC *vc = [[AddDescriptionVC alloc] initWithModelId:self.viewModel.resumeNameModel.ResumeId defaultDes:self.viewModel.resumeNameModel.UserRemark];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _selfDescribeView;
}
- (CPResumeAboutSkillView *)aboutSkillView
{
    if ( !_aboutSkillView )
    {
        _aboutSkillView = [[CPResumeAboutSkillView alloc] initWithFrame:self.view.bounds];
        [_aboutSkillView.editResumeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"edit_language_skill"];
            [CPResumeEditReformer saveResumeEditBlock:CPResumeEditAboutSkillBlock];
            AddLanguangeVC *vc = [[AddLanguangeVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_aboutSkillView.addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [CPResumeEditReformer saveResumeEditBlock:CPResumeEditAboutSkillBlock];
            AddLanguangeVC *vc = [[AddLanguangeVC alloc]initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _aboutSkillView;
}
- (CPResumeAttachInformationView *)attachInformationView
{
    if ( !_attachInformationView )
    {
        _attachInformationView = [[CPResumeAttachInformationView alloc] initWithFrame:self.view.bounds];
        [_attachInformationView setResumeAttachInformationViewDelegate:self];
        [_attachInformationView.editResumeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [CPResumeEditReformer saveResumeEditBlock:CPResumeEditAttachInforBlock];
            AddOtherInfomationVC *vc = [[AddOtherInfomationVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_attachInformationView.addMoreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [CPResumeEditReformer saveResumeEditBlock:CPResumeEditAttachInforBlock];
            AddOtherInfomationVC *vc = [[AddOtherInfomationVC alloc] initWithModel:self.viewModel.resumeNameModel];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _attachInformationView;
}
- (CPJobTestView *)jobTestView
{
    if ( !_jobTestView )
    {
        _jobTestView = [[CPJobTestView alloc] initWithFrame:self.view.bounds];
        [_jobTestView setHidden:YES];
        [_jobTestView.beginTestButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            NSString *url = [NSString stringWithFormat:@"%@/examcenter/desc?id=2",kHostMUrl];
            DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:url examDetail:examDetailOther];
            vc.title = @"极速职业测评";
            vc.strTitle = @"极速职业测评";
            vc.urlPath = url;
            vc.isJiSuCepin = YES;
            vc.urlLogo = @"http://file.cepin.com/da/speadexam_480_262.png";
            vc.contentText = @"你是否处于职业困惑中，不知道自己适合干什么？或者总觉得对现在的工作不感兴趣，毫无动力？再或者面临职业发展和转型，犹豫着何去何从？极速职业测评基于大五人格理论，可以帮助你深入了解自己的性格特点和脸谱类型、评估个人的能力水平和优劣势，并根据你的性格与能力帮助你找到最适合的岗位和企业。超过1000万测评者亲证，绝对duang duang的！为确保结果能真实反映你的水平，请：在安静、独立的空间完成测评根据第一反应答题如遇网络问题，退出后可以重新进入答题界面";
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _jobTestView;
}
- (UIView *)rightMenuView
{
    if ( !_rightMenuView )
    {
        CGFloat redButtonW = 115 / CP_GLOBALSCALE;
        CGFloat rightMenuViewW = (kScreenWidth / 2.0 - 180 / CP_GLOBALSCALE / 2.0 ) + 80 / CP_GLOBALSCALE;
        CGFloat rightMenuViewX = kScreenWidth - rightMenuViewW;
        _rightMenuView = [[UIView alloc] initWithFrame:CGRectMake(rightMenuViewX, 64.0 + ( 144 + 24 ) / CP_GLOBALSCALE, rightMenuViewW, 640 / CP_GLOBALSCALE)];
        [_rightMenuView setBackgroundColor:[UIColor clearColor]];
        UIView *menuViewBackground = [[UIView alloc] initWithFrame:CGRectMake(80 / CP_GLOBALSCALE, 0, rightMenuViewW - 80 / CP_GLOBALSCALE, 640 / CP_GLOBALSCALE)];
        [menuViewBackground setBackgroundColor:[UIColor whiteColor]];
        [menuViewBackground.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [menuViewBackground.layer setShadowColor:[UIColor colorWithHexString:@"000000" alpha:1.0].CGColor];
        [menuViewBackground.layer setShadowOffset:CGSizeMake(-4 / CP_GLOBALSCALE, 5 / CP_GLOBALSCALE)];
        [menuViewBackground.layer setShadowRadius:5 / CP_GLOBALSCALE];
        [menuViewBackground.layer setShadowOpacity:0.2];
        [_rightMenuView addSubview:menuViewBackground];
        UIButton *redMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [redMenuButton setBackgroundImage:[UIImage imageNamed:@"ic_drawer"] forState:UIControlStateNormal];
        [redMenuButton setFrame:CGRectMake(-redButtonW + 80 / CP_GLOBALSCALE, 16 / CP_GLOBALSCALE, 115 / CP_GLOBALSCALE, 90 / CP_GLOBALSCALE)];
        [_rightMenuView addSubview:redMenuButton];
        self.redMenuButton = redMenuButton;
        CPEditResumeRightMenuButton *baseInfoBtn = [[CPEditResumeRightMenuButton alloc] init];
        [baseInfoBtn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        [baseInfoBtn configWithTitel:@"基本信息" imageName:@"resume_info"];
        [menuViewBackground addSubview:baseInfoBtn];
        [baseInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( menuViewBackground.mas_top ).offset( 32 / CP_GLOBALSCALE);
            make.left.equalTo( menuViewBackground.mas_left );
            make.right.equalTo( menuViewBackground.mas_right );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
        __weak typeof( self ) weakSelf = self;
        [baseInfoBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(0, self.resumeInformationView.viewY) animated:YES];
            [weakSelf hideRightMenu];
            [MobClick event:@"slid_to_base_info"];
        }];
        UIView *firstSeparatorLine = [[UIView alloc] init];
        [firstSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3ed"]];
        [menuViewBackground addSubview:firstSeparatorLine];
        [firstSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( baseInfoBtn.mas_bottom );
            make.left.equalTo( menuViewBackground.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @(2 / CP_GLOBALSCALE) );
            make.right.equalTo( menuViewBackground.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        CPEditResumeRightMenuButton *expectWorkBtn = [[CPEditResumeRightMenuButton alloc] init];
        [expectWorkBtn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        [expectWorkBtn configWithTitel:@"期望工作" imageName:@"resume_expection"];
        [menuViewBackground addSubview:expectWorkBtn];
        [expectWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( firstSeparatorLine.mas_bottom );
            make.left.equalTo( menuViewBackground.mas_left );
            make.right.equalTo( menuViewBackground.mas_right );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
        [expectWorkBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(0, self.resumeExpectWorkView.viewY) animated:YES];
            [weakSelf hideRightMenu];
            [MobClick event:@"slid_to_expect_work"];
        }];
        UIView *secondSeparatorLine = [[UIView alloc] init];
        [secondSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3ed"]];
        [menuViewBackground addSubview:secondSeparatorLine];
        [secondSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( expectWorkBtn.mas_bottom );
            make.left.equalTo( menuViewBackground.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @(2 / CP_GLOBALSCALE) );
            make.right.equalTo( menuViewBackground.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        CPEditResumeRightMenuButton *workExperienceBtn = [[CPEditResumeRightMenuButton alloc] init];
        [workExperienceBtn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        [workExperienceBtn configWithTitel:@"工作经历" imageName:@"resume_experience"];
        [menuViewBackground addSubview:workExperienceBtn];
        [workExperienceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( secondSeparatorLine.mas_bottom );
            make.left.equalTo( menuViewBackground.mas_left );
            make.right.equalTo( menuViewBackground.mas_right );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
        [workExperienceBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(0, self.resumeWorkExperienceView.viewY) animated:YES];
            [weakSelf hideRightMenu];
            [MobClick event:@"slid_to_work_experience"];
        }];
        UIView *thirdSeparatorLine = [[UIView alloc] init];
        [thirdSeparatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3ed"]];
        [menuViewBackground addSubview:thirdSeparatorLine];
        [thirdSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( workExperienceBtn.mas_bottom );
            make.left.equalTo( menuViewBackground.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @(2 / CP_GLOBALSCALE) );
            make.right.equalTo( menuViewBackground.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
        CPEditResumeRightMenuButton *educationExperienceBtn = [[CPEditResumeRightMenuButton alloc] init];
        [educationExperienceBtn setTitleColor:[UIColor colorWithHexString:@"404040"] forState:UIControlStateNormal];
        [educationExperienceBtn configWithTitel:@"教育经历" imageName:@"resume_education"];
        [menuViewBackground addSubview:educationExperienceBtn];
        [educationExperienceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( thirdSeparatorLine.mas_bottom );
            make.left.equalTo( menuViewBackground.mas_left );
            make.right.equalTo( menuViewBackground.mas_right );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
        [educationExperienceBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( weakSelf.resumeEducationView.viewY < kScreenHeight )
                return;
            [weakSelf.backgroundScrollView setContentOffset:CGPointMake(0, self.resumeEducationView.viewY) animated:YES];
            [weakSelf hideRightMenu];
            [MobClick event:@"slid_to_education"];
        }];
    }
    return _rightMenuView;
}
- (void)shomMessageTips:(NSString *)tips buttonTitleArray:(NSArray *)buttonTitleArray
{
    self.tipsView = [self messageTipsViewWithTips:tips buttonTitleArray:buttonTitleArray];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    self.tipsView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips buttonTitleArray:(NSArray *)buttonTitleArray
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:buttonTitleArray showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
- (UIButton *)checkTestReportButton
{
    if ( !_checkTestReportButton )
    {
        _checkTestReportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40 / CP_GLOBALSCALE * 2.0, 144 / CP_GLOBALSCALE)];
        UIImage *n = [UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0 width:kScreenWidth - 40 / CP_GLOBALSCALE * 2 height:144 / CP_GLOBALSCALE];
        UIImage *h = [UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0 width:kScreenWidth - 40 / CP_GLOBALSCALE * 2 height:144 / CP_GLOBALSCALE];
        [_checkTestReportButton setBackgroundImage:n forState:UIControlStateNormal];
        [_checkTestReportButton setBackgroundImage:h forState:UIControlStateHighlighted];
        [_checkTestReportButton setTitle:@"查看极速测评报告" forState:UIControlStateNormal];
        [_checkTestReportButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_checkTestReportButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_checkTestReportButton.layer setMasksToBounds:YES];
        [_checkTestReportButton setHidden:YES];
        [_checkTestReportButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            DynamicExamModelDTO *model = [DynamicExamModelDTO beanFromDictionary:self.viewModel.reportDatas[0]];
            if([model.ReportUrl rangeOfString:@"?"].location == NSNotFound)
            {
                model.ReportUrl = [model.ReportUrl stringByAppendingString:@"?isPreview=1"];
            }
            else
            {
                model.ReportUrl = [model.ReportUrl stringByAppendingString:@"&isPreview=1"];
            }
            DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:model.ReportUrl examDetail:examDetailOther];;
            vc.strTitle = model.Title;
            vc.title = model.Title;
            vc.isJiSuCepin = YES;
            vc.strTitle = model.Title;
            vc.urlPath = model.ExamUrl;
            vc.urlLogo = model.ImgFilePath;
            vc.contentText = model.Introduction;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _checkTestReportButton;
}
- (UIButton *)deliveryButton
{
    if ( !_deliveryButton )
    {
        _deliveryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - 144 / CP_GLOBALSCALE, kScreenWidth, 144 / CP_GLOBALSCALE)];
        [_deliveryButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"6cbb56"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_deliveryButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ea34b"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_deliveryButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        [_deliveryButton setTitle:@"完善并可投递" forState:UIControlStateNormal];
        [_deliveryButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_deliveryButton setHidden:YES];
        __weak typeof( self ) weakSelf = self;
        [_deliveryButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [MobClick event:@"perfect_and_send_resume"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if ( [weakSelf.socialResumeEditDelegate respondsToSelector:@selector(socialResumeEdit:deliveryResume:)] )
            {
                [weakSelf.socialResumeEditDelegate socialResumeEdit:weakSelf deliveryResume:weakSelf.viewModel.resumeNameModel];
            }
        }];
    }
    return _deliveryButton;
}
- (UIView *)maxSelecetdTipsView
{
    if ( !_maxSelecetdTipsView )
    {
        CGFloat W =  kScreenWidth - 40 / CP_GLOBALSCALE * 2.0;
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
        [titleLabel setText:@"app不支持预览图片外的文件类型"];
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
