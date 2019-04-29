//
//  DCXLVC.m
//  Yuudee2
//
//  Created by GZP on 2018/10/9.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "DCXLVC.h"

#import "ZLTimingView.h"

#define ziWith AdFloat(234)
#define ziHeight AdFloat(134)

@interface DCXLVC ()

@property (nonatomic,strong)NSTimer * goTimer;
@property(nonatomic,assign)NSInteger goTotal;

@property(nonatomic,strong) NSTimer * timer; //吃什么20S倒计时
@property(nonatomic,assign)NSInteger restS;

@property (nonatomic,strong)ZLTimingView *circleView; //倒计时
@property(nonatomic,strong)ZLSpreadView *handView; //小手
@property(nonatomic,strong)UIImageView * yuImage; //小鲸鱼

@property(nonatomic,strong)UIImageView * kejianImage;

@property(nonatomic,strong)UIImageView * huaBan2; //带下划线的木板
@property(nonatomic,strong)UIImageView * cardHuaBan; //名词卡片

@property(nonatomic,strong)GZPLabel * whiteL1;
@property(nonatomic,strong)GZPLabel * whiteL2;
@property(nonatomic,strong)GZPLabel * fitL1;
@property(nonatomic,strong)GZPLabel * fitL2;
@property(nonatomic,strong)UIImageView * lightImage;

@property(nonatomic,assign)CGFloat with1; //记录两组字的宽度,用来位移
@property(nonatomic,assign)CGFloat with2;


@property(nonatomic,strong)NSMutableArray * DCArr; //动词帧动画

@property(nonatomic,assign)BOOL hasSelect; //是否已经点击了卡片

@property(nonatomic,strong)GZPModel * model;
@property(nonatomic,strong)NSMutableArray * finalArr; //组合帧动画

@property(nonatomic,copy)NSString * isPass; //是否通过
@property(nonatomic,strong)NSDate * startDate; //开始答题时间
@property(nonatomic,copy)NSString * stayTimeList; //停留时间(逗号拼接)

@property(nonatomic,assign)BOOL dissVC;
@property(nonatomic,assign)BOOL overCourse; //标识课件各种操作已完成,可以跳转了

@end

