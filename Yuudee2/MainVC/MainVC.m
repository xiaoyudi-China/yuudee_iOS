//
//  MainVC.m
//  Yuudee2
//
//  Created by GZP on 2018/9/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "MainVC.h"
#import "ZJNMainAssessmentReviewController.h"
#import "ZJNPerfectInfoViewController.h"
#import "JZCZCSVC.h"
#import "GZPTipView.h"
#import "QHWVC.h"
#import "JZFJXLVC.h"
#import "JZCZXLVC.h"
#import "DCCSVC.h"
#import "DCXLVC.h"
#import "MCYYCSVC.h"
#import "MCCSVC.h"
#import "ZJNLoginAndRegisterViewController.h"
#import "AppDelegate.h"
#import "MCXLVC.h"
#import "JZFJCSVC.h"
//#import "JPUSHService.h"
//家长中心
#import "ZJNParentCenterViewController.h"
#define imageView_W AdFloat(240)
#define imageView_H AdFloat(578)
#define imageViewGap (Screen_W-AdFloat(68+48)-(imageView_W*3))/2
@interface MainVC ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView * imageView1;
@property(nonatomic,strong)UIImageView * imageView2;
@property(nonatomic,strong)UIImageView * imageView3;
@property(nonatomic,strong)UIView * backView;
@property(nonatomic,assign)NSInteger number1;
@property(nonatomic,assign)NSInteger number2;
@property(nonatomic,strong)UITextField * resultTF;

@property(nonatomic,strong)NSMutableArray * MCTrainArr;
@property(nonatomic,strong)NSMutableArray * MCTestArr;
@property(nonatomic,strong)NSMutableArray * MCYYTestArr;
@property(nonatomic,strong)NSMutableArray * MCHelpTime;

@property(nonatomic,strong)NSMutableArray * DCTrainArr;
@property(nonatomic,strong)NSMutableArray * DCTestArr;
@property(nonatomic,strong)NSMutableArray * DCHelpTime;

@property(nonatomic,strong)NSMutableArray * JZCZTrainArr;
@property(nonatomic,strong)NSMutableArray * JZCZTestArr;
@property(nonatomic,strong)NSMutableArray * JZCZHelpTime;

@property(nonatomic,strong)NSMutableArray * JZFJTrainArr;
@property(nonatomic,strong)NSMutableArray * JZFJTestArr;
@property(nonatomic,strong)NSMutableArray * JZFJHelpTime;

@property(nonatomic,assign)NSInteger latest; //最新的通关进度
@property(nonatomic,assign)NSInteger mcNum; //名词进度
@property(nonatomic,assign)NSInteger dcNum; //动词进度
@property(nonatomic,assign)NSInteger jzczNum; //句子分组进度
@property(nonatomic,assign)NSInteger jzfjNum; //句子分解进度

@property(nonatomic,assign)NSInteger goldMC; //读取累计的金币数量
@property(nonatomic,assign)NSInteger goldDC;
@property(nonatomic,assign)NSInteger goldJZCZ;
@property(nonatomic,assign)NSInteger goldJZFJ;

@property(nonatomic)NSInteger netState; //网络状态

@property(nonatomic,assign)BOOL hasGetProgress; //判断是否请求完了答题进度
@property(nonatomic,strong)NSNumber * sentence; //标识当前句子该做那个模块了

@property(nonatomic,assign)BOOL dissVC;
//单元测试
@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@property (nonatomic, copy) NSString *testToken;

@end

