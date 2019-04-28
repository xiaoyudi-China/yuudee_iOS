//
//  ZJNMainAssessmentReviewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/16.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNMainAssessmentReviewController.h"
#import "ZJNTextTableViewCell.h"
#import "ZJNPCDIWKViewController.h"
#import "ZJNABCWKViewController.h"
#import "ZJNPerfectInfoViewController.h"
#import "MainVC.h"
@interface ZJNMainAssessmentReviewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *infoArr;
}
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,copy)NSDictionary *infoDic;

@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@end

@implementation ZJNMainAssessmentReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    infoArr = @[@[@"语言评估量表是由父母填写的，测量16个月以上说普通话的儿童早期语言发展的评估量表。目前已在世界各地广泛使用。",@"通过使用本量表，可以对语言发育迟缓的儿童进行定期监控，以发现其在同龄儿童中的差异和进步。",@"本量表必做部分将花费您10-15分钟时间。"],@[@"行为评估量表又称自闭症行为量表，是一份由他人报告的形式，用于检测儿童是否患有自闭症的一个简单的方法，只能作为一个参考诊断依据，并不能单一的做为判定诊断结果的依据。",@"本量表有57个描述自闭症儿童的感觉、行为、情绪、语言等方面异常表现的项目，通过使用本量表，可以对自闭症儿童进行整体症状评估打分。",@"本量表将花费您10～15分钟时间。"]];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self getDataFromService];
    // Do any additional setup after loading the view.
}

-(void)getDataFromService{
    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken]};
    [[ZJNRequestManager sharedManager] postWithUrlString:ToAssess parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"%@",data);
            self.infoDic = data[@"data"];
        }else{
            [self showHint:data[@"msg"]];
        }
        [self.tableView reloadData];
        if (self.success) {
            self.success(data);
        }
    } failure:^(NSError *error) {
        [self showHint:ErrorInfo];
        if (self.failure) {
            self.failure(error);
        }
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = ScreenAdapter(44);
        _tableView.backgroundView = [self bgImageView];
        _tableView.tableHeaderView = [self tableHeaderView];
    }
    return _tableView;
}
-(UIImageView *)bgImageView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenHeight())];
    imageView.image = SetImage(@"family_bg2");
    return imageView;
}
-(UIView *)tableHeaderView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), 100)];
    UILabel *subTitleLabel = [UILabel createLabelWithTitle:@"问卷评估" textColor:HexColor(yellowColor()) font:FontWeight(22, UIFontWeightHeavy) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    [bgView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(ScreenAdapter(38));
        make.centerX.equalTo(bgView);
    }];
    
    UILabel *titleLabel = [UILabel createLabelWithTitle:@"让我们一起来客观评测孩子的进步！" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentCenter numberOfLines:0];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitleLabel.mas_bottom).offset(ScreenAdapter(16));
        make.centerX.equalTo(subTitleLabel);
        
    }];
    
    UIButton *backBtn = [UIButton itemWithTarget:self action:@selector(backBtnClick) image:@"left_button" highImage:nil];
    [bgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(ScreenAdapter(10));
        make.centerY.equalTo(subTitleLabel);
        make.size.mas_equalTo(CGSizeMake(48, 51));
    }];
    return bgView;
}
#pragma mark-UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScreenAdapter(76);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenAdapter(76))];
    NSString *btnTitle;
    UIColor  *btnColor;
    BOOL canTouch;
    if (section == 0) {
        btnTitle = @"语言评估问卷";
        if ([self.infoDic[@"pcdiIsRemind"] isEqualToString:@"1"]||[self.infoDic[@"pcdiIsRemind"] isEqualToString:@"3"]) {
            btnColor = [UIColor whiteColor];
            canTouch = YES;
        }else{
            btnColor = [UIColor lightGrayColor];
            canTouch = NO;
        }
    }else{
        btnTitle = @"行为评估问卷";
        if ([self.infoDic[@"abcIsRemind"] isEqualToString:@"1"]||[self.infoDic[@"abcIsRemind"] isEqualToString:@"3"]) {
            btnColor = [UIColor whiteColor];
            canTouch = YES;
        }else{
            btnColor = [UIColor lightGrayColor];
            canTouch = NO;
        }
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:btnColor forState:UIControlStateNormal];
    btn.titleLabel.font = FontWeight(16, UIFontWeightBlack);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    btn.userInteractionEnabled = canTouch;
    btn.tag = 10+section;
    [btn setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
    [bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.centerY.equalTo(bgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(334), ScreenAdapter(56)));
    }];
    return bgView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    ZJNTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZJNTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.infoStr = infoArr[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)btnClick:(UIButton *)button{
    if ([self.infoDic[@"IsRemind"] isEqualToString:@"1"]) {
        //未完善儿童信息 去完善
        [self showHint:@"完善儿童信息后,继续做问卷"];
        ZJNPerfectInfoViewController *viewC = [[ZJNPerfectInfoViewController alloc]init];
        [self.navigationController pushViewController:viewC animated:YES];
        return;
    }else{
        NSLog(@"已完善儿童信息");
    }
    if (button.tag == 10) {
        //PCDI问卷
        ZJNPCDIWKViewController *viewC = [[ZJNPCDIWKViewController alloc]init];
        viewC.status = self.infoDic[@"pcdiIsRemind"];
        __weak typeof(self) weakSelf = self;
        viewC.pcdiRefreshBlock = ^{
            [weakSelf getDataFromService];
        };
        [self.navigationController pushViewController:viewC animated:YES];
    }else{
        //ABC问卷
        ZJNABCWKViewController *viewC = [[ZJNABCWKViewController alloc]init];
        viewC.status = self.infoDic[@"abcIsRemind"];
        __weak typeof(self) weakSelf = self;
        viewC.abcRefreshBlock = ^{
            [weakSelf getDataFromService];
        };
        [self.navigationController pushViewController:viewC animated:YES];
    }
}

-(void)backBtnClick{
    AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [[ZJNNavigationController alloc] initWithRootViewController:[MainVC new]];
}

- (void)testToAssess:(NSString *)token
             success:(void (^) (id json))success
             failure:(void (^)(NSError *error))failure{
    [self viewDidLoad];
    [self btnClick:nil];
    [self backBtnClick];
    self.success = success;
    self.failure = failure;
}

- (void)testFunction{
    [self viewDidLoad];
    [self btnClick:nil];
    [self backBtnClick];
}

@end
