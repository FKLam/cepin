//
//  ResumeSendView.m
//  cepin
//
//  Created by zhu on 15/3/24.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeSendView.h"
#import "AllResumeDataModel.h"
#import "ResumeChooseCell.h"
#import "NSString+Extension.h"

@implementation ResumeSendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        datas = [[NSMutableArray alloc]init];
//        self.backgroundColor = [UIColor blackColor];
//        self.alpha = 0.8;
    }
    return self;
}

-(void)config
{
    self.currentSelectView = 0;
    self.maskButton = [[UIButton alloc]initWithFrame:self.bounds];
    self.maskButton.backgroundColor = [UIColor blackColor];
    self.maskButton.alpha = 0.75;
    [self addSubview:self.maskButton];
    @weakify(self)
    [self.maskButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        @strongify(self)
        self.hidden = YES;
    }];
    
    
    int height = 0;
    if (datas.count>=5) {
        height = 225;
    }else if(datas.count==4){
        height = 180;
    }else if(datas.count==3){
        height = 135;
    }else if(datas.count==2){
        height = 90;
    }else if(datas.count==1){
        height = 45;
    }
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(20, self.viewCenterX+10, self.viewWidth - 40, height+30+40+20)];
    self.backView.backgroundColor = [UIColor whiteColor];
    CGPointMake(self.viewCenterX, self.viewCenterY - 40);
    [self addSubview:self.backView];
    
    chooseTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.backView.viewWidth, 30)];
    chooseTitle.text = @"选择简历";
//    chooseTitle.backgroundColor = [UIColor redColor];
//    chooseTitle.textColor = UIColorFromRGB(0x50aabb);
//    chooseTitle.alpha = 0.87;
    chooseTitle.font = [[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont];
//    chooseTitle.viewWidth = [NSString caculateTextSize:chooseTitle].width;
    chooseTitle.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:chooseTitle];
    
    //时间选择
//    dataView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, self.backView.viewWidth, 200)];
//    [self.backView addSubview:dataView];
//    dataView.delegate = self;
//    dataView.dataSource = self;
    
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.backView.viewWidth, height) style:UITableViewStylePlain];
    [self.backView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    //底部取消 确定按钮
//    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, self.backView.viewWidth/3, 40)];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    cancelButton.titleLabel.font = [[RTAPPUIHelper shareInstance]titleFont];
//    //[cancelButton setTitleColor:UIColorFromRGB(0x50aabb) forState:UIControlStateHighlighted];
//    [self.backView addSubview:cancelButton];
//    cancelButton.alpha = 0.87;
//    
//    UIButton *manager = [[UIButton alloc]initWithFrame:CGRectMake(cancelButton.viewWidth + cancelButton.viewX, cancelButton.viewY, self.backView.viewWidth/3, cancelButton.viewHeight)];
//    [manager setTitle:@"管理简历" forState:UIControlStateNormal];
//    [manager setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//     manager.titleLabel.font = [[RTAPPUIHelper shareInstance]titleFont];
//    //[cancelButton setTitleColor:UIColorFromRGB(0x50aabb) forState:UIControlStateHighlighted];
//    [self.backView addSubview:manager];
//    manager.alpha = 0.87;
    
//    self.ensureButton = [[UIButton alloc]initWithFrame:CGRectMake(self.backView.viewWidth/2-60, self.tableView.viewY+self.tableView.viewHeight, 120, 40)];
    self.ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isCanSend) {
        [self.ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        [self.ensureButton setTitle:@"请完善简历后再投递" forState:UIControlStateNormal];
    }
    [self.ensureButton setTitleColor:[[RTAPPUIHelper shareInstance] labelColorGreen] forState:UIControlStateNormal];
      self.ensureButton.titleLabel.font = [[RTAPPUIHelper shareInstance] bigTitleFont];
    //[ensureButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
//    ensureButton.alpha = 0.87;
//    self.ensureButton.viewWidth = [NSString caculateTextSize:self.ensureButton.titleLabel].width;
    self.ensureButton.viewWidth = self.backView.viewWidth;
    self.ensureButton.viewX = 0;
    self.ensureButton.viewY = CGRectGetMaxY(self.tableView.frame);
    self.ensureButton.viewHeight = 40;
    [self.backView addSubview: self.ensureButton];
    
    
    
    
//    [cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        @strongify(self)
//        self.hidden = YES;
//    }];
//    
//    [manager handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        @strongify(self)
//        self.hidden = YES;
//        if ([self.delegate respondsToSelector:@selector(clickManager)])
//        {
//            [self.delegate clickManager];
//        }
//    }];
    
    [ self.ensureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        @strongify(self)
        self.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(clickLevelEnsureButton: IsComplete:)]) {
            [self.delegate clickLevelEnsureButton:self.resumeId IsComplete:self.isCanSend];
        }
    }];

    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.ensureButton.viewY-1, self.backView.viewWidth, 1)];
    bottomLine.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
    [self.backView addSubview:bottomLine];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144.0 / 3.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:datas[indexPath.row]];
    NSString *complete = @"(不可投)";
    if (model.IsCompleteResume.intValue==1) {
        complete = @"(可投)";
    }
    cell.titleLabel.text = [[NSString alloc]initWithFormat:@"%@%@",model.ResumeName,complete];
    if (self.currentSelectView == indexPath.row) {
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    return cell;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectView = indexPath.row;
    AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:datas[indexPath.row]];
    self.resumeId = model.ResumeId;
    if (model.IsCompleteResume.intValue==1) {
        [self.ensureButton setTitle:@"确定" forState:UIControlStateNormal];
        self.isCanSend = YES;
    }else{
        [self.ensureButton setTitle:@"请完善简历后再投递" forState:UIControlStateNormal];
        self.isCanSend = NO;
    }
    [self.tableView reloadData];
    
}


-(void)setCurrentDatas:(NSMutableArray*)allDatas
{
    [datas removeAllObjects];
    [datas addObjectsFromArray:allDatas];
    
    AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:datas[0]];
    self.resumeId = model.ResumeId;
    if (model.IsCompleteResume.intValue==1) {
        self.isCanSend = YES;
    }else{
        self.isCanSend = NO;
    }
    [self config];
}

@end
