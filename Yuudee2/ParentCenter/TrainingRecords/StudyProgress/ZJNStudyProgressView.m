//
//  ZJNStudyProgressView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/21.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNStudyProgressView.h"
#import "ZJNStudyMonthProgressView.h"
#import "ZJNDayHistoryModel.h"
#import "ZJNWeekHistoryModel.h"
#import "ZJNMonthHistoryModel.h"
@interface ZJNStudyProgressView()
//头像
@property (nonatomic ,strong)UIImageView *headerImageV;
//自学时间
@property (nonatomic ,strong)UILabel *minuteLabel;
//通关进度
@property (nonatomic ,strong)UILabel *progressLabel;
//日
@property (nonatomic ,strong)UIButton *dayBtn;
//周
@property (nonatomic ,strong)UIButton *weekBtn;
//月
@property (nonatomic ,strong)UIButton *monthBtn;
//容器View
@property (nonatomic ,strong)UIView *containerView;
//月通关进度
@property (nonatomic ,strong)ZJNStudyMonthProgressView *monthProView;
//周通关进度
@property (nonatomic ,strong)ZJNStudyMonthProgressView *weekProView;
//日通关进度
@property (nonatomic ,strong)ZJNStudyMonthProgressView *dayProView;
//记录当前展示的页面（日，周，月）
@property (nonatomic ,strong)ZJNStudyMonthProgressView *signProView;
//记录当前选中的btn
@property (nonatomic ,strong)UIButton *signBtn;