@implementation MainVC

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.dissVC = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hasGetProgress = NO;
    self.dissVC = NO;
    
    [self HTTPIsComplete];
    [self HTTPProgress];
    [self HTTPMC];
    [self HTTPGold];
    
    UIImageView * headImage = (id)[self.view viewWithTag:1000];
    GZPLabel * nickName = (id)[self.view viewWithTag:2000];
    ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    NSString * imageURL = model.chilPhoto;
    if (imageURL.length == 0) {
        if ([model.chilSex isEqualToString:@"1"]) {
            headImage.image = [UIImage imageNamed:@"girl"];
        }else{
            headImage.image = [UIImage imageNamed:@"boy"];
        }
    }else{
        [headImage sd_setImageWithURL:[NSURL URLWithString:imageURL]placeholderImage:[UIImage imageNamed:@"boy"]];
    }
    NSString * nick = model.chilName;
    NSString * phone = model.phoneNumber;
    if (nick.length > 0) {
        if (nick.length > 10) {
            nickName.text = [NSString stringWithFormat:@"%@...",[nick substringToIndex:10]];
        }else{
            nickName.text = nick;
        }
    }else{
        if (phone.length == 11) {
            nickName.text = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
        }
    }
}
-(void)netWorkState
{
    __weak typeof(self)weakSelf = self;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"当前无网络...");
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gggg"];
                weakSelf.netState = 0;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"当前无网络...");
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"gggg"];
                weakSelf.netState = 0;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前4G环境...");
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"gggg"];
                weakSelf.netState = 1;
                [self HTTPProgress];
                [self HTTPMC];
                [self HTTPGold];
                [self HTTPDC];
                [self HTTPJZCZ];
                [self HTTPJZFJ];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前WIFI环境...");
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"gggg"];
                weakSelf.netState = 1;
                [self HTTPProgress];
                [self HTTPMC];
                [self HTTPGold];
                [self HTTPDC];
                [self HTTPJZCZ];
                [self HTTPJZFJ];
                break;
        }
    }];
}
#pragma mark - HTTP请求当前金币数量
-(void)HTTPGold   
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if (self.testToken.length > 0) {
        paras[@"token"] = self.testToken;
    }else {
        paras[@"token"] = [[ZJNTool shareManager]getToken];
    }
    [[YuudeeRequest shareManager] request:Post url:GetCoin paras:paras completion:^(id response, NSError *error) {
        self.goldMC = 0;
        self.goldDC = 0;
        self.goldJZCZ = 0;
        self.goldJZFJ = 0;
        if ([response[@"code"] isEqual:@200]) {
            NSArray * array = response[@"data"];
            for (NSDictionary * item in array) {
                if ([item[@"module"] isEqualToString:@"1"]) {
                    self.goldMC = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                }
                if ([item[@"module"] isEqualToString:@"2"]) {
                    self.goldDC = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                }
                if ([item[@"module"] isEqualToString:@"3"]) {
                    self.goldJZCZ = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                }
                if ([item[@"module"] isEqualToString:@"4"]) {
                    self.goldJZFJ = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                }
            }
            if (self.success) {
                self.success(response);
            }
        }else {
            if (self.failure) {
                self.failure(error);
            }
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(active) name:@"BecomeActive" object:nil];
    [self makeUI];
    [self HTTPDC];
    [self HTTPJZCZ];
    [self HTTPJZFJ];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success) name:@"Success" object:nil];
    [self netWorkState];
}
#pragma mark - 全部通关成功
//-(void)success
//{
//    GZPTipView * view = [[GZPTipView alloc] initWithFrame:self.view.bounds title:@"通关填写问卷提醒" block:^(NSInteger type, GZPTipView *view) {
//        if (type == 2){
//            ZJNMainAssessmentReviewController * vc = [ZJNMainAssessmentReviewController new];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        [view removeFromSuperview];
//    }];
//    [view show];
//}
#pragma mark - 判断是否完善了儿童信息,完成问卷调查
-(void)HTTPIsComplete
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if (self.testToken.length > 0) {
        paras[@"token"] = self.testToken;
    }else {
        paras[@"token"] = [[ZJNTool shareManager]getToken];
    }
    [[YuudeeRequest shareManager] request:Post url:IsComplete paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            if ([response[@"data"][@"IsRemind"] isEqualToString:@"1"]) { //未完善儿童信息
                GZPTipView * view = [[GZPTipView alloc] initWithFrame:self.view.bounds title:@"完善训练儿童信息" block:^(NSInteger type, GZPTipView *view) {
                    if (type == 1){
                        ZJNPerfectInfoViewController * vc = [ZJNPerfectInfoViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    [view removeFromSuperview];
                }];
                [view show];
                
            }else{ //已完善儿童信息
                if([response[@"data"][@"isRecord"] isEqualToString:@"0"]){ //没有填写过问卷
                    GZPTipView * view = [[GZPTipView alloc] initWithFrame:self.view.bounds title:@"问卷评估提醒" block:^(NSInteger type, GZPTipView *view) {
                        if (type == 2){
                            ZJNMainAssessmentReviewController * vc = [ZJNMainAssessmentReviewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        [view removeFromSuperview];
                    }];
                    [view show];
                }else{ //填写过问卷
                    if ([response[@"data"][@"pcdiIsRemind"] isEqualToString:@"1"] || [response[@"data"][@"pcdiIsRemind"] isEqualToString:@"3"] || [response[@"data"][@"abcIsRemind"] isEqualToString:@"1"] || [response[@"data"][@"abcIsRemind"] isEqualToString:@"3"]){ //需要弹框的情况
                        if ([response[@"data"][@"remindType"] isEqualToString:@"2"]) { //通关填写问卷提醒
                            GZPTipView * view = [[GZPTipView alloc] initWithFrame:self.view.bounds title:@"通关填写问卷提醒" block:^(NSInteger type, GZPTipView *view) {
                                if (type == 2){
                                    ZJNMainAssessmentReviewController * vc = [ZJNMainAssessmentReviewController new];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                                [view removeFromSuperview];
                            }];
                            [view show];
                            return ;
                        }
                        if ([response[@"data"][@"remindType"] isEqualToString:@"1"]) { //定期问卷提醒
                            GZPTipView * view = [[GZPTipView alloc] initWithFrame:self.view.bounds title:@"定期问卷评估提醒" block:^(NSInteger type, GZPTipView *view) {
                                if (type == 2){
                                    ZJNMainAssessmentReviewController * vc = [ZJNMainAssessmentReviewController new];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                                [view removeFromSuperview];
                            }];
                            [view show];
                        }
                    }
                }
            }
            if (self.success) {
                self.success(response);
            }
        }else {
            if (self.failure) {
                self.failure(error);
            }
        }
    }];
}
#pragma mark - 获取当前答题进度
-(void)HTTPProgress
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if (self.testToken.length > 0) {
        paras[@"token"] = self.testToken;
    }else {
        paras[@"token"] = [[ZJNTool shareManager]getToken];
    }
    [[YuudeeRequest shareManager] request:Post url:GetProgress paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            id data = response[@"data"];
            NSArray * groupTraining = response[@"groupTraining"];
            NSDictionary * list = response[@"list"];
            self.sentence = response[@"sentence"];
            
            [self fillLatest:(NSArray *)groupTraining andData:data andList:list];
            
            self.hasGetProgress = YES;
            NSLog(@"当前答题进度:%ld %ld %ld %ld %ld",self.latest,self.mcNum,self.dcNum,self.jzczNum,self.jzfjNum);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.latest == 100 || self.latest == 0) { //解锁名词
                    [self ImageSpring:self.imageView1];
                    [self gray2];
                    [self gray3];
                }else if(self.latest == 200){ //解锁到动词
                    [UIView animateWithDuration:1 animations:^{
                        self.imageView1.transform = CGAffineTransformMakeScale(0.85, 0.85);
                    }];
                    [self ImageSpring:self.imageView2];
                    [self light2];
                    [self gray3];
                }else{ //解锁到句子
                    [UIView animateWithDuration:1 animations:^{
                        self.imageView1.transform = CGAffineTransformMakeScale(0.85, 0.85);
                        self.imageView2.transform = CGAffineTransformMakeScale(0.85, 0.85);
                    }];
                    [self light3];
                    [self ImageSpring:self.imageView3];
                }
            });
            if (self.success) {
                self.success(response);
            }
        }else if([response[@"code"] isEqual:@209]){
            NSString * token = [[ZJNTool shareManager] getToken];
            if (token.length > 0) {
                [self showHint:@"登录过期,请重新登录"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.netState == 1 && !self.dissVC) {
                    [[ZJNFMDBManager shareManager] deleteCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
                    [[ZJNTool shareManager] logout];
//                    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                        NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
//                    } seq:0];
                    AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
                    delegate.window.rootViewController = [[ZJNNavigationController alloc] initWithRootViewController:[ZJNLoginAndRegisterViewController new]];
                }
            });
            if (self.success) {
                self.success(response);
            }
        }else {
            if (self.failure) {
                self.failure(error);
            }
        }
    }];
}
#pragma mark - HTTP句子分解
-(void)HTTPJZFJ
{
    
    [[YuudeeRequest shareManager] request:Post url:JZFJ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [self.JZFJTrainArr removeAllObjects];
            [self.JZFJTestArr removeAllObjects];
            [self.JZFJHelpTime removeAllObjects];
            for (NSDictionary * item in response[@"sentenceResolveTraining"]) {
                [self.JZFJTrainArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"cosentenceResolveTestde"]) {
                [self.JZFJTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"helptime"]) {
                [self.JZFJHelpTime insertObject:item[@"helpTime"] atIndex:[[NSString stringWithFormat:@"%@",item[@"sort"]]integerValue]-1];
            }
            if (self.success) {
                self.success(response);
            }
        }else {
            if (self.failure) {
                self.failure(error);
            }
        }
    }];
}
#pragma mark - HTTP句子成组
-(void)HTTPJZCZ
{
    [[YuudeeRequest shareManager] request:Post url:JZCZ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [self.JZCZTrainArr removeAllObjects];
            [self.JZCZTestArr removeAllObjects];
            [self.JZCZHelpTime removeAllObjects];
            for (NSDictionary * item in response[@"sentenceGroupTraining"]) {
                [self.JZCZTrainArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"sentenceGroupTest"]) {
                [self.JZCZTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"helptime"]) {
                [self.JZCZHelpTime insertObject:item[@"helpTime"] atIndex:[[NSString stringWithFormat:@"%@",item[@"sort"]]integerValue]-1];
            }
            if (self.success) {
                self.success(response);
            }
        }else {
            if (self.failure) {
                self.failure(error);
            }
        }
    }];
}
#pragma mark - HTTP动词
-(void)HTTPDC
{
    [[YuudeeRequest shareManager] request:Post url:DCKJ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [self.DCTrainArr removeAllObjects];
            [self.DCTestArr removeAllObjects];
            [self.DCHelpTime removeAllObjects];
            for (NSDictionary * item in response[@"verbTraining"]) {
                [self.DCTrainArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"verbTest"]) {
                [self.DCTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            [self.DCHelpTime addObject:[NSString stringWithFormat:@"%@",response[@"helptime"][@"helpTime"]]];
            if (self.success) {
                self.success(response);
            }
        }else {
            if (self.failure) {
                self.failure(error);
            }
        }
    }];
}
#pragma mark - HTTP名词
-(void)HTTPMC
{
    NSLog(@"token:%@",[[ZJNTool shareManager] getToken]);
    NSDictionary * paras;
    ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    if ([model.IsRemind isEqualToString:@"1"]) { //个人信息未完善
        paras = nil;
    }else{
        paras = @{@"token":[[ZJNTool shareManager] getToken]};
    }
    [[YuudeeRequest shareManager] request:Post url:MCKJ paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [self.MCTrainArr removeAllObjects];
            [self.MCTestArr removeAllObjects];
            [self.MCYYTestArr removeAllObjects];
            [self.MCHelpTime removeAllObjects];
            for (NSDictionary * item in response[@"nounTraining"]) {
                [self.MCTrainArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"nounTest"]) {
                [self.MCTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"nounSense"]) {
                [self.MCYYTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            [self.MCHelpTime addObject:[NSString stringWithFormat:@"%@",response[@"time"][@"helpTime"]]];
            if (self.success) {
                self.success(response);
            }
        }else {
            if (self.failure) {
                self.failure(error);
            }
        }
    }];
}
-(void)makeUI
{
    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    backImage.image = [UIImage imageNamed:@"home_bg"];
    [self.view addSubview:backImage];
    
    UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake(AdFloat(50), AdFloat(50) + AddNav(), AdFloat(86), AdFloat(86))];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = AdFloat(86/2);
    [headImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick)]];
    headImage.userInteractionEnabled = YES;
    headImage.tag = 1000;
    [self.view addSubview:headImage];
    
    GZPLabel * nickName = [[GZPLabel alloc] initWithFrame:CGRectMake(headImage.right + AdFloat(14), headImage.top, AdFloat(200), headImage.height)];
    [nickName fillWithText:@"" color:@"ffffff" font:AdFloat(32) aligenment:NSTextAlignmentLeft];
    nickName.tag = 2000;
    [self.view addSubview:nickName];
    
    UIImageView * rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W - AdFloat(54) - AdFloat(44), headImage.centerY - AdFloat(22), AdFloat(44), AdFloat(44))];
    rightImage.image = [UIImage imageNamed:@"home_button_right"];
    [self.view addSubview:rightImage];
    
    GZPLabel * parentsL = [[GZPLabel alloc] initWithFrame:CGRectMake(rightImage.left - AdFloat(10) - nickName.width, nickName.top, nickName.width, nickName.height)];
    [parentsL fillWithText:@"家长中心" color:@"ffffff" font:AdFloat(30) aligenment:NSTextAlignmentRight];
    [self.view addSubview:parentsL];
    
    UIButton * parentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(parentsL.left, parentsL.top, parentsL.width+rightImage.width+AdFloat(50), parentsL.height)];
    [parentsBtn addTarget:self action:@selector(parentsClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:parentsBtn];
    
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(AdFloat(68), AdFloat(338) + AddNav(), imageView_W, imageView_H)];
    _imageView1.image = [UIImage imageNamed:@"home_button1_select"];
    [self.view addSubview:_imageView1];
    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(_imageView1.left, _imageView1.top + AdFloat(60), _imageView1.width, _imageView1.height/3)];
    btn1.tag = 10;
    [btn1 addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.right + imageViewGap, AdFloat(518) + AddNav(), _imageView1.width, _imageView1.height)];
    _imageView2.image = [UIImage imageNamed:@"home_button2_select"];
    [self.view addSubview:_imageView2];
    UIButton * btn2 = [[UIButton alloc] initWithFrame:CGRectMake(_imageView2.left, _imageView2.top + AdFloat(60), _imageView2.width, _imageView2.height/3)];
    btn2.tag = 11;
    [btn2 addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView2.right + imageViewGap, AdFloat(287) + AddNav(), _imageView2.width, AdFloat(430))];
    _imageView3.image = [UIImage imageNamed:@"home_button3_select"];
    [self.view addSubview:_imageView3];
    UIButton * btn3 = [[UIButton alloc] initWithFrame:CGRectMake(_imageView3.left, _imageView3.top + AdFloat(20), _imageView3.width, _imageView3.height / 2)];
    btn3.tag = 12;
    [btn3 addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    [self move];
}
#pragma mark - 点击了三个气球图片
-(void)imageClick:(UIButton *)btn
{
#warning 单元测试
//    if (self.netState == 0) {
//        [self showHint:@"当前网络已断开"];
//        return;
//    }
    NSLog(@"是否获取到了答题进度:%d",self.hasGetProgress);
    if (!self.hasGetProgress) return;
    
    if (btn.tag == 10) { //点击了名词气球
        if (self.mcNum/10 == 1 || self.latest == 0) { //该做名词了或者没有完善儿童信息
            if (self.MCTrainArr.count == 0 || self.MCTestArr.count == 0 || self.MCHelpTime.count == 0) return;
            
            MCXLVC * vc = [MCXLVC new];
            vc.progressNum = self.mcNum%10;
            vc.helpTime = self.MCHelpTime;
            vc.trainArr = self.MCTrainArr;
            vc.testArr = self.MCTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.mcNum/10 == 2){
            if (self.MCTestArr.count == 0) return;
            
            MCCSVC * vc = [MCCSVC new];
            vc.progressNum = self.mcNum%10;
            vc.coinNumber = self.goldMC;
            vc.testArr = self.MCTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.mcNum/10 == 3){
            if (self.MCYYTestArr.count == 0) return;
            
            MCYYCSVC * vc = [MCYYCSVC new];
            vc.progressNum = self.mcNum%10;
            vc.yyTestArr = self.MCYYTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (btn.tag == 11){ //点击了动词气球
        if (self.latest < 200){
            [self showHint:@"暂未解锁"];
            return;
        }
        if (self.dcNum/10 == 1) {
            if (self.DCTrainArr.count == 0 || self.DCTestArr.count == 0 ) return;
            
            DCXLVC * vc = [DCXLVC new];
            vc.progressNum = self.dcNum%10;
            vc.helpTime = self.DCHelpTime;
            vc.trainArr = self.DCTrainArr;
            vc.testArr = self.DCTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (_dcNum/10 == 2){
            if (self.DCTestArr.count == 0 ) return;

            DCCSVC * vc = [DCCSVC new];
            vc.progressNum = self.dcNum%10;
            vc.coinNumber = self.goldDC;
            vc.testArr = self.DCTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (btn.tag == 12){ //点击了句子气球
        if (self.latest < 300){
            [self showHint:@"暂未解锁"];
            return;
        }
        if (self.latest == 300) { //通关到了句子成组
            if (self.JZCZTrainArr.count == 0 || self.JZCZTestArr.count == 0) return;
            
            if (self.jzczNum/10 == 1) {
                JZCZXLVC * vc = [JZCZXLVC new];
                vc.progressNum = self.jzczNum%10;
                vc.helpTime = self.JZCZHelpTime;
                vc.trainArr = self.JZCZTrainArr;
                vc.testArr = self.JZCZTestArr;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if (self.JZCZTestArr.count == 0) return;

                JZCZCSVC * vc = [JZCZCSVC new];
                vc.progressNum = self.jzczNum%10;
                vc.coinNumber = self.goldJZCZ;
                vc.testArr = self.JZCZTestArr;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if(self.latest == 400){ //通关到了句子分解
            if (self.jzfjNum/10 == 1) {
                if (self.JZFJTrainArr.count == 0 || self.JZFJTestArr.count == 0) return;

                JZFJXLVC * vc = [JZFJXLVC new];
                vc.progressNum = self.jzfjNum%10;
                vc.helpTime = self.JZFJHelpTime;
                vc.trainArr = self.JZFJTrainArr;
                vc.testArr = self.JZFJTestArr;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if (self.JZFJTestArr.count == 0) return;

                JZFJCSVC * vc = [JZFJCSVC new];
                vc.progressNum = self.jzfjNum%10;
                vc.coinNumber = self.goldJZFJ;
                vc.testArr = self.JZFJTestArr;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (self.latest == 500){ //已全部通关
            
            if (self.jzfjNum%10 > 0 || [self.sentence isEqual:@4]) { //句子分解有进度或者字段为4,那么直接跳转句子分解
                if (self.jzfjNum/10 == 1) {
                    if (self.JZFJTrainArr.count == 0 || self.JZFJTestArr.count == 0) return;

                    JZFJXLVC * vc = [JZFJXLVC new];
                    vc.progressNum = self.jzfjNum%10;
                    vc.helpTime = self.JZFJHelpTime;
                    vc.trainArr = self.JZFJTrainArr;
                    vc.testArr = self.JZFJTestArr;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    if (self.JZFJTestArr.count == 0) return;

                    JZFJCSVC * vc = [JZFJCSVC new];
                    vc.progressNum = self.jzfjNum%10;
                    vc.coinNumber = self.goldJZFJ;
                    vc.testArr = self.JZFJTestArr;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{ //当前句子分解没有进度,并且句子成组没有通关
                
                if (self.jzczNum/10 == 1) {
                    if (self.JZFJTrainArr.count == 0 || self.JZFJTestArr.count == 0) return;

                    JZCZXLVC * vc = [JZCZXLVC new];
                    vc.progressNum = self.jzczNum%10;
                    vc.helpTime = self.JZCZHelpTime;
                    vc.trainArr = self.JZCZTrainArr;
                    vc.testArr = self.JZCZTestArr;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    if (self.JZFJTestArr.count == 0) return;

                    JZCZCSVC * vc = [JZCZCSVC new];
                    vc.progressNum = self.jzczNum%10;
                    vc.coinNumber = self.goldJZCZ;
                    vc.testArr = self.JZCZTestArr;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}
#pragma mark - 点击了家长中心
-(void)parentsClick
{
    #warning 单元测试
//    if (self.netState == 0) {
//        [self showHint:@"当前网络已断开"];
//        return;
//    }
    _backView = [[UIView alloc] initWithFrame:self.view.frame];
    _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:_backView];
    
    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(AdFloat(50), (Screen_H - AdFloat(500)) / 2, Screen_W - AdFloat(100), AdFloat(530))];
    backImage.image = [UIImage imageNamed:@"registerer_popup_bg"];
    [_backView addSubview:backImage];
    
    GZPLabel * tip = [[GZPLabel alloc] initWithFrame:CGRectMake(backImage.left, backImage.top + AdFloat(100), backImage.width, AdFloat(40))];
    [tip fillWithText:@"请回答下列问题" color:@"c06d00" font:AdFloat(32) aligenment:NSTextAlignmentCenter];
    [_backView addSubview:tip];
    
    UIImageView * chaImage = [[UIImageView alloc] initWithFrame:CGRectMake(backImage.right - AdFloat(26+60), backImage.top + AdFloat(90), AdFloat(60), AdFloat(60))];
    chaImage.image = [UIImage imageNamed:@"sign_button_close"];
    [chaImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chaClick)]];
    chaImage.userInteractionEnabled = YES;
    [_backView addSubview:chaImage];
    
    CGFloat labelWH = AdFloat(60);
    CGFloat labelGap = AdFloat(0);
    _number1 = arc4random()%16;
    _number2 = arc4random()%16;
    _number1 = (_number1<5) ? 5 : _number1;
    _number2 = (_number2<5) ? 5 : _number2;
    NSArray * array = @[[NSString stringWithFormat:@"%ld",(long)_number1],@"X",[NSString stringWithFormat:@"%ld",(long)_number2],@"=",@"?"];
    for (int i = 0; i < 5; i ++) {
        GZPLabel * label = [[GZPLabel alloc] initWithFrame:CGRectMake(backImage.left + (backImage.width-((labelWH+labelGap)*5-labelGap))/2 + (labelWH+labelGap)*i, tip.bottom + AdFloat(30), labelWH, labelWH)];
        [label fillWithText:array[i] color:@"6f4c28" font:AdFloat(48) aligenment:NSTextAlignmentCenter];
        if (i == 1) {
            label.font = [UIFont systemFontOfSize:AdFloat(32)];
        }
        [_backView addSubview:label];
    }
    
    _resultTF = [[UITextField alloc] initWithFrame:CGRectMake(backImage.left + (backImage.width-AdFloat(430))/2, tip.bottom+AdFloat(30)+labelWH+AdFloat(10), AdFloat(430), AdFloat(86))];
    _resultTF.placeholder = @"请输入答案";
    [_resultTF setValue:[@"c06d00" hexStringToColor] forKeyPath:@"_placeholderLabel.textColor"];
    _resultTF.font = [UIFont systemFontOfSize:AdFloat(28)];
    _resultTF.textColor = [@"c06d00" hexStringToColor];
    _resultTF.tintColor = [@"c06d00" hexStringToColor];
    _resultTF.keyboardType = UIKeyboardTypeNumberPad;
    _resultTF.layer.masksToBounds = YES;
    _resultTF.layer.cornerRadius = AdFloat(43);
    _resultTF.layer.borderWidth = 0.5f;
    _resultTF.layer.borderColor = [@"c06d00" hexStringToColor].CGColor;
    _resultTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AdFloat(40), AdFloat(86))];
    _resultTF.leftViewMode = UITextFieldViewModeAlways;
    _resultTF.backgroundColor = [@"ffffff" hexStringToColor];
    [_resultTF addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    _resultTF.delegate = self;
    [_backView addSubview:_resultTF];
    
    UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(backImage.left + (backImage.width-AdFloat(220))/2, _resultTF.bottom + AdFloat(30), AdFloat(220), AdFloat(80))];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"home_button_bg"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[@"ffffff" hexStringToColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AdFloat(32)];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [_backView addSubview:sureBtn];
}
#pragma mark - 点击了算数题确定
-(void)sureClick
{
    if ([_resultTF.text isEqualToString:[NSString stringWithFormat:@"%ld",_number1*_number2]]) {
        ZJNParentCenterViewController *viewC = [[ZJNParentCenterViewController alloc]init];
        [self.navigationController pushViewController:viewC animated:YES];
    }else{
        [self showHint:@"输入错误"];
    }
    [_backView removeFromSuperview];
}
#pragma mark - 限制胡乱输入算数答案
-(void)valueChanged:(UITextField *)TF
{
    if (TF.text.length > 3) {
        TF.text = [TF.text substringToIndex:3];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0) {
        unichar num = [string characterAtIndex:0];
        if (num < 48 || num > 57) {
            return NO;
        }
    }
    return YES;
}
-(void)chaClick
{
    [_backView removeFromSuperview];
}
#pragma mark - 气球上漂动画
-(void)move
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 2;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-(imageView_W/3*2), Screen_H)];
    animation.toValue = [NSValue valueWithCGPoint:_imageView1.layer.position];
    [_imageView1.layer addAnimation:animation forKey:@"move1"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.beginTime = CACurrentMediaTime() + 0.5;
    animation2.duration = 2.5;
    animation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(-((imageView_W/3*2)+imageViewGap), Screen_H + AdFloat(518-338))];
    animation2.toValue = [NSValue valueWithCGPoint:_imageView2.layer.position];
    [_imageView2.layer addAnimation:animation2 forKey:@"move2"];
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"position"];
    animation3.beginTime = CACurrentMediaTime();
    animation3.duration = 3;
    animation3.fromValue = [NSValue valueWithCGPoint:CGPointMake(-((imageView_W/3*2)+imageViewGap), Screen_H + AdFloat(518-338))];
    animation3.toValue = [NSValue valueWithCGPoint:_imageView3.layer.position];
    [_imageView3.layer addAnimation:animation3 forKey:@"move3"];
}

#pragma mark - 气球上下飘动
- (void)ImageSpring:(UIImageView *)image
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.duration = 2;
    animation.values = @[@(0),@(-10),@(0)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = MAXFLOAT;
    [image.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}
#pragma mark - 气球置灰
-(void)gray2
{
    [UIView transitionWithView:self.imageView2 duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.imageView2.image = [UIImage imageNamed:@"home_button2_no"];
    } completion:nil];
}
-(void)light2
{
    self.imageView2.image = [UIImage imageNamed:@"home_button2_select"];
}
-(void)gray3
{
    [UIView transitionWithView:self.imageView3 duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.imageView3.image = [UIImage imageNamed:@"home_button3_no"];
    } completion:nil];
}
-(void)light3
{
    self.imageView3.image = [UIImage imageNamed:@"home_button3_select"];
}
#pragma mark - 点击了用户头像
-(void)headClick
{
    
}
-(NSMutableArray *)MCHelpTime
{
    if (_MCHelpTime == nil) {
        _MCHelpTime = [NSMutableArray array];
    }
    return _MCHelpTime;
}
-(NSMutableArray *)MCTrainArr
{
    if (_MCTrainArr == nil) {
        _MCTrainArr = [NSMutableArray array];
    }
    return _MCTrainArr;
}
-(NSMutableArray *)MCTestArr
{
    if (_MCTestArr == nil) {
        _MCTestArr = [NSMutableArray array];
    }
    return _MCTestArr;
}
-(NSMutableArray *)MCYYTestArr
{
    if (_MCYYTestArr == nil) {
        _MCYYTestArr = [NSMutableArray array];
    }
    return _MCYYTestArr;
}
-(NSMutableArray *)DCHelpTime
{
    if (_DCHelpTime == nil) {
        _DCHelpTime = [NSMutableArray array];
    }
    return _DCHelpTime;
}
-(NSMutableArray *)DCTrainArr
{
    if (_DCTrainArr == nil) {
        _DCTrainArr = [NSMutableArray array];
    }
    return _DCTrainArr;
}
-(NSMutableArray *)DCTestArr
{
    if (_DCTestArr == nil) {
        _DCTestArr = [NSMutableArray array];
    }
    return _DCTestArr;
}
-(NSMutableArray *)JZCZTrainArr
{
    if (_JZCZTrainArr == nil) {
        _JZCZTrainArr = [NSMutableArray array];
    }
    return _JZCZTrainArr;
}
-(NSMutableArray *)JZCZTestArr
{
    if (_JZCZTestArr == nil) {
        _JZCZTestArr = [NSMutableArray array];
    }
    return _JZCZTestArr;
}
-(NSMutableArray *)JZCZHelpTime
{
    if (_JZCZHelpTime == nil) {
        _JZCZHelpTime = [NSMutableArray array];
    }
    return _JZCZHelpTime;
}
-(NSMutableArray *)JZFJHelpTime
{
    if (_JZFJHelpTime == nil) {
        _JZFJHelpTime = [NSMutableArray array];
    }
    return _JZFJHelpTime;
}
-(NSMutableArray *)JZFJTrainArr
{
    if (_JZFJTrainArr == nil) {
        _JZFJTrainArr = [NSMutableArray array];
    }
    return _JZFJTrainArr;
}
-(NSMutableArray *)JZFJTestArr
{
    if (_JZFJTestArr == nil) {
        _JZFJTestArr = [NSMutableArray array];
    }
    return _JZFJTestArr;
}
#pragma mark - 获取当前通关进度和小进度
-(void)fillLatest:(NSArray *)groupTraining andData:(id)data andList:(NSDictionary *)list
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"mcgid"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dcgid"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"jzgid1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"jzgid2"];
    
    //data是numer类型,那么给进度直接赋值
    if ([data isKindOfClass:[NSNumber class]]) {
        self.latest = 100;
        NSString * noun = list[@"noun"];
        self.mcNum = 10*[noun integerValue];
        if (groupTraining.count > 0) {
            NSDictionary * dic = groupTraining[0];
            self.mcNum += [[NSString stringWithFormat:@"%@",dic[@"length"]]integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",dic[@"id"]] forKey:@"mcgid"];
        }
        return;
    }
    
    //模块进度
    if (![data[@"rate"] isEqual:@100]) {
        self.latest = 100*[data[@"module"] integerValue];
    }else{
        self.latest = 500;
    }
    
    //训练,测试进度
    NSString * noun = list[@"noun"];
    self.mcNum = [noun integerValue]*10;
    NSString * verb = list[@"verb"];
    self.dcNum = [verb integerValue]*10;
    NSString * group = list[@"group"];
    self.jzczNum = [group integerValue]*10;
    NSString * sentence = list[@"sentence"];
    self.jzfjNum = [sentence integerValue]*10;

    //答题小进度
    for (NSDictionary * item in groupTraining) {
        if ([item[@"module"] isEqualToString:@"1"]) {
            self.mcNum += [[NSString stringWithFormat:@"%@",item[@"length"]]integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",item[@"id"]] forKey:@"mcgid"];
        }
        if ([item[@"module"] isEqualToString:@"2"]) {
            self.dcNum += [[NSString stringWithFormat:@"%@",item[@"length"]]integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",item[@"id"]] forKey:@"dcgid"];
        }
        if ([item[@"module"] isEqualToString:@"3"]) {
            self.jzczNum += [[NSString stringWithFormat:@"%@",item[@"length"]]integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",item[@"id"]] forKey:@"jzgid1"];
        }
        if ([item[@"module"] isEqualToString:@"4"]) {
            self.jzfjNum += [[NSString stringWithFormat:@"%@",item[@"length"]]integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",item[@"id"]] forKey:@"jzgid2"];
        }
    }
}
-(void)active
{
    [self HTTPProgress];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testFunction {
    [self viewDidLoad];
    UIButton *btn1 = [self.view viewWithTag:10];
    [self imageClick:btn1];
    UIButton *btn2 = [self.view viewWithTag:11];
    [self imageClick:btn2];
    UIButton *btn3 = [self.view viewWithTag:12];
    [self imageClick:btn3];
    [self parentsClick];
}


- (void)testRequestServerToken:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure{
#warning 单元测试
//    self.success = success;
//    self.failure = failure;
//    self.testToken = token;
//    
//    [self viewDidLoad];
//    [self viewWillAppear:YES];
//
//    UIButton *btn1 = [self.view viewWithTag:10];
//    [self imageClick:btn1];
//    UIButton *btn2 = [self.view viewWithTag:11];
//    [self imageClick:btn2];
//    UIButton *btn3 = [self.view viewWithTag:12];
//    [self imageClick:btn3];
//    [self parentsClick];

}



@end
