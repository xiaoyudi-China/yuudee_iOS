//
//  DCCSVC.m
//  Yuudee2
//
//  Created by GZP on 2018/10/9.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "DCCSVC.h"
#import "ZLTimingView.h"
#import "DCXLVC.h"

#define ziWith AdFloat(234-0)
#define ziHeight AdFloat(134-0)

@interface DCCSVC ()

@property (nonatomic,strong)NSTimer * goTimer;
@property(nonatomic,assign)NSInteger goTotal;

@property (nonatomic,strong)ZLTimingView *circleView; //倒计时
@property(nonatomic,strong)ZLSpreadView *handView; //小手

@property(nonatomic,strong)UIImageView * yuImage; //小鲸鱼
@property(nonatomic,strong)GZPLabel * coinNum; //金币数量

@property(nonatomic,strong)UIImageView * kejianImage;

@property(nonatomic,strong)UIImageView * huaBan1; //两个带下划线的木板
@property(nonatomic,strong)UIImageView * huaBan2;

@property(nonatomic,assign)BOOL hasRight1; //标记是否点击了第一个正确卡片了
@property(nonatomic,assign)BOOL hasRight2; //标记是否点击了第二个正确卡片了

@property(nonatomic,strong)GZPLabel * whiteL1;
@property(nonatomic,strong)GZPLabel * whiteL2;
@property(nonatomic,strong)GZPLabel * fitL1;
@property(nonatomic,strong)GZPLabel * fitL2;
@property(nonatomic,strong)UIImageView * lightImage;

@property(nonatomic,assign)CGFloat with1; //记录两组字的宽度,用来位移
@property(nonatomic,assign)CGFloat with2;

@property(nonatomic,strong)NSMutableArray * dcArr;
@property(nonatomic,strong)NSMutableArray * finalArr;

@property(nonatomic,strong)GZPModel * model;

@property(nonatomic,copy)NSString * isPass; //是否通过
@property(nonatomic,strong)NSDate * startDate; //开始答题时间
@property(nonatomic,copy)NSString * stayTimeList; //停留时间(逗号拼接)

@property(nonatomic,strong)UIImageView * addGoldImage; //增加的金币图片

@property(nonatomic,assign)BOOL dissVC;
@property(nonatomic,assign)BOOL overCourse; //标识课件各种操作已完成,可以跳转了
/** 单元测试*/
@property (nonatomic) BOOL isTest;
@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@property (nonatomic, copy) NSString *testToken;

@end