//日学习记录
@property (nonatomic ,strong)ZJNDayHistoryModel *dayModel;
//周学习记录
@property (nonatomic ,strong)ZJNWeekHistoryModel *weekModel;
//月学习记录
@property (nonatomic ,strong)ZJNMonthHistoryModel *monthModel;
@end
@implementation ZJNStudyProgressView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.headerImageV];
        [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).offset(ScreenAdapter(18));
            make.left.equalTo(self).offset(ScreenAdapter(17));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(48), ScreenAdapter(48)));
            
        }];
        
        [self addSubview:self.minuteLabel];
        [self.minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageV.mas_right).offset(ScreenAdapter(10));
            make.top.equalTo(self.topImageView.mas_bottom).offset(ScreenAdapter(22));
        }];
        
        [self addSubview:self.progressLabel];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.minuteLabel);
            make.top.equalTo(self.minuteLabel.mas_bottom).offset(4);
        }];
        
        [self addSubview:self.weekBtn];
        [self.weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.progressLabel.mas_bottom).offset(21);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(41), ScreenAdapter(42)));
        }];
        
        [self addSubview:self.dayBtn];
        [self.dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.weekBtn);
            make.right.equalTo(self.weekBtn.mas_left).offset(-ScreenAdapter(88));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(41), ScreenAdapter(42)));
        }];
        self.signBtn = self.dayBtn;
        
        [self addSubview:self.monthBtn];
        [self.monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.weekBtn);
            make.left.equalTo(self.weekBtn.mas_right).offset(ScreenAdapter(88));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(41), ScreenAdapter(42)));
        }];
        
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.monthBtn.mas_bottom);
        }];
        
        [self addSubview:self.dayProView];
        [self.dayProView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containerView);
        }];
        self.signProView = self.dayProView;
        
        ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
        NSString * imageURL = model.chilPhoto;
        if (imageURL.length == 0) {
            if ([model.chilSex isEqualToString:@"1"]) {
                self.headerImageV.image = [UIImage imageNamed:@"girl"];
            }else{
                self.headerImageV.image = [UIImage imageNamed:@"boy"];
            }
        }else{
            [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:imageURL]placeholderImage:[UIImage imageNamed:@"boy"]];
        }
        
    }
    return self;
}
//头像
-(UIImageView *)headerImageV{
    if (!_headerImageV) {
        _headerImageV = [UIImageView itemWithImage:SetImage(@"headimage") backColor:nil Radius:ScreenAdapter(24)];
    }
    return _headerImageV;
}
//学习时间
-(UILabel *)minuteLabel{
    if (!_minuteLabel) {
        _minuteLabel = [UILabel createLabelWithTitle:@"自学了0分钟的名词短语结构" textColor:HexColor(textColor()) font:FontSize(16) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _minuteLabel;
}
//通关进度
-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [UILabel createLabelWithTitle:@"通关进度0%（单项通关）" textColor:HexColor(textColor()) font:FontSize(16) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _progressLabel;
}
//容器View
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
}
//日
-(UIButton *)dayBtn{
    if (!_dayBtn) {
        _dayBtn = [UIButton itemWithTarget:self action:@selector(dayBtnClick) image:@"day" highImage:nil];
        [_dayBtn setImage:SetImage(@"day_select") forState:UIControlStateSelected];
        _dayBtn.selected = YES;
    }
    return _dayBtn;
}
//周
-(UIButton *)weekBtn{
    if (!_weekBtn) {
        _weekBtn = [UIButton itemWithTarget:self action:@selector(weakBtnClick) image:@"week" highImage:nil];
        [_weekBtn setImage:SetImage(@"week_select") forState:UIControlStateSelected];
    }
    return _weekBtn;
}
//月
-(UIButton *)monthBtn{
    if (!_monthBtn) {
        _monthBtn = [UIButton itemWithTarget:self action:@selector(monthBtnClick) image:@"month" highImage:nil];
        [_monthBtn setImage:SetImage(@"month_select") forState:UIControlStateSelected];
    }
    return _monthBtn;
}
//月进度
-(ZJNStudyMonthProgressView *)monthProView{
    if (!_monthProView) {
        _monthProView = [[ZJNStudyMonthProgressView alloc]initWithStudyType:StudyMonthProgressView];
    }
    return _monthProView;
}
//周进度
-(ZJNStudyMonthProgressView *)weekProView{
    if (!_weekProView) {
        _weekProView = [[ZJNStudyMonthProgressView alloc]initWithStudyType:StudyWeekProgressView];
    }
    return _weekProView;
}
//日进度
-(ZJNStudyMonthProgressView *)dayProView{
    if (!_dayProView) {
        _dayProView = [[ZJNStudyMonthProgressView alloc]initWithStudyType:StudyDayProgressView];
    }
    return _dayProView;
}
-(void)homeBtnClick{
    [self removeFromSuperview];
}

-(void)dayBtnClick{
    if (self.signBtn == self.dayBtn) {
        return;
    }
    self.signBtn.selected = NO;
    self.dayBtn.selected = YES;
    self.signBtn = self.dayBtn;
    [self.signProView removeFromSuperview];
    [self addSubview:self.dayProView];
    [self.dayProView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    self.signProView = self.dayProView;
}

-(void)weakBtnClick{
    if (self.signBtn == self.weekBtn) {
        return;
    }
    self.signBtn.selected = NO;
    self.weekBtn.selected = YES;
    self.signBtn = self.weekBtn;
    [self.signProView removeFromSuperview];
    [self addSubview:self.weekProView];
    [self.weekProView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    self.signProView = self.weekProView;
}

-(void)monthBtnClick{
    if (self.signBtn == self.monthBtn) {
        return;
    }
    self.signBtn.selected = NO;
    self.monthBtn.selected = YES;
    self.signBtn = self.monthBtn;
    [self.signProView removeFromSuperview];
    [self addSubview:self.monthProView];
    [self.monthProView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    self.signProView = self.monthProView;
}

-(void)setStudyType:(StudyType)studyType{
    _studyType = studyType;
    [self dayStudyHistory];
    [self weekStudyHistory];
    [self monthStudyHistory];
    NSLog(@"___%ld",(long)studyType);
}

-(void)dayStudyHistory{
    NSString *module = [NSString stringWithFormat:@"%ld",(long)self.studyType+1];
    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken],@"module":module,@"scene":@"2"};
    [[ZJNRequestManager sharedManager] postWithUrlString:DayInfo parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            self.dayModel = [ZJNDayHistoryModel yy_modelWithJSON:data[@"data"]];
            NSMutableArray *resultListArr = [NSMutableArray array];
            [self.dayModel.resultList enumerateObjectsUsingBlock:^(DayListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DayListModel *model = [DayListModel yy_modelWithJSON:obj];
                NSMutableArray *dayResultListArr = [NSMutableArray array];
                [model.dayResultList enumerateObjectsUsingBlock:^(ZJNStudyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZJNStudyModel *sModel = [ZJNStudyModel yy_modelWithJSON:obj];
                    [dayResultListArr addObject:sModel];
                }];
                model.dayResultList = [dayResultListArr copy];
                [resultListArr addObject:model];
            }];
            self.dayModel.resultList = [resultListArr copy];
            self.dayProView.dayModel = self.dayModel;
            [self showDayTitle];
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)weekStudyHistory{
    NSString *module = [NSString stringWithFormat:@"%ld",self.studyType+1];
    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken],@"module":module,@"scene":@"2"};
    [[ZJNRequestManager sharedManager] postWithUrlString:WeekInfo parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]){
            self.weekModel = [ZJNWeekHistoryModel yy_modelWithJSON:data[@"data"]];
            NSMutableArray *resultListArr = [NSMutableArray array];
            [self.weekModel.resultList enumerateObjectsUsingBlock:^(ResultListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ResultListModel *model = [ResultListModel yy_modelWithJSON:obj];
                NSMutableArray *accArr = [NSMutableArray array];
                NSMutableArray *timeArr = [NSMutableArray array];
                [model.accuracyList enumerateObjectsUsingBlock:^(AccuracyListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    AccuracyListModel *aModel = [AccuracyListModel yy_modelWithJSON:obj];
                    [accArr addObject:aModel];
                }];
                [model.timeList enumerateObjectsUsingBlock:^(TimeListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TimeListModel *tModel = [TimeListModel yy_modelWithJSON:obj];
                    [timeArr addObject:tModel];
                }];
                model.accuracyList = accArr;
                model.timeList = timeArr;
                [resultListArr addObject:model];
            }];
            self.weekModel.resultList = resultListArr;
            self.weekProView.weekModel = self.weekModel;
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}
-(void)monthStudyHistory{
    NSString *module = [NSString stringWithFormat:@"%ld",self.studyType+1];
    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken],@"module":module,@"scene":@"2"};
    [[ZJNRequestManager sharedManager] postWithUrlString:MonthInfo parameters:dic success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]){
            self.monthModel = [ZJNMonthHistoryModel yy_modelWithJSON:data[@"data"]];
            NSMutableArray *arrArr = [NSMutableArray array];
            [self.monthModel.resultList enumerateObjectsUsingBlock:^(MonthList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MonthList *mList = [MonthList yy_modelWithJSON:obj];
                NSMutableArray *lArr = [NSMutableArray array];
                [mList.list enumerateObjectsUsingBlock:^(ResultListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ResultListModel *model = [ResultListModel yy_modelWithJSON:obj];
                    NSMutableArray *accArr = [NSMutableArray array];
                    NSMutableArray *timeArr = [NSMutableArray array];
                    [model.accuracyList enumerateObjectsUsingBlock:^(AccuracyListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        AccuracyListModel *aModel = [AccuracyListModel yy_modelWithJSON:obj];
                        [accArr addObject:aModel];
                    }];
                    [model.timeList enumerateObjectsUsingBlock:^(TimeListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        TimeListModel *tModel = [TimeListModel yy_modelWithJSON:obj];
                        [timeArr addObject:tModel];
                    }];
                    model.accuracyList = accArr;
                    model.timeList = timeArr;
                    [lArr addObject:model];
                }];
                mList.list = [lArr copy];
                [arrArr addObject:mList];
            }];
            self.monthModel.resultList = [arrArr copy];
            self.monthProView.monthModel = self.monthModel;
            
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}

