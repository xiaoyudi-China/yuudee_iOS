//
//  JZFJCSVC.m
//  Yuudee2
//
//  Created by GZP on 2018/10/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "JZFJCSVC.h"
#import "ZLTimingView.h"
#import "JZFJXLVC.h"

#define huaBanWith AdFloat(170)
#define huaBanHeight AdFloat(180)
#define huaBanGap AdFloat(10)
#define whiteWith AdFloat(164)
#define whiteHeight AdFloat(96)

@interface JZFJCSVC ()

@property (nonatomic,strong)NSTimer * goTimer;
@property(nonatomic,assign)NSInteger goTotal;

@property (nonatomic,strong)ZLTimingView *circleView; //倒计时
@property(nonatomic,strong)ZLSpreadView *handView; //小手

@property(nonatomic,strong)UIImageView * yuImage; //小鲸鱼
@property(nonatomic,strong)GZPLabel * coinNum; //金币数量

@property(nonatomic,strong)UIImageView * kejianImage;

@property(nonatomic,assign)CGFloat with1; //记录两组字的宽度,用来位移
@property(nonatomic,assign)CGFloat with2;
@property(nonatomic,assign)CGFloat with3;
@property(nonatomic,assign)CGFloat with4;

@property(nonatomic,strong)UIImageView * lightImage;

@property(nonatomic,strong)NSMutableArray * rectWithArr;
@property(nonatomic,assign)NSInteger select; //标记点击了第几个正确卡片了

@property(nonatomic,strong)GZPModel * model;

@property(nonatomic,strong)NSMutableArray * finalArr;
@property(nonatomic,strong)NSMutableArray * dcArr;

@property(nonatomic,copy)NSString * isPass; //是否通过
@property(nonatomic,strong)NSDate * startDate; //开始答题时间
@property(nonatomic,copy)NSString * stayTimeList; //停留时间(逗号拼接)

@property(nonatomic,strong)UIImageView * addGoldImage; //增加的金币图片

@property(nonatomic,assign)BOOL dissVC;
@property(nonatomic,assign)BOOL overCourse; //标识课件各种操作已完成,可以跳转了

@end

