//
//  ZJNAssessmentReviewView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNAssessmentReviewView.h"
#import "ZJNTextTableViewCell.h"
#import "ZJNPCDIWKViewController.h"
#import "ZJNABCWKViewController.h"
#import "ZJNPerfectInfoViewController.h"
@interface ZJNAssessmentReviewView()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *infoArr;
}
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,copy)NSDictionary *infoDic;
@end
@implementation ZJNAssessmentReviewView
-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *str0 = @"语言评估量表是由父母填写的，测量16个月以上说普通话的儿童早期语言发展的评估量表。目前已在世界各地广泛使用。";
        NSString *str1 = @"通过使用本量表，可以对语言发育迟缓的儿童进行定期监控，以发现其在同龄儿童中的差异和进步。";
        NSString *str2 = @"本量表必做部分将花费您10-15分钟时间。";
        NSString *str3 = @"行为评估量表又称自闭症行为量表，是一份由他人报告的形式，用于检测儿童是否患有自闭症的一个简单的方法，只能作为一个参考诊断依据，并不能单一的做为判定诊断结果的依据。";
        NSString *str4 = @"本量表有57个描述自闭症儿童的感觉、行为、情绪、语言等方面异常表现的项目，通过使用本量表，可以对自闭症儿童进行整体症状评估打分。";
        NSString *str5 = @"本量表将花费您10～15分钟时间。";
        infoArr = @[@[str0,str1,str2],@[str3,str4,str5]];
        UILabel *subTitleLabel = [UILabel createLabelWithTitle:@"让我们一起来客观评价孩子的进步！" textColor:[UIColor whiteColor] font:FontSize(12) textAlignment:NSTextAlignmentLeft numberOfLines:1];
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topImageView).offset(-4);
            make.left.equalTo(self).offset(ScreenAdapter(15));
        }];
        
        UILabel *titleLabel = [UILabel createLabelWithTitle:@"问卷评估" textColor:[UIColor whiteColor] font:FontWeight(16, UIFontWeightHeavy) textAlignment:NSTextAlignmentLeft numberOfLines:1];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(15));
            make.bottom.equalTo(subTitleLabel.mas_top).offset(-4);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgImageView);
        }];
        [self getDataFromService];
    }
    return self;
}
-(void)getDataFromService{
    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken]};
    [[ZJNRequestManager sharedManager] postWithUrlString:ToAssess parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"%@",data);
            self.infoDic = data[@"data"];
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.viewController showHint:ErrorInfo];
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
    }
    return _tableView;
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
    if (section == 0) {
        btnTitle = @"语言评估问卷";
    }else{
        btnTitle = @"行为评估问卷";
    }
    UIButton *btn = [UIButton itemWithTitle:btnTitle titleColor:[UIColor whiteColor] font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(btnClick:)];
    btn.tag = 10+section;
    [btn setBackgroundImage:SetImage(@"button") forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
//    btn.userInteractionEnabled = NO;
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
        [self.viewController showHint:@"完善儿童信息后,继续做问卷"];
        ZJNPerfectInfoViewController *viewC = [[ZJNPerfectInfoViewController alloc]init];
        [self.viewController.navigationController pushViewController:viewC animated:YES];
        return;
    }else{
        NSLog(@"已完善儿童信息");
    }
    if (button.tag == 10) {
        //PCDI问卷
        ZJNPCDIWKViewController *viewC = [[ZJNPCDIWKViewController alloc]init];
        __weak typeof(self) weakSelf = self;
        viewC.pcdiRefreshBlock = ^{
            [weakSelf getDataFromService];
        };
        viewC.status = self.infoDic[@"pcdiIsRemind"];
        [self.viewController.navigationController pushViewController:viewC animated:YES];
    }else{
        //ABC问卷
        ZJNABCWKViewController *viewC = [[ZJNABCWKViewController alloc]init];
        __weak typeof(self) weakSelf = self;
        viewC.abcRefreshBlock = ^{
            [weakSelf getDataFromService];
        };
        viewC.status = self.infoDic[@"abcIsRemind"];
        [self.viewController.navigationController pushViewController:viewC animated:YES];
    }
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
    UIButton *btn = [[UIButton alloc]init];
    [self btnClick:btn];
    NSString *str0 = @"语言评估量表是由父母填写的，测量16个月以上说普通话的儿童早期语言发展的评估量表。目前已在世界各地广泛使用。";
    NSString *str1 = @"通过使用本量表，可以对语言发育迟缓的儿童进行定期监控，以发现其在同龄儿童中的差异和进步。";
    NSString *str2 = @"本量表必做部分将花费您10-15分钟时间。";
    NSString *str3 = @"行为评估量表又称自闭症行为量表，是一份由他人报告的形式，用于检测儿童是否患有自闭症的一个简单的方法，只能作为一个参考诊断依据，并不能单一的做为判定诊断结果的依据。";
    NSString *str4 = @"本量表有57个描述自闭症儿童的感觉、行为、情绪、语言等方面异常表现的项目，通过使用本量表，可以对自闭症儿童进行整体症状评估打分。";
    NSString *str5 = @"本量表将花费您10～15分钟时间。";
     infoArr = @[@[str0,str1,str2],@[str3,str4,str5]];
    [self.tableView reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView cellForRowAtIndexPath:path];
    [self testHeaderView];
}

@end