-(void)showDayTitle{
    CGFloat learnTime = [self.dayModel.countTime floatValue];
    NSString *timeStr;
    if (learnTime>3600) {
        learnTime = learnTime/3600.0;
        timeStr = [NSString stringWithFormat:@"%.2f小时",learnTime];
    }else if (learnTime>60){
        learnTime = learnTime/60.0;
        timeStr = [NSString stringWithFormat:@"%.2f分钟",learnTime];
    }else{
        timeStr = [NSString stringWithFormat:@"%.f秒",learnTime];
    }
    if (self.studyType == MCDYStruct) {
        //名词短语结构
        self.minuteLabel.text = [NSString stringWithFormat:@"自学了%@的名词短语结构",timeStr];
        self.progressLabel.text = [NSString stringWithFormat:@"通关进度%.f%%（单项通关）",100*[self.dayModel.schedule floatValue]];
    }else if (self.studyType == DCDYStruct){
        //动词短语结构
        self.minuteLabel.text = [NSString stringWithFormat:@"自学了%@的动词短语结构",timeStr];
        self.progressLabel.text = [NSString stringWithFormat:@"通关进度%.f%%（单项通关）",100*[self.dayModel.schedule floatValue]];
    }else if (self.studyType == JZJGZCStruct){
        //句子成组
        self.minuteLabel.text = [NSString stringWithFormat:@"自学了%@的句子结构成组",timeStr];
        self.progressLabel.text = [NSString stringWithFormat:@"通关进度%.f%%（单项通关）",100*[self.dayModel.schedule floatValue]];
    }else{
        //句子分解
        self.minuteLabel.text = [NSString stringWithFormat:@"自学了%@的句子结构分解",timeStr];
        self.progressLabel.text = [NSString stringWithFormat:@"通关进度%.2f%%（单项通关）",100*[self.dayModel.schedule floatValue]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
