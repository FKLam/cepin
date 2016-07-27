//
//  UserInfoVC.m
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoHeadImageCell.h"
#import "RTTitleTextCell.h"
#import "FlatUIKit.h"
#import "BaseViewController+otherUI.h"
#import "VPImageCropperViewController.h"
#import "RTPhotoHelper.h"
#import "PersonalitySignatureCell.h"
#import "RTAPPUIHelper.h"
#import "UserInfoVM.h"
#import "UserInfoDTO.h"
#import "TBAppDelegate.h"
#import "RESideMenu.h"
#import "UserSignatureCell.h"
#import "SyTextView.h"
#import "UIViewController+NavicationUI.h"
#import "ModifyEmailVC.h"
#import "ModifyPhoneVC.h"
#import "REFrostedViewController.h"
#import "CPTestEnsureEditCell.h"
#import "CPCommon.h"
@interface UserInfoVC ()<UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UserInfoVM *viewModel;
@property (nonatomic, strong) UIImage  *headImage;
@property (nonatomic, assign) int      personCellHeight;
@property (nonatomic, weak) SyTextView *testView;
@property (nonatomic, assign) BOOL     isTextViewShow;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *firstHeaderView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *changeHeaderButton;
@end
@implementation UserInfoVC
-(instancetype)init
{
    if (self = [super init])
    {
        self.viewModel = [UserInfoVM new];
        self.viewModel.showMessageVC = self;
        return self;
    }
    return nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"profile_information_launch"];
    self.title = @"个人信息";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.firstHeaderView;
     @weakify(self)
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        //保存
        @strongify(self);
        [self.view endEditing:YES];
        [self.viewModel editUserInfo];
        [self.viewModel uploadUserHeadImageWithImage:self.headImage];
    }];
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode){
        @strongify(self)
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self.tableView reloadData];
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.data.PhotoUrl] placeholderImage:[UIImage imageNamed:@"portrait_edit"]];
        }
        else if (code == HUDCodeNetWork)
        {
            if ( 0 < [self.viewModel.data.Mobile length] )
            {
                [self.tableView reloadData];
                if ( self.viewModel.tempImage )
                    [self.headerImageView setImage:self.viewModel.tempImage];
                else
                    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.data.PhotoUrl] placeholderImage:[UIImage imageNamed:@"portrait_edit"]];
                self.networkImage.hidden = YES;
                self.networkLabel.hidden = YES;
                self.tableView.hidden = NO;
            }
            else
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.tableView.hidden = YES;
            }
        }
    }];
    [RACObserve(self.viewModel, editUserInfoStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self.navigationController popViewControllerAnimated:YES];
            if ( [self.userInfoVCDelegate respondsToSelector:@selector(userInfoVCDidFinishEditing)] )
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.userInfoVCDelegate userInfoVCDidFinishEditing];
                });
            }
        }
    }];
    [RACObserve(self.viewModel, updateImageStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            //存储图片，并通知主页面刷新图片
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetHeadImage" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.headImage,@"resetHeadImage", nil]];
            [self.tableView reloadData];
        }
    }];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchBlank:)];
    [self.tableView addGestureRecognizer:ges];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel userInfomation];
}
-(void)TouchBlank:(UITapGestureRecognizer*)ges
{
    if ( self.isTextViewShow )
    {
        [self.view endEditing:YES];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
        switch (indexPath.row) {
            case 0:
            {
                cell.inputTextField.text = self.viewModel.data.RealName?self.viewModel.data.RealName:@"";
                [cell configCellLeftString:@"姓     名" placeholder:@"请输入真实姓名"];
                [cell.inputTextField setDelegate:self];
                [cell.inputTextField setTag:indexPath.row];
                @weakify(self)
                [[cell.inputTextField rac_textSignal]subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( cell.inputTextField.tag != indexPath.row )
                        return;
                    self.viewModel.data.RealName = text;
                }];
            }
                break;
            case 1:
            {
                cell.inputTextField.text = self.viewModel.data.UserName?self.viewModel.data.UserName:@"";
                cell.inputTextField.userInteractionEnabled = YES;
                [cell.inputTextField setTag:indexPath.row];
                [cell.inputTextField setDelegate:self];
                [cell configCellLeftString:@"昵     称" placeholder:@"请输入昵称"];
                @weakify(self)
                [[cell.inputTextField rac_textSignal]subscribeNext:^(NSString *text) {
                    @strongify(self)
                    if ( cell.inputTextField.tag != indexPath.row )
                        return;
                    self.viewModel.data.UserName = text;
                }];
            }
                break;
            case 2:
            {
                cell.inputTextField.text = self.viewModel.data?(self.viewModel.data.Mobile):@"";
                cell.inputTextField.tag = indexPath.row;
                cell.inputTextField.userInteractionEnabled = NO;
                [cell configCellLeftString:@"手机号码" placeholder:@"请输入绑定手机" editButton:[[UIButton alloc] init]];
                [cell.editButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                    //修改手机号码
                    [self.view endEditing:YES];
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
                    ModifyPhoneVC *vc = [ModifyPhoneVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [MobClick event:@"bind_mobile"];
                }];
            }
                break;
            case 3:
            {
                cell.inputTextField.text = self.viewModel.data?(self.viewModel.data.Email):@"";
                cell.inputTextField.userInteractionEnabled = NO;
                cell.inputTextField.tag = indexPath.row;
                [cell configCellLeftString:@"常用邮箱" placeholder:@"绑定电子邮箱" editButton:[[UIButton alloc] init]];
                [cell.editButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                    //修改邮箱
                    [self.view endEditing:YES];
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
                    ModifyEmailVC *vc = [ModifyEmailVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [MobClick event:@"bind_email"];
                }];
            }
                break;
            default:
                break;
        }
    BOOL isShowAll = NO;
    if ( indexPath.row == 3 )
        isShowAll = YES;
    [cell resetSeparatorLineShowAll:isShowAll];
        return cell;
    return nil;
}
#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [self.testView textView:textView shouldChangeTextRange:range replacementText:text];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self.testView textDidChange];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    self.isTextViewShow = YES;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.isTextViewShow = NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
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
    self.headImage = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
    [self.changeHeaderButton setBackgroundImage:editedImage forState:UIControlStateNormal];
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - getter methods
- (UIView *)firstHeaderView
{
    if ( !_firstHeaderView )
    {
        _firstHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 140 + 144 ) / CP_GLOBALSCALE)];
        [_firstHeaderView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        CALayer *topBackgroundLayer = [[CALayer alloc] init];
        [topBackgroundLayer setBackgroundColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [topBackgroundLayer setFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, 140 / CP_GLOBALSCALE + kScreenHeight)];
        [_firstHeaderView.layer addSublayer:topBackgroundLayer];
        [_firstHeaderView addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo( _firstHeaderView.mas_centerX );
            make.top.equalTo( _firstHeaderView.mas_top ).offset( (140 - 180 / 2.0) / CP_GLOBALSCALE );
            make.width.equalTo( @( 180 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 180 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLineSecond = [[UIView alloc] init];
        [separatorLineSecond setBackgroundColor:[UIColor colorWithHexString:@"ede3d6"]];
        [_firstHeaderView addSubview:separatorLineSecond];
        [separatorLineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _firstHeaderView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( _firstHeaderView.mas_right );
            make.bottom.equalTo( _firstHeaderView.mas_bottom );
        }];
    }
    return _firstHeaderView;
}
- (UIImageView *)headerImageView
{
    if ( !_headerImageView )
    {
        _headerImageView = [[UIImageView alloc] init];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.data.PhotoUrl] placeholderImage:[UIImage imageNamed:@"portrait_edit"]];
        [_headerImageView.layer setCornerRadius:186 / CP_GLOBALSCALE / 2.0];
        [_headerImageView.layer setMasksToBounds:YES];
        [_headerImageView setUserInteractionEnabled:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [_headerImageView addSubview:button];
        self.changeHeaderButton = button;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _headerImageView.mas_top );
            make.left.equalTo( _headerImageView.mas_left );
            make.bottom.equalTo( _headerImageView.mas_bottom );
            make.right.equalTo( _headerImageView.mas_right );
        }];
        @weakify(self)
        [self.changeHeaderButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            @strongify(self)
            [self uploadImage];
            [MobClick event:@"upload_img_head"];
        }];
    }
    return _headerImageView;
}
@end