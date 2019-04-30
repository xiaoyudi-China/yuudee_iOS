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
    [[ZJNTool shareManager] saveToken:@"IFHmXHR3VHpOsdb5bZBQ=="];
    [self viewDidLoad];
    self.success = success;
    self.failure = failure;
    [self btnClick:nil];
    [self backBtnClick];
    [self getDataFromService];
}

-(void )testHeaderView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), 100)];
    UILabel *subTitleLabel = [UILabel createLabelWithTitle:@"问卷评估" textColor:HexColor(yellowColor()) font:FontWeight(22, UIFontWeightHeavy) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    [bgView addSubview:subTitleLabel];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.numberOfLines = 0;
    UIColor *co0 = [UIColor grayColor];
    subTitleLabel.textColor = co0;
    subTitleLabel.layer.masksToBounds = YES;
    CGFloat rad0 = 8.f;
    CGFloat borderWidth0 = 1.f;
    subTitleLabel.layer.cornerRadius = rad0;
    subTitleLabel.layer.borderWidth = borderWidth0;
    UIColor *borColor0 = [UIColor redColor];
    subTitleLabel.layer.borderColor = borColor0.CGColor;
    subTitleLabel.x = 30;
    subTitleLabel.y= 60;
    subTitleLabel.width = 320;
    subTitleLabel.height = 30;
    
    UILabel *titleLabel = [UILabel createLabelWithTitle:@"让我们一起来客观评测孩子的进步！" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentCenter numberOfLines:0];
    [bgView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    UIColor *col = [UIColor grayColor];
    titleLabel.textColor = col;
    titleLabel.layer.masksToBounds = YES;
    CGFloat rad01 = 8.f;
    CGFloat borderWidth01 = 1.f;
    titleLabel.layer.cornerRadius = rad01;
    titleLabel.layer.borderWidth = borderWidth01;
    UIColor *borColor = [UIColor redColor];
    titleLabel.layer.borderColor = borColor.CGColor;
    titleLabel.x = 30;
    titleLabel.y= 60;
    titleLabel.width = 320;
    titleLabel.height = 30;
    
    UILabel *titleLabel01 = [UILabel createLabelWithTitle:@"让我们一起来客观评测孩子的进步！" textColor:HexColor(yellowColor()) font:FontSize(14) textAlignment:NSTextAlignmentCenter numberOfLines:0];
    [bgView addSubview:titleLabel01];
    titleLabel01.textAlignment = NSTextAlignmentCenter;
    titleLabel01.numberOfLines = 0;
    UIColor *color = [UIColor grayColor];
    titleLabel01.textColor = color;
    titleLabel01.layer.masksToBounds = YES;
    CGFloat rad = 8.f;
    CGFloat borderWidth = 1.f;
    titleLabel01.layer.cornerRadius = rad;
    titleLabel01.layer.borderWidth = borderWidth;
    UIColor *borC = [UIColor redColor];
    titleLabel01.layer.borderColor = borC.CGColor;
    titleLabel01.x = 30;
    titleLabel01.y= 60;
    titleLabel01.width = 320;
    titleLabel01.height = 30;
    
    UIButton *backBtn = [UIButton itemWithTarget:self action:@selector(backBtnClick) image:@"left_button" highImage:nil];
    NSInteger tag = 101;
    backBtn.tag = tag;
    backBtn.bottom = 10;
    backBtn.top  = 11;
    backBtn.x = 10;
    backBtn.y = 101;
    UIColor *textColor = [UIColor greenColor];
    backBtn.titleLabel.textColor = textColor;
    backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    backBtn.titleLabel.numberOfLines= 0;
    backBtn.backgroundColor = [UIColor redColor];
    UIImage *img = [UIImage imageNamed:@""];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
    CGFloat radius = 19;
    imageView.layer.cornerRadius = radius;
    UIColor *imgColor = [UIColor yellowColor];
    CGFloat imgB = 1;
    imageView.layer.borderColor = imgColor.CGColor;
    imageView.layer.borderWidth = imgB;
    [bgView addSubview:backBtn];
    backBtn.x = 10;
    backBtn.y  =100;
    backBtn.width = 320;
    backBtn.height = 48;

}

- (void)testFunction{
    [self viewDidLoad];
    [self btnClick:nil];
    [self backBtnClick];
    [self testHeaderView];
}

@end