@implementation DCCSVC
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goTotal = 0;

    self.dissVC = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"can"];
    self.startDate = [NSDate date];
    self.isPass = @"1";
    self.stayTimeList = @"1,1";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overPlay) name:@"OverPlay" object:nil];

    _hasRight1 = NO;
    _hasRight2 = NO;
    _dcArr = [NSMutableArray array];
    _finalArr = [NSMutableArray array];
    _model = self.testArr[_progressNum];

    CGRect rect1 = [self returnRect:_model.verbChar];
    CGRect rect2 = [self returnRect:_model.cardChar];
    self.with1 = rect1.size.width;
    self.with2 = rect2.size.width;
    [self makeNav];
    [self makeUI];
    
    NSArray * array = [self.model.startSlideshow componentsSeparatedByString:@","];
    for (int i = 0; i < array.count - 1; i ++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 10, 10)];
        [image sd_setImageWithURL:[NSURL URLWithString:[array[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image != nil) {
                [self.finalArr addObject:image];
            }
            if (i == array.count-2) {
                self.kejianImage.image = [self.finalArr lastObject];
                self.kejianImage.animationImages = self.finalArr;
                [self.kejianImage startAnimating];
            }
        }];
        [self.view addSubview:image];
    }
    for (int i = 0; i < 3; i ++) {
        NSString * item = [NSString stringWithFormat:@"%@%d",self.model.verbChar,i+1];
        UIImage * image = [UIImage imageNamed:item];
        [_dcArr addObject:image];
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
    
    UIImageView * coinImage = [[UIImageView alloc] initWithFrame:CGRectMake(paperImage.centerX - AdFloat(100), paperImage.top - AdFloat(70), AdFloat(64), AdFloat(64))];
    coinImage.image = [UIImage imageNamed:@"money"];
    coinImage.tag = 777;
    [self.view addSubview:coinImage];
    
    GZPLabel * X = [[GZPLabel alloc] initWithFrame:CGRectMake(coinImage.right+AdFloat(10), coinImage.top, coinImage.width/2, coinImage.height)];
    [X fillWithText:@"X" color:@"92674a" font:AdFloat(26) aligenment:NSTextAlignmentCenter];
    X.font = [UIFont boldSystemFontOfSize:AdFloat(26)];
    X.tag = 888;
    [self.view addSubview:X];
    
    _coinNum = [[GZPLabel alloc] initWithFrame:CGRectMake(X.right, X.top - AdFloat(1), coinImage.width, coinImage.height)];
    [_coinNum fillWithText:[NSString stringWithFormat:@"%ld",self.coinNumber] color:@"92674a" font:AdFloat(34) aligenment:NSTextAlignmentLeft];
    _coinNum.font = [UIFont boldSystemFontOfSize:AdFloat(34)];
    [self.view addSubview:_coinNum];
    if (self.coinNumber == 0) {
        coinImage.hidden = YES;
        X.hidden = YES;
        _coinNum.hidden = YES;
    }else{
        _coinNum.text = [NSString stringWithFormat:@"%ld",self.coinNumber];
    }
    //课件
    self.kejianImage = [[UIImageView alloc] initWithFrame:CGRectMake(paperImage.centerX-AdFloat(250), paperImage.centerY-AdFloat(250), KeJianWH, KeJianWH)];
    self.kejianImage.animationDuration = 1.5;
    self.kejianImage.animationRepeatCount = 2;
    [self.view addSubview:self.kejianImage];
    
    [[PlayerManager shared] playLocalUrl:@"男-他在干什么.MP3"];

    NSInteger after1 = [[NSString stringWithFormat:@"%@",self.model.cardOneTime] integerValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.hasRight1) {
            self.circleView.animationTime = after1;
            [self.circleView start];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.hasRight1) {
                for (int i = 0; i < 2; i ++) {
                    UIImageView * huaBan = (id)[self.view viewWithTag:10+i];
                    GZPLabel * label = (id)[huaBan viewWithTag:30+i];
                    if ([label.text isEqualToString:self.model.verbChar]) {
                        self.handView.center = huaBan.center;
                        self.handView.alpha = 1;
                        self.isPass = @"0";
                        self.stayTimeList = @"";
                    }
                }
            }
        });
    });
    
    //画板1
    _huaBan1 = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-AdFloat(468+50)) / 2, paperImage.bottom + AdFloat(50), AdFloat(234), AdFloat(134))];
    _huaBan1.image = [UIImage imageNamed:@"n_blank_bg"];
    [self.view addSubview:_huaBan1];
    
    //白色View1
    _whiteL1 = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, _huaBan1.width-AdFloat(0), _huaBan1.height - AdFloat(0))];
    _whiteL1.center = _huaBan1.center;
    _whiteL1.backgroundColor = [UIColor whiteColor];
    _whiteL1.layer.masksToBounds = YES;
    _whiteL1.layer.cornerRadius = AdFloat(5);
    _whiteL1.alpha = 0;
    [self.view addSubview:_whiteL1];
    
    _fitL1 = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, self.with1, _whiteL1.height)];
    [_fitL1 fillWithText:self.model.verbChar color:@"92674a" font:AdFloat(55) aligenment:NSTextAlignmentCenter];
    _fitL1.center = _whiteL1.center;
    _fitL1.alpha = 0;
    [self.view addSubview:_fitL1];
    
    //发光亮图
    _lightImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-ziWith*1.5)/2, _whiteL1.top-AdFloat(15), ziWith*1.5, ziHeight+AdFloat(30))];
    [self.view addSubview:_lightImage];
    [self.view insertSubview:_lightImage belowSubview:_whiteL1];
    
    //画板2
    _huaBan2 = [[UIImageView alloc] initWithFrame:CGRectMake(_huaBan1.right + AdFloat(50), _huaBan1.top, _huaBan1.width, _huaBan1.height)];
    _huaBan2.image = [UIImage imageNamed:@"n_blank_bg"];
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
    [_fitL2 fillWithText:self.model.cardChar color:@"92674a" font:AdFloat(55) aligenment:NSTextAlignmentCenter];
    _fitL2.center = _whiteL2.center;
    _fitL2.alpha = 0;
    [self.view addSubview:_fitL2];
    
    [self.view insertSubview:_fitL1 aboveSubview:_whiteL2];
    
    //动画笑脸
    self.addGoldImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.kejianImage.bottom + AdFloat(5), AdFloat(64), AdFloat(64))];
    self.addGoldImage.centerX = self.kejianImage.centerX;
    self.addGoldImage.image = [UIImage imageNamed:@"money"];
    self.addGoldImage.hidden = YES;
    [self.view addSubview:self.addGoldImage];
    
    //画板和一些子控件
    CGFloat HuaBan_W = AdFloat(260);
    CGFloat HuaBan_H = AdFloat(280);
    CGFloat HuaBan_gap = AdFloat(80);
    CGFloat mc_WH = AdFloat(150);
    NSArray * list = self.model.list;
    for (int i = 0; i < 2; i ++) {
        //画板
        UIImageView * huaBan = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - HuaBan_W*2 - HuaBan_gap) / 2 + (HuaBan_W + HuaBan_gap)*i, _huaBan1.bottom + AdFloat(50), HuaBan_W, HuaBan_H)];
        huaBan.image = [UIImage imageNamed:@"n_big_bg"];
        huaBan.userInteractionEnabled = YES;
        [huaBan addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huaBanClick:)]];
        huaBan.tag = 10 + i;
        [self.view addSubview:huaBan];
        
        //课件图片
        NSString * imageURL = list[i][@"cardImage"];
        NSString * cardStr = list[i][@"cardChar"];
        UIImageView * keJian = [[UIImageView alloc] initWithFrame:CGRectMake((HuaBan_W - mc_WH) / 2, (HuaBan_H - mc_WH) / 2 - AdFloat(40), mc_WH, mc_WH)];
        if (![cardStr isEqualToString:self.model.verbChar]) {
            [keJian sd_setImageWithURL:[NSURL URLWithString:[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }else{
            keJian.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",list[i][@"cardChar"]]];
        }
        keJian.tag = 20 + i;
        [huaBan addSubview:keJian];
        
        //文字
        GZPLabel * label = [[GZPLabel alloc] initWithFrame:CGRectMake(0, huaBan.height - AdFloat(80+15), HuaBan_W, AdFloat(80))];
        [label fillWithText:list[i][@"cardChar"] color:@"6f4c28" font:AdFloat(45) aligenment:NSTextAlignmentCenter];
        label.tag = 30 + i;
        [huaBan addSubview:label];
    }
    
    //小手
    _handView = [[ZLSpreadView alloc] initWithFrame:CGRectMake(0, 0, AdFloat(180), AdFloat(180))];
    _handView.userInteractionEnabled = NO;
    _handView.alpha = 0;
    [_handView show];
    [self.view addSubview:_handView];
    
    //延迟执行吃的动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3+4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 2; i ++) {
            UIImageView * huaBan = (id)[self.view viewWithTag:10+i];
            GZPLabel * label = (id)[huaBan viewWithTag:30+i];
            if (self.isTest) {//单元测试
                label.text = @"汽车1";
            }
            if ([label.text isEqualToString:self.model.verbChar]) {
                UIImageView * dcImage = (id)[huaBan viewWithTag:20+i];
                dcImage.animationImages = self.dcArr;
                dcImage.animationDuration = 1.5;
                dcImage.animationRepeatCount = 1000;
                [dcImage startAnimating];
            }
        }
    });
}
#pragma mark - 点击了画板
-(void)huaBanClick:(UITapGestureRecognizer *)tap
{
    UIImageView * huaBan = (id)tap.view;
    GZPLabel * label = (id)[huaBan viewWithTag:20+huaBan.tag];
    if (self.isTest) {//单元测试
        label.text = @"汽车1";
    }
    if ([label.text isEqualToString:_model.verbChar]) { //点击了第一个正确卡片
        [self.circleView stop];
        if ([self.isPass isEqualToString:@"1"]) {
            self.stayTimeList = [NSString stringWithFormat:@"%.f,",[self.circleView stop]];
        }
        [[PlayerManager shared] playNetUrl:self.model.verbRecord];
        _hasRight1 = YES;
        _handView.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            huaBan.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:2 animations:^{
                huaBan.transform = CGAffineTransformMakeScale(0.5, 0.5);
                huaBan.center = self.huaBan1.center;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:1 animations:^{
                    self.huaBan1.alpha = 0;
                    huaBan.alpha = 0;
                    self.whiteL1.alpha = 1;
                    self.fitL1.alpha = 1;
                }completion:^(BOOL finished) {
                    NSInteger after2 = [[NSString stringWithFormat:@"%@",self.model.cardTwoTime]integerValue];
                    if (!self.hasRight2) {
                        self.circleView.animationTime = after2;
                        [self.circleView start];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!self.hasRight2) {
                            for (int i = 0; i < 2; i ++) {
                                UIImageView * H = (id)[self.view viewWithTag:10+i];
                                GZPLabel * L = (id)[H viewWithTag:30+i];
                                if ([L.text isEqualToString:self.model.cardChar]) {
                                    self.handView.center = H.center;
                                    self.handView.alpha = 1;
                                    self.isPass = @"0";
                                    self.stayTimeList = @"";
                                }
                            }
                        }
                    });
                }];
            }];
        }];
        
    }else{ //点击了第二个正确卡片
        if (_hasRight1) {
            [self.circleView stop];
            if ([self.isPass isEqualToString:@"1"]) {
                self.stayTimeList = [NSString stringWithFormat:@"%@%.f",self.stayTimeList,[self.circleView stop]];
            }
            [[PlayerManager shared] playNetUrl:self.model.cardRecord];
            self.hasRight2 = YES;
            self.handView.alpha = 0;
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
                        if ([self.isPass isEqualToString:@"1"]) {
                            self.addGoldImage.hidden = NO;
                            [UIView animateWithDuration:2 animations:^{
                                self.addGoldImage.transform = CGAffineTransformMakeScale(2.5, 2.5);
                                self.addGoldImage.center = CGPointMake(self.kejianImage.right-AdFloat(40), self.kejianImage.top+AdFloat(64));
                            }completion:^(BOOL finished) {
                                [UIView animateWithDuration:1 animations:^{
                                    UIImageView * image = (id)[self.view viewWithTag:777];
                                    self.addGoldImage.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                    self.addGoldImage.center = image.center;
                                }completion:^(BOOL finished) {
                                    UIImageView * image = (id)[self.view viewWithTag:777];
                                    GZPLabel * X = (id)[self.view viewWithTag:888];
                                    if ([self.coinNum.text isEqualToString:@"0"]) {
                                        image.hidden = NO;
                                        X.hidden = NO;
                                        self.coinNum.hidden = NO;
                                    }
                                    self.addGoldImage.hidden = YES;
                                    self.coinNum.text = [NSString stringWithFormat:@"%ld",[self.coinNum.text integerValue]+1];
                                }];
                            }];
                        }
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
                            self.kejianImage.animationRepeatCount = 2;
                            self.kejianImage.animationDuration = 1.5;
                            self.kejianImage.animationImages = self.finalArr;
                            [self.kejianImage startAnimating];
                            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"gggg"] isEqualToString:@"0"]) {
                                [self showHint:@"当前网络已断开"];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                return ;
                            }
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                self.overCourse = YES;
                                [self goNextVC];
                            });
                        }];
                    }];
                }];
            }];
            
        }else{
            for (int i = 0; i < 2; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10+i];
                GZPLabel * L = (id)[H viewWithTag:30+i];
                if ([L.text isEqualToString:self.model.verbChar]) {
                    self.handView.center = H.center;
                    self.handView.alpha = 1;
                    self.isPass = @"0";
                    self.stayTimeList = @"";
                }
            }
        }
    }
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.progressNum == self.testArr.count-1) {
        
    }else{
        NSLog(@"未答题到第十道");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"can"];
        DCCSVC * vc = [DCCSVC new];
        vc.progressNum = self.progressNum+1;
        vc.coinNumber = self.coinNumber;
        vc.testArr = self.testArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)makeNav
{
    UIImageView * bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    bgImage.image = [UIImage imageNamed:@"bgimage"];
    [self.view addSubview:bgImage];
    
    _circleView = [[ZLTimingView alloc] initWithFrame:CGRectMake(AdFloat(44), AdFloat(44)+AddNav(), AdFloat(80), AdFloat(80))];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)PostResult
{
    if (self.dissVC) return;
    
    if ([self.isPass isEqualToString:@"1"]) {
        self.coinNumber += 1;
        NSDictionary * paras = @{
                                 @"token":[[ZJNTool shareManager] getToken],
                                 @"module":@"2",
                                 @"state":@"0"
                                 };
        [[YuudeeRequest shareManager] request:Post url:AddCoin paras:paras completion:^(id response, NSError *error) {
            if ([response[@"code"] isEqual:@200]) {
                NSLog(@"增加金币成功");
            }else{
                NSLog(@"增加金币失败:%@",response[@"msg"]);
            }
        }];
    }
    NSString * allTime = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSinceDate:self.startDate]];
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"coursewareId":self.model.valueID, //课件id
                             @"scene":@"2", //训练,测试
                             @"module":@"2", //名词,动词,句子
                             @"startTime":[YuudeeDate getStartTime:self.startDate], //开始时间
                             @"pass":self.isPass, //是否通过
                             @"stayTimeList":self.stayTimeList, //停留时间
                             @"disTurbName":@"", //干扰名称
                             @"errorType":@"", //错误类型
                             @"stayTime":allTime, //总停留时间
                             @"groupId":[[NSUserDefaults standardUserDefaults] objectForKey:@"dcgid"], //组id
                             @"name":self.model.groupChar
                             };
    [[YuudeeRequest shareManager] request:Post url:PostResult paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [[NSUserDefaults standardUserDefaults] setObject:response[@"groupId"] forKey:@"dcgid"];
            NSLog(@"提交成功");
            if (self.progressNum == self.testArr.count-1) {
                NSLog(@"答题到第十道了");
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dcgid"];
                [self HTTPProgress];
            }
        }else{
            NSLog(@"提交失败");
        }
    }];
}
#pragma mark - 获取当前答题进度
-(void)HTTPProgress
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if (self.testToken.length > 0) {//单元测试
        paras[@"token"] = self.testToken;
    }else {
        paras[@"token"] = [[ZJNTool shareManager] getToken];
    }
    [[YuudeeRequest shareManager] request:Post url:GetProgress paras:paras completion:^(id response, NSError *error) {
        
        if ([response[@"code"] isEqual:@200]) {
            if (self.success) {
                self.success(response);
            }
            NSString *module2 = response[@"againModule"][@"module2"];
            if (self.testToken.length > 0) {//单元测试
                module2 = @"1";
            }
            if ([module2 isEqualToString:@"1"]) {
                NSLog(@"动词已通关");
                BOOL isPassAgain = NO;
                if ([response[@"playerModule"][@"player2"] isEqualToString:@"1"]) {
                    isPassAgain = YES;
                }
                QHWVC * vc = [QHWVC new];
                vc.isPass = 1;
                vc.type = 2;
                vc.isAgainPass = isPassAgain;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSLog(@"动词暂未通关,那么查询金币数量");
                [self HTTPGetCoin];
            }
        }else{
            if (self.failure) {
                self.failure(error);
            }
            NSLog(@"进度请求失败");
        }
    }];
}
#pragma mark - 查询累计的金币数量
-(void)HTTPGetCoin
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if (self.testToken.length > 0) {//单元测试
        paras[@"token"] = self.testToken;
    }else {
        paras[@"token"] = [[ZJNTool shareManager] getToken];
    }
    [[YuudeeRequest shareManager] request:Post url:GetCoin paras:paras completion:^(id response, NSError *error) {
        NSInteger coinNum = 0;
        if ([response[@"code"] isEqual:@200]) {
            NSLog(@"金币数访问成功");
            if (self.success) {
                self.success(response);
            }
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * array = response[@"data"];
                for (NSDictionary * item in array) {
                    if ([item[@"module"] isEqualToString:@"2"]) {
                        coinNum = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                    }
                }
            }
        }else{
            if (self.failure) {
                self.failure(error);
            }
            NSLog(@"金币数访问失败");
        }
        if (self.testToken.length > 0) {//单元测试
            coinNum = 10;
        }
        if (coinNum > 9) {
            NSLog(@"金币数量大于10,那么跳转强化物 %ld",coinNum);
            QHWVC * vc = [QHWVC new];
            vc.type = 2;
            [self .navigationController pushViewController:vc animated:YES];
        }else{
            NSLog(@"金币数量小于10,继续答题 %ld",coinNum);
            [self HTTPDC];
        }
    }];
}
#pragma mark - HTTP动词
-(void)HTTPDC
{
    [[YuudeeRequest shareManager] request:Post url:DCKJ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            if (self.success) {
                self.success(response);
            }
            NSMutableArray * array1 = [NSMutableArray array];
            NSMutableArray * array2 = [NSMutableArray array];
            for (NSDictionary * item in response[@"verbTraining"]) {
                [array1 addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"verbTest"]) {
                [array2 addObject:[GZPModel setModelWithDic:item]];
            }
            XLAgainVC * vc = [XLAgainVC new];
            vc.type = 2;
            vc.helpTime = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%@",response[@"helptime"][@"helpTime"]]];
            vc.trainArr = array1;
            vc.testArr = array2;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if (self.failure) {
                self.failure(error);
            }
            [self showHint:response[@"msg"]];
        }
    }];
}