@implementation JZFJCSVC

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overPlay) name:@"OverPlay" object:nil];

    self.goTotal = 0;

    self.dissVC = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"can"];
    _finalArr = [NSMutableArray array];
    _dcArr = [NSMutableArray array];
    _model = self.testArr[_progressNum];
    _select = 0;
    
    self.startDate = [NSDate date];
    self.isPass = @"1";
    self.stayTimeList = @"1,1,1,1";
    
    NSArray  * arr = @[self.model.cardOneChar,
                       self.model.cardTwoChar,
                       self.model.cardThreeChar,
                       self.model.cardFourChar
                       ];
    self.rectWithArr = [NSMutableArray array];
    for (NSString * item in arr) {
        CGRect rect = [self returnRect:item];
        [self.rectWithArr addObject:[NSString stringWithFormat:@"%f",rect.size.width]];
    }
    self.with1 = [self.rectWithArr[0] floatValue];
    self.with2 = [self.rectWithArr[1] floatValue];
    self.with3 = [self.rectWithArr[2] floatValue];
    self.with4 = [self.rectWithArr[3] floatValue];
    
    for (int i = 0; i < 3; i ++) {
        [self.dcArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",self.model.cardThreeChar,i+1]]];
    }
    
    [self makeNav];
    [self makeUI];
    
    [self showHudInView:self.view hint:nil];
    if (self.model.startSlideshow.length == 0) {
        [self hideHud];
    }
    NSArray * array = [self.model.startSlideshow componentsSeparatedByString:@","];
    for (int i = 0; i < array.count - 1; i ++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 10, 10)];
        [image sd_setImageWithURL:[NSURL URLWithString:[array[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self hideHud];
            if (image != nil) {
                [self.finalArr addObject:image];
            }
            if (i == array.count-2) {
                self.kejianImage.animationImages = self.finalArr;
                [self.kejianImage startAnimating];
            }
        }];
        [self.view addSubview:image];
    }
}
-(CGRect)returnRect:(NSString *)string
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, whiteHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AdFloat(45)]} context:nil];
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
    
    //课件图片
    self.kejianImage = [[UIImageView alloc] initWithFrame:CGRectMake(paperImage.centerX-AdFloat(250), paperImage.centerY-AdFloat(250), KeJianWH, KeJianWH)];
    self.kejianImage.animationDuration = 1.5;
    self.kejianImage.animationRepeatCount = 2;
    NSString * string = [self.model.startSlideshow componentsSeparatedByString:@","][0];
    [self.kejianImage sd_setImageWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [self.view addSubview:self.kejianImage];
    
    [[PlayerManager shared] playLocalUrl:@"男-谁在干什么.MP3"];
    NSInteger after1 = [[NSString stringWithFormat:@"%@",self.model.cardOneTime]integerValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.select == 0) {
            self.circleView.animationTime = after1;
            [self.circleView start];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.select == 0) {
                for (int i = 0; i < 4; i ++) {
                    UIImageView * H = (id)[self.view viewWithTag:10+i];
                    GZPLabel * L = (id)[H viewWithTag:30 + i];
                    if ([L.text isEqualToString:self.model.cardOneChar]) {
                        self.handView.center = H.center;
                        self.handView.alpha = 1;
                        self.isPass = @"0";
                        self.stayTimeList = @"";
                    }
                }
            }
        });
    });
    
    _lightImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-whiteWith*3)/2, paperImage.bottom + AdFloat(50) - AdFloat(15), whiteWith*3, whiteHeight+AdFloat(30))];
    [self.view addSubview:_lightImage];
    
    //动画笑脸
    self.addGoldImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.kejianImage.bottom + AdFloat(5), AdFloat(64), AdFloat(64))];
    self.addGoldImage.centerX = self.kejianImage.centerX;
    self.addGoldImage.image = [UIImage imageNamed:@"money"];
    self.addGoldImage.hidden = YES;
    [self.view addSubview:self.addGoldImage];
    
    //四个下划线画板及控件
    NSArray  * ziArr = @[self.model.cardOneChar,
                         self.model.cardTwoChar,
                         self.model.cardThreeChar,
                         self.model.cardFourChar
                         ];
    for (int i = 0; i < 4; i ++) {
        //画板
        UIImageView * huaBan = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-whiteWith*4-AdFloat(30)) / 2 + (whiteWith+AdFloat(10))*i, paperImage.bottom + AdFloat(50), whiteWith, whiteHeight)];
        huaBan.image = [UIImage imageNamed:@"n_blank4_bg"];
        huaBan.tag = 100 + i;
        [self.view addSubview:huaBan];
        
        //白色View
        UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(huaBan.left, huaBan.top, huaBan.width, huaBan.height)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = AdFloat(5);
        whiteView.alpha = 0;
        whiteView.tag = 200 + i;
        [self.view addSubview:whiteView];
        
        //fitL
        GZPLabel * fitL = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, [self.rectWithArr[i] floatValue], whiteView.height)];
        fitL.center = whiteView.center;
        [fitL fillWithText:ziArr[i] color:@"92674a" font:AdFloat(45) aligenment:NSTextAlignmentCenter];
        fitL.alpha = 0;
        fitL.tag = 300 + i;
        [self.view addSubview:fitL];
    }
    GZPLabel * fitL1 = (id)[self.view viewWithTag:300];
    UIView * view2 = (id)[self.view viewWithTag:201];
    [self.view insertSubview:fitL1 aboveSubview:view2];
    
    //四个素材画板及控件
    CGFloat mc_WH = AdFloat(120);
    NSArray * list = self.model.list;
    for (int i = 0; i < 4; i ++) {
        //画板
        UIImageView * huaBan = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - huaBanWith*4 - huaBanGap*3) / 2 + (huaBanWith+huaBanGap)*i, Screen_H - AdFloat(140) - huaBanHeight, huaBanWith, huaBanHeight)];
        huaBan.image = [UIImage imageNamed:@"n_small_bg"];
        huaBan.userInteractionEnabled = YES;
        [huaBan addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huaBanClick:)]];
        huaBan.tag = 10 + i;
        [self.view addSubview:huaBan];
        
        //课件图片
        NSDictionary * dic = list[i];
        UIImageView * keJian = [[UIImageView alloc] initWithFrame:CGRectMake((huaBan.width - mc_WH) / 2, (huaBan.height - mc_WH) / 2 - AdFloat(20), mc_WH, mc_WH)];
        NSString * imageURL = dic[@"cardImage"];
        NSString * cardStr = dic[@"cardChar"];
        if (![cardStr isEqualToString:self.model.cardThreeChar]) {
            [keJian sd_setImageWithURL:[NSURL URLWithString:[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }else{
            keJian.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",self.model.cardThreeChar]];
        }
        keJian.contentMode = UIViewContentModeScaleAspectFit;
        keJian.tag = 20 + i;
        [huaBan addSubview:keJian];
        
        //文字
        GZPLabel * l = [[GZPLabel alloc] initWithFrame:CGRectMake(0, huaBan.height - AdFloat(15) - AdFloat(40), huaBan.width, AdFloat(40))];
        [l fillWithText:dic[@"cardChar"] color:@"6f4c28" font:AdFloat(34) aligenment:NSTextAlignmentCenter];
        l.tag = 30 + i;
        [huaBan addSubview:l];
    }
    UIImageView * huaBan1 = (id)[self.view viewWithTag:10];
    UIImageView * huaBan2 = (id)[self.view viewWithTag:11];
    [self.view insertSubview:huaBan1 aboveSubview:huaBan2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 4; i ++) {
            UIImageView * H = (id)[self.view viewWithTag:10 + i];
            UIImageView * I = (id)[H viewWithTag:20 + i];
            GZPLabel * L = (id)[H viewWithTag:30 + i];
            if ([L.text isEqualToString:self.model.cardThreeChar]) {
                I.animationDuration = 1.5;
                I.animationRepeatCount = 1000;
                I.animationImages = self.dcArr;
                [I startAnimating];
            }
        }
    });
    //小手
    _handView = [[ZLSpreadView alloc] initWithFrame:CGRectMake(0, 0, AdFloat(180), AdFloat(180))];
    _handView.userInteractionEnabled = NO;
    _handView.alpha = 0;
    [_handView show];
    [self.view addSubview:_handView];
}
#pragma mark - 点击了四个画板
-(void)huaBanClick:(UITapGestureRecognizer *)tap
{
    UIImageView * huaBan = (id)tap.view;
    //下划线画板
    UIImageView * line1 = (id)[self.view viewWithTag:100];
    UIImageView * line2 = (id)[self.view viewWithTag:101];
    UIImageView * line3 = (id)[self.view viewWithTag:102];
    UIImageView * line4 = (id)[self.view viewWithTag:103];
    //白色View
    UIImageView * view1 = (id)[self.view viewWithTag:200];
    UIImageView * view2 = (id)[self.view viewWithTag:201];
    UIImageView * view3 = (id)[self.view viewWithTag:202];
    UIImageView * view4 = (id)[self.view viewWithTag:203];
    //自适应Label
    GZPLabel * fit1 = (id)[self.view viewWithTag:300];
    GZPLabel * fit2 = (id)[self.view viewWithTag:301];
    GZPLabel * fit3 = (id)[self.view viewWithTag:302];
    GZPLabel * fit4 = (id)[self.view viewWithTag:303];
    GZPLabel * label = (id)[huaBan viewWithTag:huaBan.tag + 20];
    if ([label.text isEqualToString:self.model.cardOneChar]) { //点击了第一个正确的卡片
        [self.circleView stop];
        if ([self.isPass isEqualToString:@"1"]) {
            self.stayTimeList = [NSString stringWithFormat:@"%.f,",[self.circleView stop]];
        }
        [[PlayerManager shared] playNetUrl:self.model.cardOneRecord];
        _select = 1;
        self.handView.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            huaBan.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:2 animations:^{
                huaBan.transform = CGAffineTransformMakeScale(0.5, 0.5);
                huaBan.center = line1.center;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:1 animations:^{
                    line1.alpha = 0;
                    huaBan.alpha = 0;
                    view1.alpha = 1;
                    fit1.alpha = 1;
                }completion:^(BOOL finished) {
                    NSInteger after2 = [[NSString stringWithFormat:@"%@",self.model.cardTwoTime]integerValue];
                    if (self.select == 1) {
                        self.circleView.animationTime = after2;
                        [self.circleView start];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self.select == 1) {
                            for (int i = 0; i < 4; i ++) {
                                UIImageView * H = (id)[self.view viewWithTag:10 + i];
                                GZPLabel * L = (id)[H viewWithTag:30 + i];
                                if ([L.text isEqualToString:self.model.cardTwoChar]) {
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
    }else if ([label.text isEqualToString:self.model.cardTwoChar]){ //点击了第二个正确的卡片
        if (self.select == 1) {
            [self.circleView stop];
            if ([self.isPass isEqualToString:@"1"]) {
                self.stayTimeList = [NSString stringWithFormat:@"%@%.f,",self.stayTimeList,[self.circleView stop]];
            }
            [[PlayerManager shared] playNetUrl:self.model.cardTwoRecord];
            self.select = 2;
            self.handView.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                huaBan.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:2 animations:^{
                    huaBan.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    huaBan.center = line2.center;
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:1 animations:^{
                        line2.alpha = 0;
                        huaBan.alpha = 0;
                        view2.alpha = 1;
                        fit2.alpha = 1;
                    }completion:^(BOOL finished) {
                        NSInteger after3 = [[NSString stringWithFormat:@"%@",self.model.cardThreeTime]integerValue];
                        if (self.select == 2) {
                            self.circleView.animationTime = after3;
                            [self.circleView start];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (self.select == 2) {
                                for (int i = 0; i < 4; i ++) {
                                    UIImageView * H = (id)[self.view viewWithTag:10 + i];
                                    GZPLabel * L = (id)[H viewWithTag:30 + i];
                                    if ([L.text isEqualToString:self.model.cardThreeChar]) {
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
        }else{
            for (int i = 0; i < 4; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10+i];
                GZPLabel * L = (id)[H viewWithTag:30 + i];
                if ([L.text isEqualToString:self.model.cardOneChar]) {
                    self.handView.center = H.center;
                    self.handView.alpha = 1;
                    self.isPass = @"0";
                    self.stayTimeList = @"";
                }
            }
        }
    }else if ([label.text isEqualToString:self.model.cardThreeChar]){ //点击了第三个正确的卡片
        if (self.select == 2) {
            [self.circleView stop];
            if ([self.isPass isEqualToString:@"1"]) {
                self.stayTimeList = [NSString stringWithFormat:@"%@%.f,",self.stayTimeList,[self.circleView stop]];
            }
            [[PlayerManager shared] playNetUrl:self.model.cardThreeRecord];
            self.select = 3;
            self.handView.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                huaBan.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:2 animations:^{
                    huaBan.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    huaBan.center = line3.center;
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:1 animations:^{
                        line3.alpha = 0;
                        huaBan.alpha = 0;
                        view3.alpha = 1;
                        fit3.alpha = 1;
                    }completion:^(BOOL finished) {
                        NSInteger after4 = [[NSString stringWithFormat:@"%@",self.model.cardFourTime]integerValue];
                        if (self.select == 3) {
                            self.circleView.animationTime = after4;
                            [self.circleView start];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (self.select == 3) {
                                for (int i = 0; i < 4; i ++) {
                                    UIImageView * H = (id)[self.view viewWithTag:10+i];
                                    GZPLabel * L = (id)[H viewWithTag:30 + i];
                                    if ([L.text isEqualToString:self.model.cardFourChar]) {
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
        }else{
            NSArray * arr = @[self.model.cardOneChar,
                              self.model.cardTwoChar,
                              self.model.cardThreeChar,
                              self.model.cardFourChar];
            for (int i = 0; i < 4; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10+i];
                GZPLabel * L = (id)[H viewWithTag:30 + i];
                if ([L.text isEqualToString:arr[self.select]]) {
                    self.handView.center = H.center;
                    self.handView.alpha = 1;
                    self.isPass = @"0";
                    self.stayTimeList = @"";
                }
            }
        }
        
    }else if ([label.text isEqualToString:self.model.cardFourChar]){ //点击了第四个正确的卡片
        if (self.select == 3) {
            [self.circleView stop];
            if ([self.isPass isEqualToString:@"1"]) {
                self.stayTimeList = [NSString stringWithFormat:@"%@%.f",self.stayTimeList,[self.circleView stop]];
            }
            [[PlayerManager shared] playNetUrl:self.model.cardFourRecord];
            _select = 4;
            self.handView.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                huaBan.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:2 animations:^{
                    huaBan.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    huaBan.center = line4.center;
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:1 animations:^{
                        line4.alpha = 0;
                        huaBan.alpha = 0;
                        view4.alpha = 1;
                        fit4.alpha = 1;
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
                        [UIView animateWithDuration:1 animations:^{ //位移融合
                            view1.centerX = Screen_W/2-whiteWith*3/2+whiteWith/2;
                            view2.centerX = Screen_W/2-whiteWith/2;
                            view3.centerX = Screen_W/2+whiteWith/2;
                            view4.centerX = Screen_W/2+whiteWith*3/2-whiteWith/2;
                            view2.width += AdFloat(50);
                            view3.width += AdFloat(50);
                        } completion:^(BOOL finished) {
                            self.lightImage.image = [UIImage imageNamed:@"ditu1"];
                            view1.backgroundColor = [UIColor clearColor];
                            view2.backgroundColor = [UIColor clearColor];
                            view3.backgroundColor = [UIColor clearColor];
                            view4.backgroundColor = [UIColor clearColor];
                        }];
                        [UIView animateWithDuration:1.3 animations:^{ //位移融合
                            CGFloat with = self.with1 + self.with2 + self.with3 + self.with4;
                            CGFloat cha = self.with1+self.with2-with/2;
                            fit1.centerX = Screen_W/2-(self.with1+self.with2)/2+cha-self.with1/2;
                            fit2.centerX = fit1.right+fit2.width/2;
                            fit3.centerX = fit2.right+fit3.width/2;
                            fit4.centerX = fit3.right+fit4.width/2;
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
            NSArray * arr = @[self.model.cardOneChar,
                              self.model.cardTwoChar,
                              self.model.cardThreeChar,
                              self.model.cardFourChar];
            for (int i = 0; i < 4; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10+i];
                GZPLabel * L = (id)[H viewWithTag:30 + i];
                if ([L.text isEqualToString:arr[self.select]]) {
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
        JZFJCSVC * vc = [JZFJCSVC new];
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
    _circleView.animationTime = 5;
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
                                 @"module":@"4",
                                 @"state":@"0"
                                 };
        [[YuudeeRequest shareManager] request:Post url:AddCoin paras:paras completion:^(id response, NSError *error) {
            if ([response[@"code"] isEqual:@200]) {
                NSLog(@"增加金币成功");
            }else{
                NSLog(@"增加金币失败");
                [self showHint:response[@"msg"]];
            }
        }];
    }
    NSString * allTime = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSinceDate:self.startDate]];
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"coursewareId":self.model.valueID, //课件id
                             @"scene":@"2", //训练,测试
                             @"module":@"4", //名词,动词,句子
                             @"startTime":[YuudeeDate getStartTime:self.startDate], //开始时间
                             @"pass":self.isPass, //是否通过
                             @"stayTimeList":self.stayTimeList, //停留时间
                             @"disTurbName":@"", //干扰名称
                             @"errorType":@"", //干扰类型
                             @"stayTime":allTime, //总停留时间
                             @"groupId":[[NSUserDefaults standardUserDefaults] objectForKey:@"jzgid2"], //组id
                             @"name":self.model.groupChar
                             };
    [[YuudeeRequest shareManager] request:Post url:PostResult paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",response[@"groupId"]] forKey:@"jzgid2"];
            NSLog(@"提交成功");
            if (self.progressNum == self.testArr.count-1) {
                NSLog(@"已答题到第十道");
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"jzgid2"];
                [self HTTPProgress];
            }
        }else{
            NSLog(@"提交失败");
            [self showHint:response[@"msg"]];
        }
    }];
}
#pragma mark - 获取当前答题进度
-(void)HTTPProgress
{
    [[YuudeeRequest shareManager] request:Post url:GetProgress paras:@{@"token":[[ZJNTool shareManager]getToken]} completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            if ([response[@"againModule"][@"module4"] isEqualToString:@"1"]) {
                NSLog(@"句子分解已通关");
                BOOL isPassAgain = NO;
                if ([response[@"playerModule"][@"player4"] isEqualToString:@"1"]) {
                    isPassAgain = YES;
                }
                QHWVC * vc = [QHWVC new];
                vc.isPass = 1;
                vc.type = 4;
                vc.isAgainPass = isPassAgain;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSLog(@"句子分解暂未通关,那么查询金币数量");
                [self HTTPGetCoin];
            }
        }
    }];
}
#pragma mark - 查询累计的金币数量
-(void)HTTPGetCoin
{
    [[YuudeeRequest shareManager] request:Post url:GetCoin paras:@{@"token":[[ZJNTool shareManager] getToken]} completion:^(id response, NSError *error) {
        NSInteger coinNum = 0;
        if ([response[@"code"] isEqual:@200]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * array = response[@"data"];
                for (NSDictionary * item in array) {
                    if ([item[@"module"] isEqualToString:@"4"]) {
                        coinNum = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                    }
                }
            }
        }
        if (coinNum > 9) {
            NSLog(@"金币数量大于10,那么跳转强化物 %ld",coinNum);
            QHWVC * vc = [QHWVC new];
            vc.type = 4;
            [self .navigationController pushViewController:vc animated:YES];
        }else{
            NSLog(@"金币数量小于10,继续答题 %ld",coinNum);
            [self HTTPJZFJ];
        }
    }];
}
#pragma mark - HTTP句子分解
-(void)HTTPJZFJ
{
    [[YuudeeRequest shareManager] request:Post url:JZFJ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSMutableArray * array1 = [NSMutableArray array];
            NSMutableArray * array2 = [NSMutableArray array];
            NSMutableArray * array3 = [NSMutableArray array];
            for (NSDictionary * item in response[@"sentenceResolveTraining"]) {
                [array1 addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"cosentenceResolveTestde"]) {
                [array2 addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"helptime"]) {
                [array3 insertObject:item[@"helpTime"] atIndex:[[NSString stringWithFormat:@"%@",item[@"sort"]]integerValue]-1];
            }
            XLAgainVC * vc = [XLAgainVC new];
            vc.type = 4;
            vc.helpTime = array3;
            vc.trainArr = array1;
            vc.testArr = array2;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self showHint:response[@"msg"]];
        }
    }];
}

- (void)testFunction {
    [self viewDidLoad];
    UIView *view = [self.view viewWithTag:10];
    [self huaBanClick:[view gestureRecognizers][0]];
    self.isPass = @"1";
    [self Gogo];
    [self overPlay];
    [self goNextVC];
    [self action];
    [self makeNav];
    [self homeClick];
    [self PostResult];
}

@end
