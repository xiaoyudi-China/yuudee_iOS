//
//  ZJNTrainTotalProgressViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/18.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNTrainTotalProgressViewController.h"
#import "ZJNTotalProgressView.h"
#import "ZJNChartsView.h"

@interface ZJNTrainTotalProgressViewController ()
@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,strong)UIButton *backBtn;
@property (nonatomic ,strong)ZJNTotalProgressView *totalProgressView;
@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong)UILabel *middleLabel;
@property (nonatomic ,strong)ZJNChartsView *studyChartsView;
@property (nonatomic ,strong)ZJNChartsView *totalChartsView;

@property (nonatomic ,strong)NSMutableArray *studyXArr;
@property (nonatomic ,strong)NSMutableArray *studyDotArr;
@property (nonatomic ,strong)NSMutableArray *totalDotArr;
@property (nonatomic ,assign)CGFloat progress;

/*大于等于1小时，以小时记；小于1小时，大于等于1分钟，以分钟记；小于1分钟，以秒记>的名词短语结构*/
@property (nonatomic ,copy)NSString *titleStr;
@end

@implementation ZJNTrainTotalProgressViewController
-(instancetype)initWithModelArray:(NSArray *)modelArr progress:(CGFloat)progress{
    self = [super init];
    if (self) {
        self.modelArr = modelArr;
        self.progress = progress;
        self.studyXArr = [NSMutableArray array];
        self.studyDotArr = [NSMutableArray array];
        self.totalDotArr = [NSMutableArray array];
        self.titleStr = @"学习时长/s";
        if (self.modelArr.count>0) {
            ZJNTotalModel *lastModel = [self.modelArr lastObject];
            
            //学习时长（小时）：需要取整数学习时长 所以用int类型接收
            CGFloat learnTime = [lastModel.learning_time floatValue];
            if (learnTime>3600) {
                learnTime = learnTime/3600.0;
                self.titleStr = @"学习时长/h";
            }else if (learnTime>60){
                learnTime = learnTime/60.0;
                self.titleStr = @"学习时长/m";
            }else{
                self.titleStr = @"学习时长/s";
            }
            CGFloat timeInteval = learnTime/self.modelArr.count;//x轴间隔
            for (int i = 1; i <= self.modelArr.count; i ++) {
                CGFloat x = i *timeInteval;
                [self.studyXArr addObject:[NSString stringWithFormat:@"%.f",x]];
            }
            for (ZJNTotalModel *model in self.modelArr) {
                CGFloat time = [model.learning_time floatValue];
                CGFloat rate = 100*[model.rate_all floatValue];
                NSString *hTime = [NSString stringWithFormat:@"%.f",time];
                NSLog(@"time_______%@",hTime);
                NSString *rateStr = [NSString stringWithFormat:@"%.f",rate];
                [self.studyDotArr addObject:@[hTime,model.score]];
                [self.totalDotArr addObject:@[rateStr,model.score]];
            }
        }else{
            [self.studyXArr addObject:@""];
        }
    }
    NSLog(@"study___%@",self.studyDotArr);
    NSLog(@"total___%@",self.totalDotArr);
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(ScreenAdapter(22));
        make.top.equalTo(self.view).offset(ScreenAdapter(22)+AddNav());
        make.size.mas_equalTo(CGSizeMake(ScreenAdapter(48), ScreenAdapter(51)));
    }];
    
    [self.view addSubview:self.totalProgressView];
    
    [self.view addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalProgressView.mas_bottom).offset(ScreenAdapter(20));
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.middleLabel];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLabel.mas_bottom).offset(ScreenAdapter(7));
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.studyChartsView];
    [self.studyChartsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.middleLabel.mas_bottom);
        make.height.mas_equalTo(ScreenAdapter(170)+ScreenAdapter(26));
    }];
    
    [self.view addSubview:self.totalChartsView];
    [self.totalChartsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.studyChartsView.mas_bottom);
        make.height.mas_equalTo(ScreenAdapter(190)+ScreenAdapter(26));
    }];
    // Do any additional setup after loading the view.
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView itemWithImage:SetImage(@"xiaoguo_bg") backColor:[UIColor whiteColor]];
    }
    return _bgImageView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton itemWithTarget:self action:@selector(backBtnClick) image:@"left_button" highImage:nil];
    }
    return _backBtn;
}
-(ZJNTotalProgressView *)totalProgressView{
    if (!_totalProgressView) {
        _totalProgressView = [[ZJNTotalProgressView alloc]initWithFrame:CGRectMake(self.view.centerX-ScreenAdapter(61), ScreenAdapter(56)+AddNav(), ScreenAdapter(122), ScreenAdapter(122))];
        _totalProgressView.progress = self.progress;
    }
    return _totalProgressView;
}
-(UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [UILabel createLabelWithTitle:@"总测试进度" textColor:HexColor(textColor()) font:FontSize(16) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _topLabel;
}
-(UILabel *)middleLabel{
    if (!_middleLabel) {
        _middleLabel = [UILabel createLabelWithTitle:@"(全部通关本产品的进度)" textColor:HexColor(textColor()) font:FontSize(13) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    }
    return _middleLabel;
}
-(ZJNChartsView *)studyChartsView{
    if (!_studyChartsView) {
        _studyChartsView = [[ZJNChartsView alloc]init];
        _studyChartsView.lineChartsView.xArr = self.studyXArr;
        _studyChartsView.lineChartsView.yArr = @[@"50",@"100"];
        _studyChartsView.lineChartsView.xStr = @"量表分";
        _studyChartsView.lineChartsView.yStr = self.titleStr;
        _studyChartsView.lineChartsView.dotArr = self.studyDotArr;
        _studyChartsView.lineChartsView.maxY = 100;
        NSArray *arr = [self.studyDotArr lastObject];
        
        if (arr.count>0) {
            if ([arr[0] isEqualToString:@"0"]) {
                _studyChartsView.lineChartsView.maxX = 1;
            }else{
                _studyChartsView.lineChartsView.maxX = [arr[0] floatValue];
            }
            
        }else{
            _studyChartsView.lineChartsView.maxX = 1;
        }
        
        _studyChartsView.lineChartsView.dotColor = HexColor(0x00ceff);
        _studyChartsView.titleStr = @"学习时长与语言评估量表分关系";
    }
    return _studyChartsView;
}
-(ZJNChartsView *)totalChartsView{
    if (!_totalChartsView) {
        _totalChartsView = [[ZJNChartsView alloc]init];
        _totalChartsView.lineChartsView.xArr = @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"];
        _totalChartsView.lineChartsView.yArr = @[@"20",@"40",@"60",@"80",@"100"];
        _totalChartsView.lineChartsView.xStr = @"量表分";
        _totalChartsView.lineChartsView.yStr = @"总测试进度/%";
        _totalChartsView.lineChartsView.dotArr = self.totalDotArr;
        _totalChartsView.lineChartsView.maxY = 100;
        _totalChartsView.lineChartsView.maxX = 100;
        _totalChartsView.lineChartsView.dotColor = HexColor(0xcd4744);
        _totalChartsView.titleStr = @"总测试进度与语言评估量表分关系";
    }
    return _totalChartsView;
}
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setSumRate:(NSString *)sumRate{
    self.totalProgressView.progress = [sumRate floatValue];
}

- (void)testFunction{
    [self viewDidLoad];
    [self backBtnClick];
}

@end
