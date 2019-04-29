//
//  ZJNTrainingRecordsView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNTrainingRecordsView.h"
#import "ZJNTrainingRecordsTableViewCell.h"
//总体通关进度
#import "ZJNTrainTotalProgressViewController.h"
//学习进度
#import "ZJNStudyProgressView.h"

#import "ZJNTotalModel.h"
@interface ZJNTrainingRecordsView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,copy)NSArray *titleArr;
@property (nonatomic ,copy)NSArray *dataArr;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,copy)NSString *isRemind;
@end
@implementation ZJNTrainingRecordsView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.isRemind = @"1";
        _titleArr = @[@"总体通关进度",@"Level1 名词短语结构学习进度",@"Level2 动词短语结构学习进度",@"Level3-1 句子结构成组学习进度",@"Level3-2 句子结构分解学习进度"];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(35));
            make.bottom.equalTo(self.topImageView).offset(-ScreenAdapter(7));
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgImageView);
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshName) name:@"refreshName" object:nil];
        [self getDataFromService];
    }
    return self;
}
-(void)getDataFromService{
    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken]};
    [[ZJNRequestManager sharedManager] postWithUrlString:Records parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            self.isRemind = @"2";
            self.dataArr = data[@"data"][@"statisticsList"];
            if (self.dataArr.count>0) {
                NSDictionary *dic = self.dataArr[4];
                if ([dic[@"rate1"] floatValue]>0) {
                    self.titleLabel.text = [NSString stringWithFormat:@"%@的训练档案",SetStr(data[@"data"][@"childName"])];
                }
            }
            [self.tableView reloadData];
        }else{
            
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:[UIColor whiteColor] font:FontWeight(16, UIFontWeightHeavy)];
        _titleLabel.text = @"训练档案";
    }
    return _titleLabel;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:SetImage(@"family_bg2")];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenAdapter(90);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    ZJNTrainingRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZJNTrainingRecordsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.titleLabel.text = self.titleArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.progressView.progressImage = SetImage(@"line_blue");
        
    }else{
        cell.progressView.progressImage = SetImage(@"line_red");
    }
    if (self.dataArr.count>0) {
        NSDictionary *dic;
        if (indexPath.row == 0) {
            dic = self.dataArr[4];
        }else{
            dic = self.dataArr[indexPath.row-1];
        }
        CGFloat rate = [dic[@"rate1"] floatValue];
        if (indexPath.row == 0) {
            cell.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",100*rate];
        }else{
            cell.progressLabel.text = [NSString stringWithFormat:@"%.f%%",100*rate];
        }
        cell.progressView.progress = rate;
    }
    [cell.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self getTotalProgress];
    }else{
        if ([self.isRemind isEqualToString:@"1"]) {
            [self.viewController showHint:@"您还没有完善儿童信息!"];
            return;
        }
        NSDictionary *dic = self.dataArr[indexPath.row-1];

        NSString *learnTime = [NSString stringWithFormat:@"%@",dic[@"learningTime"]];
        if ([SetStr(learnTime) isEqualToString:@""]||[SetStr(learnTime) isEqualToString:@"0"]) {
            [self.viewController showHint:@"学习进度暂无数据!"];
            return;
        }
        ZJNStudyProgressView *studyProgressV = [[ZJNStudyProgressView alloc]init];
        studyProgressV.frame = CGRectMake(0, 0, ScreenWidth(), ScreenHeight()-ScreenAdapter(100));
        if (indexPath.row == 1) {
            //名词短语结构学习进度
            studyProgressV.studyType = MCDYStruct;
        }else if (indexPath.row == 2){
            //动词短语结构学习进度
            studyProgressV.studyType = DCDYStruct;
        }else if (indexPath.row == 3){
            //句子结构组成学习进度
            studyProgressV.studyType = JZJGZCStruct;
        }else if (indexPath.row == 4){
            //句子结构分解学习进度
            studyProgressV.studyType = JZJGFJStruct;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:studyProgressV];
        if (self.signViewBlock) {
            self.signViewBlock(studyProgressV);
        }
    }
}
-(void)nextButtonClick:(UIButton *)button{
    ZJNTrainingRecordsTableViewCell *cell = (ZJNTrainingRecordsTableViewCell *)[button.superview superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
//    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
#pragma mark-获取总测试进度
-(void)getTotalProgress{
    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken]};
    [self.viewController showHudInView:self hint:nil];
    [[ZJNRequestManager sharedManager] postWithUrlString:TotalInfo parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            NSMutableArray *modelArr = [NSMutableArray array];
            NSArray *dataArr = data[@"data"][@"list"];
            for (NSDictionary *dic in dataArr) {
                ZJNTotalModel *model = [ZJNTotalModel yy_modelWithDictionary:dic];
                [modelArr addObject:model];
            }
            NSString *subRate = data[@"data"][@"sumRate"];
            ZJNTrainTotalProgressViewController *viewC = [[ZJNTrainTotalProgressViewController alloc]initWithModelArray:modelArr progress:[subRate floatValue]];
            [self.viewController.navigationController pushViewController:viewC animated:YES];
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
        [self.viewController hideHud];
    } failure:^(NSError *error) {
        [self.viewController showHint:ErrorInfo];
        [self.viewController hideHud];
    }];
}
-(void)refreshName{
    [self getDataFromService];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshName" object:nil];
}

- (void)testFunction{
    [self getTotalProgress];
    [self refreshName];
    [self nextButtonClick:nil];
    
    ZJNStudyProgressView *view = [[ZJNStudyProgressView alloc]init];
    view.hidden = YES;
}

@end
