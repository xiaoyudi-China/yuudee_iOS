//
//  MCXLVC.m
//  Yuudee2
//
//  Created by GZP on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//left_button 96 102

#import "MCXLVC.h"
#import "GuoDuVC.h"
#import "ZLTimingView.h"
#import "ZJNParentCenterViewController.h"

#define lineWith 90
#define upTime 1

@interface MCXLVC ()
{
    CAShapeLayer * maskLayer;
    UIBezierPath * maskPath;
    NSTimer * timer;
    NSInteger total;
}

@property (nonatomic,strong)NSTimer * goTimer;
@property(nonatomic,assign)NSInteger goTotal;

@property (nonatomic,strong)ZLTimingView *circleView; //倒计时
@property(nonatomic,strong)ZLSpreadView *handView; //小手

@property(nonatomic,strong)UIImageView * yuImage; //小鲸鱼

@property(nonatomic,strong)UIImageView * keJianImage1;
@property(nonatomic,strong)UIImageView * keJianImage2;
@property(nonatomic,strong)UIImageView * penImage;

@property(nonatomic,strong)NSArray * pointArray;

@property(nonatomic,strong)ZLMergeTextView * showView; //文字合并View
@property(nonatomic,strong)GZPLabel * colorL;
@property(nonatomic,strong)UIImageView * lightImage; //文字发光图片
@property(nonatomic,assign)BOOL hasClick; //是否点击了画笔

@property(nonatomic,strong)GZPModel * model;

@property(nonatomic,copy)NSString * isPass; //是否通过
@property(nonatomic,strong)NSDate * startDate; //开始答题时间
@property(nonatomic,copy)NSString * stayTimeList; //停留时间(逗号拼接)

@property(nonatomic,assign)BOOL dissVC;
@property(nonatomic,assign)BOOL overCourse; //标识课件各种操作已完成,可以跳转了

@end

