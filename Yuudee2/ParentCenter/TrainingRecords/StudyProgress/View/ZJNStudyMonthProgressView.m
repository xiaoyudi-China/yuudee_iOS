//
//  ZJNStudyMonthProgressView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/21.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNStudyMonthProgressView.h"
#import "ZJNChartsTableViewCell.h"
#import "ZJNChartsSecondTableViewCell.h"
#import "ZJNStudyHistoryTableViewCell.h"
#import "ZJNStudyMoreView.h"
@interface ZJNStudyMonthProgressView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,assign)StudyProgressViewType viewType;
@property (nonatomic ,strong)ZJNStudyMoreView *moreView;
@property (nonatomic ,strong)NSMutableArray *dayXArr;
@property (nonatomic ,strong)NSMutableArray *dayDotArr;
@end
@implementation ZJNStudyMonthProgressView
-(instancetype)initWithStudyType:(StudyProgressViewType)viewType{
    self = [super init];
    if (self) {
        self.viewType = viewType;
        _dayXArr = [NSMutableArray array];
        _dayDotArr = [NSMutableArray array];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
-(ZJNStudyMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[ZJNStudyMoreView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenHeight())];
    }
    return _moreView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
    }
    return _tableView;
}

#pragma mark-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.viewType == StudyDayProgressView) {
        return self.dayModel.resultList.count;
    }else if (self.viewType == StudyWeekProgressView){
        return self.weekModel.resultList.count;
    }else{
        return self.monthModel.resultList.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.viewType == StudyDayProgressView) {
        DayListModel *model = self.dayModel.resultList[section];
        NSInteger count = model.dayResultList.count;
        if (count == 0) {
            return 0;
        }
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScreenAdapter(25);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.viewType == StudyDayProgressView) {
            DayListModel *model = self.dayModel.resultList[indexPath.section];
            NSInteger count = model.dayResultList.count>5?5:model.dayResultList.count;
            return ScreenAdapter(30*count);
        }
        return ScreenAdapter(150);
    }else{
        if (self.viewType == StudyDayProgressView) {
            return ScreenAdapter(150);
        }
        return ScreenAdapter(170);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenAdapter(30))];
    UILabel *titleLabel = [UILabel createLabelWithTitle:@"" textColor:HexColor(textColor()) font:FontSize(13) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(ScreenAdapter(40));
        make.bottom.equalTo(bgView);
        
    }];
    UIView *dotView = [[UIView alloc]init];
    dotView.backgroundColor = HexColor(textColor());
    dotView.layer.cornerRadius = 2.5;
    dotView.layer.masksToBounds = YES;
    [bgView addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(titleLabel.mas_left).offset(-ScreenAdapter(10));
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(5), ScreenAdapter(5)));
    }];
    if (self.viewType == StudyMonthProgressView) {
        //月
        MonthList *monthL = self.monthModel.resultList[section];
        titleLabel.text = [NSString stringWithFormat:@"%@月",monthL.month];
    }else if (self.viewType == StudyWeekProgressView){
        //周
        if (section == 0) {
            titleLabel.text = @"最近一周";
        }else{
            ResultListModel *model = self.weekModel.resultList[section];
            titleLabel.text = [NSString stringWithFormat:@"%@-%@",[NSString timeStampToString:[model.weekFirstDay integerValue]],[NSString timeStampToString:[model.weekLastDay integerValue]]];
        }
        
    }else{
        //日
        DayListModel *model = self.dayModel.resultList[section];
        CGFloat studyTime = [model.studyTime floatValue];
        NSString *mTime = [NSString stringWithFormat:@"%.2f",studyTime/60.0];
        titleLabel.text = [NSString stringWithFormat:@"%@（学习时间%@分钟）",[NSString changeDateWithDateStr:[model.time integerValue]],mTime];
    }
    return bgView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.viewType == StudyDayProgressView) {
            static NSString *cellid = @"CELLID";
            ZJNStudyHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZJNStudyHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.model = self.dayModel.resultList[indexPath.section];
            cell.getMoreInfoBlock = ^{
                self.moreView.model = self.dayModel.resultList[indexPath.section];
                [[UIApplication sharedApplication].keyWindow addSubview:self.moreView];
            };
            return cell;
        }else{
//            static NSString *cellid = @"cellID";
            NSString *cellid = [NSString stringWithFormat:@"cellid%ld-%ld",indexPath.section,indexPath.row];
            ZJNChartsSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZJNChartsSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            if (self.viewType == StudyMonthProgressView) {
                
                MonthList *monthL = self.monthModel.resultList[indexPath.section];
                NSMutableArray *dotArr;
                if (monthL.list.count==5) {
                    cell.lineChartsView.xArr = @[@"第一周",@"第二周",@"第三周",@"第四周",@"第五周"];
                    dotArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
                }else{
                    cell.lineChartsView.xArr = @[@"第一周",@"第二周",@"第三周",@"第四周"];
                    dotArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
                }
                
                for (int i = 0; i <monthL.list.count; i ++) {
                    ResultListModel *model = monthL.list[i];
                    if (model.accuracyList.count>0) {
                        AccuracyListModel *aModel = model.accuracyList[0];
                        CGFloat accurach = 100*[aModel.accuracy floatValue];
                        NSString *accStr = [NSString stringWithFormat:@"%.f",accurach];
//                        [dotArr addObject:accStr];
                        [dotArr replaceObjectAtIndex:i withObject:accStr];
                    }
                }
                cell.lineChartsView.dotArr = dotArr;
            }else{
                
                ResultListModel *model = self.weekModel.resultList[indexPath.section];
                NSMutableArray *dotArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
                for (AccuracyListModel *aModel in model.accuracyList) {
                    NSInteger interval = [NSString intervalFromStarTime:[NSString timeStampToString:[model.weekFirstDay integerValue]] toEndTime:aModel.time];
                    CGFloat accurach = 100*[aModel.accuracy floatValue];
                    NSString *accStr = [NSString stringWithFormat:@"%.f",accurach];
                    [dotArr replaceObjectAtIndex:interval withObject:accStr];
                }
                cell.lineChartsView.xArr = @[[NSString changeDateWithDateStr:[model.weekFirstDay integerValue]],@"",@"",[NSString middleDateWithWeekFirstDate:[model.weekFirstDay integerValue] lastDate:[model.weekLastDay integerValue]],@"",@"",[NSString changeDateWithDateStr:[model.weekLastDay integerValue]]];
                cell.lineChartsView.dotArr = dotArr;
            }
            cell.lineChartsView.yArr = @[@"50",@"100"];
            cell.lineChartsView.xStr = @"测试正确率/百分比";
            cell.lineChartsView.yStr = @"";
            cell.lineChartsView.dotColor = HexColor(0x00ceff);
            cell.lineChartsView.maxY = 100;
            return cell;
        }
    }else{
//        static NSString *cellid = @"cellid";
        //这里没有重用
        NSString *cellid = [NSString stringWithFormat:@"cellid%ld-%ld",indexPath.section,indexPath.row];
        ZJNChartsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNChartsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        if (self.viewType == StudyMonthProgressView) {
            
            MonthList *monthL = self.monthModel.resultList[indexPath.section];
            NSMutableArray *dotArr;
            NSMutableArray *timeArr;
            if (monthL.list.count==5) {
                cell.lineChartsView.xArr = @[@"第一周",@"第二周",@"第三周",@"第四周",@"第五周"];
                dotArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
                timeArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
            }else{
                cell.lineChartsView.xArr = @[@"第一周",@"第二周",@"第三周",@"第四周"];
                dotArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
                timeArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
            }
            CGFloat learnTime = 0.00;
            for (int i = 0; i <monthL.list.count; i ++) {
                ResultListModel *model = monthL.list[i];
                if (model.timeList.count>0) {
                    TimeListModel *tModel = model.timeList[0];
                    CGFloat time = [tModel.countTime floatValue];
                    if (time>learnTime) {
                        learnTime = time;
                    }
                    [dotArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.f",time]];
                }
            }
            //学习时长（小时）：需要取整数学习时长 所以用int类型接收
            if (learnTime>3600) {
                learnTime = learnTime/3600.0;
                cell.lineChartsView.xStr = @"学习时长/小时";
                for (int i = 0; i <dotArr.count; i ++) {
                    NSString *timeStr = dotArr[i];
                    if ([timeStr isEqualToString:@""]) {
                        continue;
                    }
                    CGFloat time = [dotArr[i] floatValue];
                    time = time/3600.0;
                    NSString *accStr = [NSString stringWithFormat:@"%.2f",time];
                    [timeArr replaceObjectAtIndex:i withObject:accStr];
                }
            }else if (learnTime>60){
                learnTime = learnTime/60.0;
                cell.lineChartsView.xStr = @"学习时长/分钟";
                for (int i = 0; i <dotArr.count; i ++) {
                    NSString *timeStr = dotArr[i];
                    if ([timeStr isEqualToString:@""]) {
                        continue;
                    }
                    CGFloat time = [dotArr[i] floatValue];
                    time = time/60.0;
                    NSString *accStr = [NSString stringWithFormat:@"%.2f",time];
                    [timeArr replaceObjectAtIndex:i withObject:accStr];
                }
            }else{
                cell.lineChartsView.xStr = @"学习时长/秒";
                timeArr = dotArr;
            }
            int maxY = ceilf(learnTime);
            /*客户要求要把y轴平均分成五份，并且不要小数*/
            int a = maxY/5;
            int b = maxY%5;
            if (b>0) {
                a += 1;
            }
            maxY = a*5;
            /**/
            CGFloat timeInteval = maxY/5.0;//x轴间隔
            NSMutableArray *tempYArr = [NSMutableArray array];
            for (int i = 1; i <= 5; i ++) {
                CGFloat x = i *timeInteval;
                [tempYArr addObject:[NSString stringWithFormat:@"%.f",x]];
            }
            cell.lineChartsView.dotArr = timeArr;
            cell.lineChartsView.yArr = tempYArr;
            cell.lineChartsView.maxY = maxY;
        }else if (self.viewType == StudyWeekProgressView){
            ResultListModel *model = self.weekModel.resultList[indexPath.section];
            NSMutableArray *dotArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
            CGFloat learnTime = 0.00;
            for (TimeListModel *tModel in model.timeList) {
                NSInteger interval = [NSString intervalFromStarTime:[NSString timeStampToString:[model.weekFirstDay integerValue]] toEndTime:tModel.time];
                CGFloat time = [tModel.countTime floatValue];
                if (time>learnTime) {
                    learnTime = time;
                }
                [dotArr replaceObjectAtIndex:interval withObject:[NSString stringWithFormat:@"%.2f",time]];
            }
            //学习时长（小时）：需要取整数学习时长 所以用int类型接收
            NSMutableArray *timeArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
            if (learnTime>3600) {
                learnTime = learnTime/3600.0;
                cell.lineChartsView.xStr = @"学习时长/小时";
                for (int i = 0; i <dotArr.count; i ++) {
                    NSString *timeStr = dotArr[i];
                    if ([timeStr isEqualToString:@""]) {
                        continue;
                    }
                    CGFloat time = [dotArr[i] floatValue];
                    time = time/3600.0;
                    NSString *accStr = [NSString stringWithFormat:@"%.2f",time];
                    [timeArr replaceObjectAtIndex:i withObject:accStr];
                }
            }else if (learnTime>60){
                learnTime = learnTime/60.0;
                cell.lineChartsView.xStr = @"学习时长/分钟";
                for (int i = 0; i <dotArr.count; i ++) {
                    NSString *timeStr = dotArr[i];
                    if ([timeStr isEqualToString:@""]) {
                        continue;
                    }
                    CGFloat time = [dotArr[i] floatValue];
                    time = time/60.0;
                    NSString *accStr = [NSString stringWithFormat:@"%.2f",time];
                    [timeArr replaceObjectAtIndex:i withObject:accStr];
                }
            }else{
                cell.lineChartsView.xStr = @"学习时长/秒";
                timeArr = dotArr;
            }
            int maxY = ceilf(learnTime);
            /*客户要求要把y轴平均分成五份，并且不要小数*/
            int a = maxY/5;
            int b = maxY%5;
            if (b>0) {
                a += 1;
            }
            maxY = a*5;
            /**/
            CGFloat timeInteval = maxY/5.0;//x轴间隔
            NSMutableArray *tempYArr = [NSMutableArray array];
            for (int i = 1; i <= 5; i ++) {
                CGFloat x = i *timeInteval;
                [tempYArr addObject:[NSString stringWithFormat:@"%.f",x]];
            }
            cell.lineChartsView.xArr = @[[NSString changeDateWithDateStr:[model.weekFirstDay integerValue]],@"",@"",[NSString middleDateWithWeekFirstDate:[model.weekFirstDay integerValue] lastDate:[model.weekLastDay integerValue]],@"",@"",[NSString changeDateWithDateStr:[model.weekLastDay integerValue]]];
            cell.lineChartsView.dotArr = timeArr;
            cell.lineChartsView.yArr = tempYArr;
            cell.lineChartsView.maxY = maxY;
        }else{
            DayListModel *model = self.dayModel.resultList[indexPath.section];
            NSMutableArray *xArr = [NSMutableArray array];
            NSMutableArray *dotArr = [NSMutableArray array];
            for (ZJNStudyModel *sModel in model.dayResultList) {
                [xArr addObject:@""];
                NSString *str = [NSString stringWithFormat:@"%.f",100*[sModel.accuracy floatValue]];
                [dotArr addObject:str];
            }
            if (xArr.count == 0) {
                [xArr addObject:@""];
            }
            cell.lineChartsView.xArr = xArr;
            cell.lineChartsView.dotArr = dotArr;
            cell.lineChartsView.yArr = @[@"50",@"100"];
            cell.lineChartsView.maxY = 100;
            cell.lineChartsView.xStr = @"测试正确率/百分比";
            cell.lineChartsView.yStr = @"训练次数/次";
        }
        
//        cell.lineChartsView.dotColor = HexColor(0xcd4744);
        cell.lineChartsView.dotColor = HexColor(0x01ceff);
        return cell;
    }
}
-(void)setDayModel:(ZJNDayHistoryModel *)dayModel{
    _dayModel = dayModel;
    [self.tableView reloadData];
}
-(void)setWeekModel:(ZJNWeekHistoryModel *)weekModel{
    _weekModel = weekModel;
    [self.tableView reloadData];
}
-(void)setMonthModel:(ZJNMonthHistoryModel *)monthModel{
    _monthModel = monthModel;
    [self.tableView reloadData];
}

- (void)testFunctionWithDayModel:(ZJNDayHistoryModel *)model{
    self.dayModel = model;
    [self tableView:self.tableView viewForHeaderInSection:0];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView cellForRowAtIndexPath:path];
    [self tableView:self.tableView heightForRowAtIndexPath:path];
}

- (void)testFunctionWithWeekModel:(ZJNWeekHistoryModel *)model{
    self.weekModel = model;
    [self tableView:self.tableView viewForHeaderInSection:0];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView cellForRowAtIndexPath:path];
    [self tableView:self.tableView heightForRowAtIndexPath:path];
}

- (void)testFunctionWithMonthModel:(ZJNMonthHistoryModel *)model{
    self.monthModel = model;
}

@end
