//
//  ZJNParentCenterViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNParentCenterViewController.h"
#import "ZJNParentCenterBottomView.h"
//产品介绍
#import "ZJNIntroductionToProductsView.h"
//训练档案
#import "ZJNTrainingRecordsView.h"
//评估评测
#import "ZJNAssessmentReviewView.h"
//更多
#import "ZJNMoreView.h"
//完善儿童信息
#import "ZJNPerfectInfoViewController.h"
#import "ZJNPCTopAlertView.h"
@interface ZJNParentCenterViewController ()

@property (nonatomic ,strong)ZJNParentCenterBottomView *bottomView;
//产品介绍
@property (nonatomic ,strong)ZJNIntroductionToProductsView *introView;
//训练档案
@property (nonatomic ,strong)ZJNTrainingRecordsView *recordsView;
//评估评测
@property (nonatomic ,strong)ZJNAssessmentReviewView *reviewView;
//更多
@property (nonatomic ,strong)ZJNMoreView *moreView;
//容器View
@property (nonatomic ,strong)UIView *containerView;
//当选中训练档案是，记录下级页面
@property (nonatomic ,strong)UIView *signView;

@property (nonatomic ,strong)ZJNPCTopAlertView *topAlertView;
@end

@implementation ZJNParentCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    if ([model.IsRemind isEqualToString:@"1"]) {
        //个人信息未完善
        if (_topAlertView) {
            _topAlertView.hidden = NO;
        }else{
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.topAlertView];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_topAlertView) {
        _topAlertView.hidden = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(ScreenAdapter(100));
    }];
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.containerView addSubview:self.introView];
    [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    
    // Do any additional setup after loading the view.
}
-(void)getDataFromService{
    
}
-(ZJNPCTopAlertView *)topAlertView{
    if (!_topAlertView) {
        _topAlertView = [[ZJNPCTopAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), 105+AddNav())];
        __weak typeof(self) weakSelf = self;
        _topAlertView.leftButtonBlock = ^{
            //试用
            [weakSelf homeBtnClick];
        };
        _topAlertView.rightButtonBlock = ^{
            //完善信息
            [weakSelf goToPerfectInfo];
        };
    }
    return _topAlertView;
}
//容器View
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
}
//产品介绍
-(ZJNIntroductionToProductsView *)introView{
    if (!_introView) {
        _introView = [[ZJNIntroductionToProductsView alloc]init];
        [_introView.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _introView;
}
//训练档案
-(ZJNTrainingRecordsView *)recordsView{
    if (!_recordsView) {
        _recordsView = [[ZJNTrainingRecordsView alloc]init];
        __weak typeof(self) weakSelf = self;
        _recordsView.signViewBlock = ^(UIView *view) {
            weakSelf.signView = view;
        };
        [_recordsView.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordsView;
}
//评估评测
-(ZJNAssessmentReviewView *)reviewView{
    if (!_reviewView) {
        _reviewView = [[ZJNAssessmentReviewView alloc]init];
        [_reviewView.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reviewView;
}
//更多
-(ZJNMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[ZJNMoreView alloc]init];
        [_moreView.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreView;
}

-(ZJNParentCenterBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[ZJNParentCenterBottomView alloc]init];
        __weak typeof(self)weakSelf = self;
        _bottomView.bottomViewBlock = ^(NSInteger tag) {
            NSArray *subviews = weakSelf.containerView.subviews;
            for (UIView *view in subviews) {
                [view removeFromSuperview];
            }
            if (weakSelf.signView) {
                [weakSelf.signView removeFromSuperview];
            }
            if (tag == 0) {
                [weakSelf.containerView addSubview:weakSelf.introView];
                [weakSelf.introView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.containerView);
                }];
            }else if (tag == 1){
                [weakSelf.containerView addSubview:weakSelf.recordsView];
                [weakSelf.recordsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.containerView);
                }];
                
            }else if (tag == 2){
                [weakSelf.containerView addSubview:weakSelf.reviewView];
                [weakSelf.reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.containerView);
                }];
            }else{
                [weakSelf.containerView addSubview:weakSelf.moreView];
                [weakSelf.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.containerView);
                }];
            }
        };
    }
    return _bottomView;
}
#pragma mark-返回
-(void)homeBtnClick{
    if (_pushType == FormRegister) {
        AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = [[ZJNNavigationController alloc] initWithRootViewController:[MainVC new]];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)goToPerfectInfo{
    if (_pushType == FormRegister) {
//        AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
//        delegate.window.rootViewController = [[ZJNNavigationController alloc] initWithRootViewController:[ZJNPerfectInfoViewController new]];
        ZJNPerfectInfoViewController *viewC = [[ZJNPerfectInfoViewController alloc]init];
        [self.navigationController pushViewController:viewC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)setPushType:(PushType)pushType{
    _pushType = pushType;
}

- (void)testFunction{
    [self viewDidLoad];
    [self viewWillAppear:YES];
    self.pushType = FromHomePage;
    [self.bottomView testFunction];
    [self homeBtnClick];
    [self goToPerfectInfo];
    self.topAlertView.hidden = YES;
    [self.moreView testFunction];
    [self.recordsView testFunction];
    [self viewWillDisappear:YES];
    [self.reviewView testFunction];
}

@end