@implementation MCXLVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[PlayerManager shared] playNetUrl:self.model.wireRecord];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overPlay) name:@"OverPlay" object:nil];
    self.goTotal = 0;

    self.dissVC = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"can"];
    self.model = self.trainArr[_progressNum];
    self.startDate = [NSDate date];
    self.isPass = @"1";
    self.stayTimeList = @"1";
    total = 0;
    _hasClick = NO;
    _pointArray = @[
                    @[@64, @70],
                    @[@106, @72],
                    @[@145, @70],
                    @[@184, @71],

                    @[@181, @97],
                    @[@139, @110],
                    @[@106, @117],
                    @[@65, @126],

                    @[@80, @170],
                    @[@118, @165],
                    @[@152, @157],
                    @[@187, @139],

                    @[@199, @175],
                    @[@158, @200],
                    @[@111, @210],
                    @[@71, @220]
                    ];
    
    [self makeUI];
    ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    if ([model.IsRemind isEqualToString:@"1"] && self.progressNum == 0) { //个人信息未完善,上传体验记录
        [self HTTPPostTry];
    }
}
#pragma mark - HTTP上传体验产品
-(void)HTTPPostTry
{
    [[YuudeeRequest shareManager] request:Post url:PostTry paras:@{@"token":[[ZJNTool shareManager]getToken],@"type":@"1"} completion:^(id response, NSError *error) {
//        NSLog(@"产品体验记录上传: %@",response);
    }];
}
-(void)makeUI
{
    UIImageView * bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    bgImage.image = [UIImage imageNamed:@"bgimage"];
    [self.view addSubview:bgImage];
    
    _circleView = [[ZLTimingView alloc] initWithFrame:CGRectMake(-10, -10, 5, 5)];
    [self.view addSubview:_circleView];
    
    //home按钮
    UIButton * homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W - AdFloat(44+84), AdFloat(44)+AddNav(), AdFloat(84), AdFloat(84))];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button_press"] forState:UIControlStateHighlighted];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    
    //进度点
    CGFloat imageWH = AdFloat(34);
    CGFloat gap = AdFloat(10);
    for (int i = 0; i < 10; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-homeBtn.width-AdFloat(80)-(imageWH+gap)*10+gap)+(imageWH+gap)*i + AdFloat(10), homeBtn.centerY - (imageWH/2), imageWH, imageWH)];
        if (i < self.progressNum) {
            imageView.image = [UIImage imageNamed:@"circle_select"];
        }else{
            imageView.image = [UIImage imageNamed:@"circle_normal"];
        }
        [self.view addSubview:imageView];
        if (i == self.progressNum) {
            _yuImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.centerX-AdFloat(56/2), imageView.centerY-AdFloat(72/2)-AdFloat(15), AdFloat(56), AdFloat(72))];
            _yuImage.image = [UIImage imageNamed:@"progress_logo_pic"];
            [self.view addSubview:_yuImage];
        }
    }
    
    //画板
    UIImageView * huaBanImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - AdFloat(630)) / 2, AdFloat(200), AdFloat(630), AdFloat(540))];
    huaBanImage.image = [UIImage imageNamed:@"n_apple_bg"];
    huaBanImage.userInteractionEnabled = YES;
    [huaBanImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(errorClick)]];
    [self.view addSubview:huaBanImage];
    
    //素描
    [self showHudInView:self.view hint:nil];
    _keJianImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(huaBanImage.centerX - AdFloat(250), huaBanImage.centerY - AdFloat(250), KeJianWH, KeJianWH)];
    [_keJianImage2 sd_setImageWithURL:[NSURL URLWithString:[self.model.wireImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self hideHud];
    }];
    [self.view addSubview:_keJianImage2];
    
    //课件图片彩绘
    _keJianImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(huaBanImage.centerX - AdFloat(250), huaBanImage.centerY - AdFloat(250), KeJianWH, KeJianWH)];
    [_keJianImage1 sd_setImageWithURL:[NSURL URLWithString:[self.model.groupImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [self.view addSubview:_keJianImage1];
    
    maskLayer = [CAShapeLayer layer];
    maskLayer.strokeColor = [UIColor redColor].CGColor;
    maskLayer.lineWidth = lineWith;
    maskLayer.lineCap = kCALineCapRound;
    _keJianImage1.layer.mask = maskLayer;

    maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(72, 98)];

    //调试找点用
    [_keJianImage1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gesture:)]];
    
    //画笔
    self.penImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - AdFloat(200)) / 2, Screen_H - AdFloat(450), AdFloat(200), AdFloat(450))];
    self.penImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@笔",_model.colorPenChar]];
    self.penImage.userInteractionEnabled = YES;
    [self.penImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(penClick)]];
    [self.view addSubview:self.penImage];

    //波圈
    _handView = [[ZLSpreadView alloc] initWithFrame:CGRectMake(_penImage.centerX-AdFloat(90), _penImage.centerY-AdFloat(90)+AdFloat(30), AdFloat(180), AdFloat(180))];
    _handView.userInteractionEnabled = NO;
    _handView.alpha = 0;
    [self.view addSubview:_handView];
    //颜色字
    _colorL = [[GZPLabel alloc] initWithFrame:CGRectMake((Screen_W-AdFloat(100)) / 2, Screen_H - AdFloat(100), AdFloat(100), AdFloat(100))];
    [_colorL fillWithText:self.model.colorPenChar color:@"92674a" font:AdFloat(50) aligenment:NSTextAlignmentCenter];
    _colorL.font = [UIFont boldSystemFontOfSize:AdFloat(46)];
    _colorL.backgroundColor = [@"fefbf6" hexStringToColor];
    _colorL.layer.masksToBounds = YES;
    _colorL.layer.cornerRadius = AdFloat(4);
    [self.view addSubview:_colorL];
    
    //发光亮图
    _lightImage = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth()-([ZLMergeTextView viewRect].size.width+AdFloat(30)))*0.5, huaBanImage.bottom + AdFloat(28)-AdFloat(15), [ZLMergeTextView viewRect].size.width+AdFloat(30), [ZLMergeTextView viewRect].size.height+AdFloat(30))];
    [self.view addSubview:_lightImage];
    
    //字合并View
    _showView = [ZLMergeTextView MergeTextView];
    _showView.left = (ScreenWidth()-_showView.width)*0.5;
    _showView.top = huaBanImage.bottom + AdFloat(28);
    _showView.rightText = self.model.wireChar;
    __weak typeof(self)weakSelf = self;
    _showView.block = ^{
        weakSelf.lightImage.image = [UIImage imageNamed:@"ditu1"];
    };
    [self.handView show];
    
    [self.view addSubview:_showView];
    [self.view insertSubview:_showView aboveSubview:_lightImage];
    [self.view insertSubview:self.penImage aboveSubview:_showView];
    [self.view insertSubview:self.colorL aboveSubview:self.penImage];
    [self.view insertSubview:_handView aboveSubview:self.penImage];
    
    UIButton * errBtn = [[UIButton alloc] initWithFrame:CGRectMake(_showView.left, _showView.top, _showView.width, _showView.height)];
    [errBtn addTarget:self action:@selector(errorClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:errBtn];
    
    //课件缩放效果
    if (self.hasClick) return ;
    [UIView animateWithDuration:1 animations:^{
        self.keJianImage1.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.keJianImage2.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.keJianImage1.transform = CGAffineTransformMakeScale(1, 1);
        self.keJianImage2.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.penImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@笔2",self.model.colorPenChar]];
        //延迟两秒,画笔开始晃动
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //如果此时已点击了画笔,直接返回,不再执行摆动
            if (self.hasClick) return ;
            [self swingPen1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!self.hasClick) {
                    [self swingPen2];
                }
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!self.hasClick && !self.dissVC) {
                    //开始统计答题时间
                    self.circleView.animationTime = [[NSString stringWithFormat:@"%@",self.helpTime[0]] integerValue];
                    [self.circleView start];
                }
            });
            //晃动完成,倒计时出现小手辅助
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([[NSString stringWithFormat:@"%@",self.helpTime[0]] integerValue]+4.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.hasClick) return ;
                [UIView animateWithDuration:0.8 animations:^{
                    self.handView.alpha = 1;
                    self.isPass = @"0";
                    self.stayTimeList = @"";
                }];
                [self.handView show];
            });
        });
    }];
}
#pragma mark - 点击了画笔
-(void)penClick
{
    if (_hasClick) return; //如果点击过画笔,那么直接返回
    if ([_isPass isEqualToString:@"1"]) {
        self.stayTimeList = [NSString stringWithFormat:@"%.f",[self.circleView stop]];
    }
    _hasClick = YES;
    
    [[PlayerManager shared] playNetUrl:self.model.colorPenRecord];
    
    [self.penImage.layer removeAllAnimations];
    self.penImage.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.penImage.frame = CGRectMake((Screen_W - AdFloat(200)) / 2, Screen_H - AdFloat(450), AdFloat(200), AdFloat(450));
    self.penImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@笔2",_model.colorPenChar]];

    [self.handView removeFromSuperview];

    //字放大上移
    [_showView showLeftText:self.model.colorPenChar withAnimationTime:upTime];
    CGFloat cycleH = self.showView.height*1.0/self.colorL.height;
    [UIView animateWithDuration:upTime animations:^{
        self.colorL.left = self.showView.left+(self.showView.height-self.colorL.height)*0.5;
        self.colorL.top = self.showView.top+(self.showView.height-self.colorL.height)*0.5;
        self.colorL.transform = CGAffineTransformScale(self.colorL.transform, cycleH, cycleH);
    } completion:^(BOOL finished) {
        [self.colorL removeFromSuperview];
    }];
    
    //画笔上移,左右上下涂抹
    [UIView animateWithDuration:2 animations:^{
        self.penImage.frame = CGRectMake(self.keJianImage1.centerX+AdFloat(40), self.keJianImage1.centerY-AdFloat(100), self.penImage.width, self.penImage.height);
        self.penImage.transform = CGAffineTransformRotate(self.penImage.transform, -M_PI_4);
    }completion:^(BOOL finished) {
        [self startTimer];
        [UIView animateWithDuration:0.8 animations:^{ //上
            CGPoint p = self.penImage.center;
            p.x += AdFloat(80);
            p.y -= AdFloat(20);
            self.penImage.center = p;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 animations:^{ //下
                CGPoint p = self.penImage.center;
                p.x -= AdFloat(80);
                p.y += AdFloat(100);
                self.penImage.center = p;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.8 animations:^{ //左
                    CGPoint p = self.penImage.center;
                    p.x += AdFloat(80);
                    p.y -= AdFloat(20);
                    self.penImage.center = p;
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.8 animations:^{ //右
                        CGPoint p = self.penImage.center;
                        p.x -= AdFloat(80);
                        p.y += AdFloat(100);
                        self.penImage.center = p;
                    }completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{ //控制画笔消失
                            [self.penImage setAlpha:0];
                        }completion:^(BOOL finished) {
                            NSMutableArray * tempArr = [NSMutableArray array];
                            for (int i = 1; i < 10; i ++) {
                                [tempArr addObject:[NSString stringWithFormat:@"M%d.mp3",i]];
                            }
                            [[PlayerManager shared] playLocalUrl:tempArr[arc4random()%9]];
                            if (!self.goTimer) {
                                self.goTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Gogo) userInfo:nil repeats:YES];
                            }
                            [[PlayerManager shared] playNetUrl:self.model.groupRecord];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [UIView animateWithDuration:1 animations:^{ //放大
                                    self.keJianImage1.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                    self.keJianImage2.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                }completion:^(BOOL finished) {
                                    [UIView animateWithDuration:1 animations:^{ //缩小
                                        self.keJianImage1.transform = CGAffineTransformMakeScale(1, 1);
                                        self.keJianImage2.transform = CGAffineTransformMakeScale(1, 1);
                                    }completion:^(BOOL finished) {
                                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"gggg"] isEqualToString:@"0"]) {
                                            [self showHint:@"当前网络已断开"];
                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                            return ;
                                        }
                                        self.overCourse = YES;
                                        [self goNextVC];
                                    }];
                        }];

                            });
                        }];
                    }];
                }];
            }];
        }];
    }];
}
-(void)Gogo
{
    self.goTotal += 1;
    if (_goTotal == 7) {
        if (!self.dissVC) {
            [self action];
        }
    }
}
-(void)overPlay
{
    [self goNextVC];
}
-(void)goNextVC
{
    if (self.dissVC) return;
    if (self.overCourse && [PlayerManager shared].itemsArr.count == 0) {
        [self action];
    }
}
-(void)action
{
    if (self.goTimer) {
        [self.goTimer timeInterval];
        [self.goTimer setFireDate:[NSDate distantFuture]];
        self.goTimer = nil;
        self.goTotal = 0;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    if (![model.IsRemind isEqualToString:@"1"]) { //已完善儿童信息,那么提交答题结果
        [self PostResult];
    }
    if (self.progressNum == self.trainArr.count-1) {
        NSLog(@"答题到第10题了");
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"mcgid"];
        GuoDuVC * vc = [GuoDuVC new];
        vc.type = 1;
        vc.testArr = self.testArr;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"未答题到第10题");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"can"];
        MCXLVC * vc = [MCXLVC new];
        vc.progressNum = self.progressNum+1;
        vc.helpTime = self.helpTime;
        vc.trainArr = self.trainArr;
        vc.testArr = self.testArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)homeClick
{
    [self.goTimer timeInterval];
    [self.goTimer setFireDate:[NSDate distantFuture]];
    self.goTimer = nil;
    self.goTotal = 0;
    
    self.dissVC = YES;
    [[PlayerManager shared] pause];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"can"];
    
    ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    if (![model.IsRemind isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        ZJNParentCenterViewController *viewC = [[ZJNParentCenterViewController alloc]init];
        [self.navigationController pushViewController:viewC animated:YES];
    }
}
#pragma mark - 画笔摇摆动画2
-(void)swingPen2
{
    [self.penImage.layer removeAnimationForKey:@"rota1"];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: -M_PI / 15];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI / 15];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = 2;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.penImage.layer.anchorPoint = CGPointMake(0.5, 1);
    self.penImage.frame = CGRectMake((Screen_W - AdFloat(200)) / 2, Screen_H - AdFloat(450), AdFloat(200), AdFloat(450));
    [self.penImage.layer addAnimation:rotationAnimation forKey:@"rota2"];
}
#pragma mark - 画笔晃动动画1
-(void)swingPen1
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:-M_PI / 15];
    rotationAnimation.duration = 0.5;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.penImage.layer.anchorPoint = CGPointMake(0.5, 1);
    self.penImage.frame = CGRectMake((Screen_W - AdFloat(200)) / 2, Screen_H - AdFloat(450), AdFloat(200), AdFloat(450));
    [self.penImage.layer addAnimation:rotationAnimation forKey:@"rota1"];
}
-(void)gesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:_keJianImage1];
    NSLog(@"点::::::::%f %f",point.x,point.y);
    return;
}
#pragma mark - 计时器实现涂抹效果
-(void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
}
-(void)timeGo
{
    total ++;
    if (total == 16) {
        total = 0;
        [timer invalidate];
        timer = nil;
        return;
    }
    NSArray * array = _pointArray[total];
    CGPoint point = CGPointMake([array[0] floatValue], [array[1] floatValue]);
    [maskPath addLineToPoint:point];
    [maskPath moveToPoint:point];
    maskLayer.path = maskPath.CGPath;
    _keJianImage1.layer.mask = maskLayer;
}
-(void)PostResult
{
    if (self.dissVC) return;
    
    NSString * allTime = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSinceDate:self.startDate]];
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"coursewareId":self.model.valueID, //课件id
                             @"scene":@"1", //训练,测试
                             @"module":@"1", //名词,动词,句子
                             @"startTime":[YuudeeDate getStartTime:self.startDate], //开始时间
                             @"pass":self.isPass, //是否通过
                             @"stayTimeList":self.stayTimeList, //停留时间
                             @"disTurbName":@"", //干扰名称
                             @"errorType":@"", //干扰类型
                             @"stayTime":allTime, //总停留时间
                             @"groupId":[[NSUserDefaults standardUserDefaults] objectForKey:@"mcgid"], //组id
                             @"name":self.model.groupWord
                             };
    [[YuudeeRequest shareManager] request:Post url:PostResult paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",response[@"groupId"]] forKey:@"mcgid"];
            NSLog(@"提交成功");
        }else{
            NSLog(@"提交失败:%@",response[@"msg"]);
        }
    }];
}

-(void)errorClick
{
    if (!self.hasClick) {
        [UIView animateWithDuration:0.8 animations:^{
            self.handView.alpha = 1;
            self.isPass = @"0";
            self.stayTimeList = @"";
        }];
    }
}

- (void)testFunction {
    [self viewDidLoad];
    [self penClick];
    [self Gogo];
    [self overPlay];
    [self goNextVC];
    [self action];
    [self homeClick];
    [self PostResult];
    [self swingPen1];
    [self swingPen2];
    self.hasClick = NO;
    [self errorClick];
}

@end