@implementation DCXLVC
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.dissVC = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PlayerManager shared] playNetUrl:self.model.verbRecord];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2+10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.hasSelect && !self.dissVC) {
            [self playVerbThingRecord];
            if (self.timer == nil) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRest) userInfo:nil repeats:YES];
            }
        }
    });
}
-(void)dissTimer
{
    _restS = 0;
    [self.timer timeInterval];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.timer = nil;
}
-(void)playVerbThingRecord
{
    if ([self.model.verbChar isEqualToString:@"吃"]) {
        [[PlayerManager shared] playNetUrl:@"http://yuudee.oss-cn-beijing.aliyuncs.com/d8b40bd9dbb049e3bf6377a2895d446c.MP3"];
    }else if ([self.model.verbChar isEqualToString:@"穿"]){
        [[PlayerManager shared] playNetUrl:@"http://yuudee.oss-cn-beijing.aliyuncs.com/aa0493e345e94df2a082202a0a7bcde5.MP3"];
    }else if ([self.model.verbChar isEqualToString:@"喝"]){
        [[PlayerManager shared] playNetUrl:@"http://yuudee.oss-cn-beijing.aliyuncs.com/9507fb382f444f21a8f54d7775147a06.MP3"];
    }else if ([self.model.verbChar isEqualToString:@"洗"]){
        [[PlayerManager shared] playNetUrl:@"http://yuudee.oss-cn-beijing.aliyuncs.com/b357942359c04de7a6a88b8526fe8596.MP3"];
    }else if ([self.model.verbChar isEqualToString:@"玩"]){
        [[PlayerManager shared] playNetUrl:@"http://yuudee.oss-cn-beijing.aliyuncs.com/57e2165870d14a11be23f8e2dc89e736.MP3"];
    }
}
-(void)timeRest
{
    self.restS += 1;
    if (self.restS == 20) {
        [self playVerbThingRecord];
        self.restS = 0;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overPlay) name:@"OverPlay" object:nil];
    
    self.goTotal = 0;

    self.restS = 0;
    self.dissVC = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"can"];
    self.hasSelect = NO;
    _model = self.trainArr[_progressNum];
    self.startDate = [NSDate date];
    self.isPass = @"1";
    self.stayTimeList = @"1";
    
    for (int i = 0; i < 3; i ++) {
        [self.DCArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",_model.verbChar,i+1]]];
    }
    NSArray * array = [self.model.startSlideshow componentsSeparatedByString:@","];
    for (int i = 0; i < array.count - 1; i ++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 10, 10)];
        [image sd_setImageWithURL:[NSURL URLWithString:[array[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image != nil) {
                [self.finalArr addObject:image];
            }
        }];
        [self.view addSubview:image];
    }
    
    CGRect rect1 = [self returnRect:_model.verbChar];
    CGRect rect2 = [self returnRect:_model.cardChar];
    self.with1 = rect1.size.width;
    self.with2 = rect2.size.width;
    [self makeNav];
    [self makeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goOnAct) name:@"BecomeActive" object:nil];
}
-(void)goOnAct
{
    if (_hasSelect) {
        [self startPlay:self.finalArr];
    }else{
        [self startPlay:self.DCArr];
    }
}
-(CGRect)returnRect:(NSString *)string
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, ziHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AdFloat(55)]} context:nil];
}
-(void)makeUI
{
    UIImageView * paperImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - AdFloat(628)) / 2, AdFloat(220), AdFloat(628), AdFloat(532))];
    paperImage.image = [UIImage imageNamed:@"v_apple_bg"];
    [self.view addSubview:paperImage];
    
    //课件
    self.kejianImage = [[UIImageView alloc] initWithFrame:CGRectMake(paperImage.centerX-AdFloat(250), paperImage.centerY-AdFloat(250), KeJianWH, KeJianWH)];
    self.kejianImage.animationDuration = 1.5;
    self.kejianImage.animationRepeatCount = 2;
    self.kejianImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@3",_model.verbChar]];
    self.kejianImage.userInteractionEnabled = YES;
    [self.kejianImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(errorClick)]];
    [self.view addSubview:self.kejianImage];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startPlay:self.DCArr];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.hasSelect && !self.dissVC) {
                self.circleView.animationTime = [[NSString stringWithFormat:@"%@",self.helpTime[0]]integerValue];
                [self.circleView start];
            }
            NSInteger time = 1;
            if (!self.dissVC) {
                if (self.helpTime.count > 0) {
                    time = [[NSString stringWithFormat:@"%@",self.helpTime[0]]integerValue];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!self.hasSelect && !self.dissVC) {
                    self.handView.center = self.cardHuaBan.center;
                    self.handView.alpha = 1;
                    self.isPass = @"0";
                    self.stayTimeList = @"";
                }
            });
        });
    });
    
    //白色View1
    _whiteL1 = [[GZPLabel alloc] initWithFrame:CGRectMake((Screen_W-AdFloat(468+50)) / 2, paperImage.bottom + AdFloat(50), AdFloat(234), AdFloat(134))];
    _whiteL1.backgroundColor = [UIColor whiteColor];
    _whiteL1.layer.masksToBounds = YES;
    _whiteL1.layer.cornerRadius = AdFloat(5);
    [self.view addSubview:_whiteL1];
    
    UIButton * errorBtn = [[UIButton alloc] initWithFrame:CGRectMake(_whiteL1.left, _whiteL1.top, _whiteL1.width, _whiteL1.height)];
    [errorBtn addTarget:self action:@selector(errorClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:errorBtn];
    
    _fitL1 = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, self.with1, _whiteL1.height)];
    [_fitL1 fillWithText:_model.verbChar color:@"92674a" font:AdFloat(55) aligenment:NSTextAlignmentCenter];
    _fitL1.center = _whiteL1.center;
    [self.view addSubview:_fitL1];
    
    //发光亮图
    _lightImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-ziWith*1.5)/2, _whiteL1.top-AdFloat(15), ziWith*1.5, ziHeight+AdFloat(30))];
    [self.view addSubview:_lightImage];
    [self.view insertSubview:_lightImage belowSubview:_whiteL1];
    
    //画板2
    _huaBan2 = [[UIImageView alloc] initWithFrame:CGRectMake(_whiteL1.right + AdFloat(50), _whiteL1.top, _whiteL1.width, _whiteL1.height)];
    _huaBan2.image = [UIImage imageNamed:@"n_blank_bg"];
    _huaBan2.userInteractionEnabled = YES;
    [_huaBan2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(errorClick)]];
    [self.view addSubview:_huaBan2];
    
    //白色View2
    _whiteL2 = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, _whiteL1.width, _whiteL1.height)];
    _whiteL2.center = _huaBan2.center;
    _whiteL2.backgroundColor = [UIColor whiteColor];
    _whiteL2.layer.masksToBounds = YES;
    _whiteL2.layer.cornerRadius = AdFloat(5);
    _whiteL2.alpha = 0;
    [self.view addSubview:_whiteL2];
    
    _fitL2 = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, self.with2, _whiteL2.height)];
    [_fitL2 fillWithText:_model.cardChar color:@"92674a" font:AdFloat(55) aligenment:NSTextAlignmentCenter];
    _fitL2.center = _whiteL2.center;
    _fitL2.alpha = 0;
    [self.view addSubview:_fitL2];
    
    [self.view insertSubview:_fitL1 aboveSubview:_whiteL2];
    
    //画板
    _cardHuaBan = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-AdFloat(510)) / 2, Screen_H - AdFloat(60) - AdFloat(300), AdFloat(510), AdFloat(300))];
    _cardHuaBan.image = [UIImage imageNamed:@"dxhuaban"];
    [_cardHuaBan addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huaBanClick:)]];
    _cardHuaBan.userInteractionEnabled = YES;
    [self.view addSubview:_cardHuaBan];
    
    //图片
    UIImageView * keJian = [[UIImageView alloc] initWithFrame:CGRectMake((_cardHuaBan.width-AdFloat(200)) / 2, (_cardHuaBan.height - AdFloat(200)) / 2 - AdFloat(30), AdFloat(200), AdFloat(200))];
    [keJian sd_setImageWithURL:[NSURL URLWithString:[_model.cardImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    keJian.tag = 200;
    [_cardHuaBan addSubview:keJian];
    
    //文字
    GZPLabel * label = [[GZPLabel alloc] initWithFrame:CGRectMake(0, _cardHuaBan.height - AdFloat(80+20), _cardHuaBan.width, AdFloat(80))];
    [label fillWithText:_model.cardChar color:@"6f4c28" font:AdFloat(45) aligenment:NSTextAlignmentCenter];
    label.tag = 30;
    [_cardHuaBan addSubview:label];
    
    //小手
    _handView = [[ZLSpreadView alloc] initWithFrame:CGRectMake(0, 0, AdFloat(180), AdFloat(180))];
    _handView.userInteractionEnabled = NO;
    _handView.alpha = 0;
    [_handView show];
    [self.view addSubview:_handView];
}
#pragma mark - 点击了画板
-(void)huaBanClick:(UITapGestureRecognizer *)tap
{
    [self dissTimer];
    
    if ([_isPass isEqualToString:@"1"]) {
        self.stayTimeList = [NSString stringWithFormat:@"%.f",[self.circleView stop]];
    }
    [[PlayerManager shared] playNetUrl:self.model.cardRecord];
    self.handView.alpha = 0;
    _hasSelect = YES;
    UIImageView * huaBan = (id)tap.view;
    [UIView animateWithDuration:1 animations:^{
        huaBan.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            huaBan.transform = CGAffineTransformMakeScale(0.5, 0.5);
            huaBan.center = self.huaBan2.center;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                self.huaBan2.alpha = 0;
                huaBan.alpha = 0;
                self.whiteL2.alpha = 1;
                self.fitL2.alpha = 1;
            }completion:^(BOOL finished) {
                NSMutableArray * tempArr = [NSMutableArray array];
                for (int i = 1; i < 10; i ++) {
                    [tempArr addObject:[NSString stringWithFormat:@"M%d.mp3",i]];
                }
                [[PlayerManager shared] playLocalUrl:tempArr[arc4random()%9]];
                [UIView animateWithDuration:1 animations:^{
                    self.whiteL1.centerX = Screen_W/2-ziWith/2+self.whiteL1.width/4;
                    self.whiteL2.centerX = Screen_W/2+ziWith/2-self.whiteL2.width/4;
                } completion:^(BOOL finished) {
                    self.lightImage.image = [UIImage imageNamed:@"ditu1"];
                    self.whiteL1.backgroundColor = [UIColor clearColor];
                    self.whiteL2.backgroundColor = [UIColor clearColor];
                }];
                [UIView animateWithDuration:1.3 animations:^{
                    CGFloat with = self.with1 + self.with2;
                    CGFloat cha = self.with1 - with/2;
                    self.fitL1.centerX = Screen_W/2-self.with1/2+cha;
                    self.fitL2.centerX = self.fitL1.right+self.with2/2;
                } completion:^(BOOL finished) {
                    if (!self.goTimer) {
                        self.goTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Gogo) userInfo:nil repeats:YES];
                    }
                    [[PlayerManager shared] playNetUrl:self.model.groupRecord];
                    self.kejianImage.image = [self.finalArr lastObject];
                    [self startPlay:self.finalArr];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"gggg"] isEqualToString:@"0"]) {
                            [self showHint:@"当前网络已断开"];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            return ;
                        }
                        self.overCourse = YES;
                        [self goNextVC];
                    });
                }];
            }];
        }];
    }];
}
-(void)Gogo
{
    self.goTotal += 1;
    if (_goTotal == 10) {
        if (!self.dissVC) {
            [self action];
        }
    }
}
#pragma mark - 通知方法,调用是否跳转页面
-(void)overPlay
{
    [self goNextVC];
}
#pragma mark - 满足跳转下个页面的条件了,那么才跳转
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
    [self PostResult];
    
    [self dissTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.progressNum == self.trainArr.count - 1) {
        NSLog(@"答题到第10道了");
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dcgid"];
        GuoDuVC * vc = [GuoDuVC new];
        vc.type = 2;
        vc.testArr = self.testArr;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"未答题到第10道");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"can"];
        DCXLVC * vc = [DCXLVC new];
        vc.progressNum = self.progressNum+1;
        vc.helpTime = self.helpTime;
        vc.trainArr = self.trainArr;
        vc.testArr = self.testArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)makeNav
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
        if (i < _progressNum) {
            imageView.image = [UIImage imageNamed:@"circle_select"];
        }else{
            imageView.image = [UIImage imageNamed:@"circle_normal"];
        }
        [self.view addSubview:imageView];
        if (i == _progressNum) {
            _yuImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.centerX-AdFloat(56/2), imageView.centerY-AdFloat(72/2)-AdFloat(15), AdFloat(56), AdFloat(72))];
            _yuImage.image = [UIImage imageNamed:@"progress_logo_pic"];
            [self.view addSubview:_yuImage];
        }
    }
}
-(void)homeClick
{
    [self dissTimer];
    
    [self.goTimer timeInterval];
    [self.goTimer setFireDate:[NSDate distantFuture]];
    self.goTimer = nil;
    self.goTotal = 0;
    
    self.dissVC = YES;
    [[PlayerManager shared] pause];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"can"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 播放帧动画
-(void)startPlay:(NSArray *)array
{
    self.kejianImage.animationImages = array;
    [self.kejianImage startAnimating];
}
-(NSMutableArray *)DCArr
{
    if (_DCArr == nil) {
        _DCArr = [NSMutableArray array];
    }
    return _DCArr;
}
-(NSMutableArray *)finalArr
{
    if (_finalArr == nil) {
        _finalArr = [NSMutableArray array];
    }
    return _finalArr;
}
-(void)errorClick
{
    if (!_hasSelect) {
        self.handView.center = self.cardHuaBan.center;
        self.handView.alpha = 1;
        self.isPass = @"0";
        self.stayTimeList = @"";
    }
}
-(void)PostResult
{
    if (self.dissVC) return;
    
    NSString * allTime = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSinceDate:self.startDate]];
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"coursewareId":self.model.valueID, //课件id
                             @"scene":@"1", //训练,测试
                             @"module":@"2", //名词,动词,句子
                             @"startTime":[YuudeeDate getStartTime:self.startDate], //开始时间
                             @"pass":self.isPass, //是否通过
                             @"stayTimeList":self.stayTimeList, //停留时间
                             @"disTurbName":@"", //干扰名称
                             @"errorType":@"", //干扰类型
                             @"stayTime":allTime, //总停留时间
                             @"groupId":[[NSUserDefaults standardUserDefaults] objectForKey:@"dcgid"], //组id
                             @"name":self.model.groupChar
                             };
    [[YuudeeRequest shareManager] request:Post url:PostResult paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",response[@"groupId"]] forKey:@"dcgid"];
            NSLog(@"提交成功");
        }else{
            NSLog(@"提交失败");
        }
    }];
}

- (void)testFunction {
    [self viewDidLoad];
    [self viewWillAppear:YES];
    UIView *view = [self.view viewWithTag:10];
    self.isPass = @"1";
    [self huaBanClick:[view gestureRecognizers][0]];
    [self playVerbThingRecord];
    [self timeRest];
    
    [self Gogo];
    [self overPlay];
    [self goNextVC];
    [self action];
    [self makeNav];
    [self homeClick];
    [self PostResult];
}

@end