- (void)testFunction {
    self.hasRight1 = YES;
    self.hasRight2 = YES;
    self.isTest = YES;
    [self viewDidLoad];
    self.model.verbChar = @"汽车1";
    self.isPass = @"1";

    UIView *view = [self.view viewWithTag:10];
    [self huaBanClick:[view gestureRecognizers][0]];
    self.isPass = @"0";
    _model.verbChar = @"汽车";
    [self huaBanClick:[view gestureRecognizers][0]];
    self.isPass = @"1";
    [self huaBanClick:[view gestureRecognizers][0]];
    self.hasRight1 = NO;
    [self huaBanClick:[view gestureRecognizers][0]];
    self.hasRight1 = YES;
    [self Gogo];
    [self overPlay];
    [self goNextVC];
    [self action];
    [self makeNav];
    [self homeClick];
    [self PostResult];
}

- (void)testRequestServerToken:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure{
    self.success = success;
    self.failure = failure;
    self.testToken = token;
    [self HTTPGetCoin];
}

- (void)testRequestServer1Token:(NSString *)token
                       success:(void (^) (id json))success
                       failure:(void (^)(NSError *error))failure{
    self.success = success;
    self.failure = failure;
    self.testToken = token;
    [self HTTPDC];
}

- (void)testRequestServer2Token:(NSString *)token
                        success:(void (^) (id json))success
                        failure:(void (^)(NSError *error))failure{
    self.success = success;
    self.failure = failure;
    self.testToken = token;
    [self HTTPProgress];
}

@end
