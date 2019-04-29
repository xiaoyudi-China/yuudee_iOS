//
//  MCCSVC.m
//  Yuudee2
//
//  Created by GZP on 2018/9/29.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "MCYYCSVC.h"
#import "QHWVC.h"
#import "ZLTimingView.h"
#define huaBanWith AdFloat(170)
#define huaBanHeight AdFloat(180)
#define huaBanGap AdFloat(10)
#define whiteWith AdFloat(234)
#define whiteHeight AdFloat(134)

@interface MCYYCSVC ()

@property (nonatomic,strong)NSTimer * goTimer;
@property(nonatomic,assign)NSInteger goTotal;

@property (nonatomic,strong)ZLTimingView *circleView; //倒计时
@property(nonatomic,strong)ZLSpreadView *handView; //小手

@property(nonatomic,strong)UIImageView * yuImage; //小鲸鱼

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

@property(nonatomic,strong)GZPModel * model;

@property(nonatomic,copy)NSString * isPass; //是否通过
@property(nonatomic,strong)NSDate * startDate; //开始答题时间
@property(nonatomic,copy)NSString * stayTimeList; //停留时间(逗号拼接)
@property(nonatomic,copy)NSString * disTurbName; //干扰课件名称
@property(nonatomic,copy)NSString * errorType; //错误类型

@property(nonatomic,assign)BOOL dissVC;
@property(nonatomic,assign)BOOL overCourse; //标识课件各种操作已完成,可以跳转了
/** 单元测试*/
@property (nonatomic, copy) void (^success) (id json);
@property (nonatomic, copy) void (^failure) (NSError *error);
@property (nonatomic, copy) NSString *testToken;
@property (nonatomic) BOOL isTest;

@end

@implementation MCYYCSVC
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goTotal = 0;

    self.dissVC = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"can"];
    self.startDate = [NSDate date];
    self.isPass = @"1";
    self.stayTimeList = @"1,1";
    self.disTurbName = @"";
    self.errorType = @"";
    _hasRight1 = NO;
    _hasRight2 = NO;
    self.model = self.yyTestArr[_progressNum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overPlay) name:@"OverPlay" object:nil];

    CGRect rect1 = [self returnRect:_model.cardAdjectiveChar];
    CGRect rect2 = [self returnRect:_model.cardNounChar];
    self.with1 = rect1.size.width;
    self.with2 = rect2.size.width;
    [self makeNav];
    [self makeUI];
}
-(CGRect)returnRect:(NSString *)string
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, whiteHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AdFloat(55)]} context:nil];
}
-(void)makeUI
{
    UIImageView * paperImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - AdFloat(628)) / 2, AdFloat(220), AdFloat(628), AdFloat(532))];
    paperImage.image = [UIImage imageNamed:@"v_apple_bg"];
    [self.view addSubview:paperImage];
    
    //课件图片
    self.kejianImage = [[UIImageView alloc] initWithFrame:CGRectMake(paperImage.centerX-AdFloat(250), paperImage.centerY-AdFloat(250), KeJianWH, KeJianWH)];
    [self showHudInView:self.view hint:nil];
    [self.kejianImage sd_setImageWithURL:[NSURL URLWithString:[_model.groupImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self hideHud];
    }];
    [self.view addSubview:self.kejianImage];
    [UIView animateWithDuration:1.5 animations:^{ //缩放
        self.kejianImage.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
    [UIView animateWithDuration:1.5 delay:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.kejianImage.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished) {
        NSInteger after = [[NSString stringWithFormat:@"%@",self.model.fristAssistTime]integerValue];
        if (!self.hasRight1) {
            self.circleView.animationTime = after;
            [self.circleView start];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.hasRight1) {
                for (int i = 0; i < 4; i ++) {
                    UIImageView * H = (id)[self.view viewWithTag:10+i];
                    GZPLabel * L = (id)[H viewWithTag:30+i];
                    if ([L.text isEqualToString:self.model.cardAdjectiveChar]) {
                        self.handView.center = H.center;
                        self.handView.alpha = 1;
                        if ([self.isPass isEqualToString:@"1"]) {
                            self.errorType = @"3";
                        }
                        self.isPass = @"0";
                        self.stayTimeList = @"";
                    }
                }
            }
        });
    }];
    [[PlayerManager shared] playLocalUrl:@"男-这是什么样的东西.MP3"];
    
    //下划线画板1
    _huaBan1 = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-whiteWith*2-AdFloat(50)) / 2, paperImage.bottom + AdFloat(50), whiteWith, whiteHeight)];
    _huaBan1.image = [UIImage imageNamed:@"n_blank_bg"];
    [self.view addSubview:_huaBan1];
    
    //白色View1
    _whiteL1 = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, _huaBan1.width, _huaBan1.height)];
    _whiteL1.center = _huaBan1.center;
    _whiteL1.backgroundColor = [UIColor whiteColor];
    _whiteL1.layer.masksToBounds = YES;
    _whiteL1.layer.cornerRadius = AdFloat(5);
    _whiteL1.alpha = 0;
    [self.view addSubview:_whiteL1];
    
    //fit1
    _fitL1 = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, self.with1, _whiteL1.height)];
    [_fitL1 fillWithText:self.model.cardAdjectiveChar color:@"92674a" font:AdFloat(55) aligenment:NSTextAlignmentCenter];
    _fitL1.center = _whiteL1.center;
    _fitL1.alpha = 0;
    [self.view addSubview:_fitL1];
    
    //发光亮图
    _lightImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-whiteWith*1.5)/2, _whiteL1.top-AdFloat(15), whiteWith*1.5, whiteHeight+AdFloat(30))];
    [self.view addSubview:_lightImage];
    [self.view insertSubview:_lightImage belowSubview:_whiteL1];
    
    //下划线画板2
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
    
    //fit2
    _fitL2 = [[GZPLabel alloc] initWithFrame:CGRectMake(0, 0, self.with2, _whiteL2.height)];
    [_fitL2 fillWithText:self.model.cardNounChar color:@"92674a" font:AdFloat(55) aligenment:NSTextAlignmentCenter];
    _fitL2.center = _whiteL2.center;
    _fitL2.alpha = 0;
    [self.view addSubview:_fitL2];
    
    [self.view insertSubview:_fitL1 aboveSubview:_whiteL2];
    
    //四个画板及控件
    CGFloat card_WH = AdFloat(120);
    for (int i = 0; i < 4; i ++) {
        //画板
        UIImageView * huaBan = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - huaBanWith*4 - huaBanGap*3) / 2 + (huaBanWith+huaBanGap)*i, Screen_H - AdFloat(140) - huaBanHeight, huaBanWith, huaBanHeight)];
        huaBan.image = [UIImage imageNamed:@"n_small_bg"];
        huaBan.userInteractionEnabled = YES;
        [huaBan addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huaBanClick:)]];
        huaBan.tag = 10 + i;
        [self.view addSubview:huaBan];
        
        NSArray * array = self.model.list;
        if (array.count-1 < i) continue;
        NSDictionary * dic = array[i];
        //课件图片
        UIImageView * pic = [[UIImageView alloc] initWithFrame:CGRectMake((huaBan.width - card_WH) / 2, (huaBan.height - card_WH) / 2 - AdFloat(20), card_WH, card_WH)];
        [pic sd_setImageWithURL:[NSURL URLWithString:[dic[@"cardAdjectiveImage"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        pic.contentMode = UIViewContentModeScaleAspectFit;
        [huaBan addSubview:pic];
        
        //文字
        GZPLabel * l = [[GZPLabel alloc] initWithFrame:CGRectMake(0, huaBan.height - AdFloat(15) - AdFloat(40), huaBan.width, AdFloat(40))];
        [l fillWithText:dic[@"cardAdjectiveChar"] color:@"6f4c28" font:AdFloat(34) aligenment:NSTextAlignmentCenter];
        l.tag = 30 + i;
        [huaBan addSubview:l];
    }
    UIImageView * huaBan1 = (id)[self.view viewWithTag:10];
    UIImageView * huaBan2 = (id)[self.view viewWithTag:11];
    [self.view insertSubview:huaBan1 aboveSubview:huaBan2];
    
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
    __weak typeof(self)weakSelf = self;

    GZPLabel * label = (id)[huaBan viewWithTag:huaBan.tag+20];
    if (self.isTest) {//单元测试
        label.text = [NSString stringWithFormat:@"汽车%d",(int)(huaBan.tag-9)];
    }
    if ([label.text isEqualToString:self.model.cardAdjectiveChar]) { //点击了第一个正确卡片
        [self.circleView stop];
        if ([self.isPass isEqualToString:@"1"]) {
            self.stayTimeList = [NSString stringWithFormat:@"%.f,",[self.circleView stop]];
        }
        [[PlayerManager shared] playNetUrl:self.model.cardAdjectiveRecord];
        self.hasRight1 = YES;
        self.handView.alpha = 0;
        [UIView animateWithDuration:1 animations:^{ //课件缩放
            huaBan.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:1.5 animations:^{
                huaBan.transform = CGAffineTransformMakeScale(0.8, 0.8);
                huaBan.center = self.huaBan1.center;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:1 animations:^{
                    self.huaBan1.alpha = 0;
                    huaBan.alpha = 0;
                    self.whiteL1.alpha = 1;
                    self.fitL1.alpha = 1;
                }completion:^(BOOL finished) { //开始第二张卡片的倒计时
                    NSInteger after = [[NSString stringWithFormat:@"%@",self.model.secondAssistTime] integerValue];
                    if (!self.hasRight2) {
                        self.circleView.animationTime = after;
                        [self.circleView start];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!weakSelf.hasRight2) {
                            for (int i = 0; i < 4; i ++) {
                                UIImageView * H2 = (id)[self.view viewWithTag:10+i];
                                GZPLabel * L2 = (id)[H2 viewWithTag:30+i];
                                if ([L2.text isEqualToString:self.model.cardNounChar]) {
                                    self.handView.center = H2.center;
                                    self.handView.alpha = 1;
                                    if ([self.isPass isEqualToString:@"1"]) {
                                        self.errorType = @"4";
                                    }
                                    self.isPass = @"0";
                                    self.stayTimeList = @"";
                                }
                            }
                        }
                    });
                }];
            }];
        }];
        
    }else if([label.text isEqualToString:self.model.cardNounChar]){ //点击了第二个正确卡片
        if (self.hasRight1) {
            for (int i = 0; i < 4; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10+i];
                GZPLabel * L = (id)[H viewWithTag:30 + i];
                if (![L.text isEqualToString:self.model.cardAdjectiveChar] && ![L.text isEqualToString:self.model.cardNounChar]) {
                    H.userInteractionEnabled = NO;
                }
            }
            [self.circleView stop];
            if ([self.isPass isEqualToString:@"1"]) {
                self.stayTimeList = [NSString stringWithFormat:@"%@%.f",self.stayTimeList,[self.circleView stop]];
            }
            [[PlayerManager shared] playNetUrl:self.model.cardNounRecord];
            self.hasRight2 = YES;
            self.handView.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                huaBan.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:1.5 animations:^{
                    huaBan.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    huaBan.center = self.huaBan2.center;
                }completion:^(BOOL finished) {
                    NSMutableArray * tempArr = [NSMutableArray array];
                    for (int i = 0; i < 4; i ++) {
                        UIImageView * H = (id)[self.view viewWithTag:10+i];
                        GZPLabel * L = (id)[H viewWithTag:30 + i];
                        if (![L.text isEqualToString:self.model.cardAdjectiveChar] && ![L.text isEqualToString:self.model.cardNounChar]) {
                            [tempArr addObject:H];
                        }
                    }
                    [UIView animateWithDuration:1 animations:^{
                        self.huaBan2.alpha = 0;
                        huaBan.alpha = 0;
                        for (UIImageView * item in tempArr) {
                            item.alpha = 0;
                        }
                        self.whiteL2.alpha = 1;
                        self.fitL2.alpha = 1;
                    }completion:^(BOOL finished) {
                        NSMutableArray * tempArr = [NSMutableArray array];
                        for (int i = 1; i < 10; i ++) {
                            [tempArr addObject:[NSString stringWithFormat:@"M%d.mp3",i]];
                        }
                        [[PlayerManager shared] playLocalUrl:tempArr[arc4random()%9]];
                        [UIView animateWithDuration:1 animations:^{
                            self.whiteL1.centerX = Screen_W/2-whiteWith/2+self.whiteL1.width/4;
                            self.whiteL2.centerX = Screen_W/2+whiteWith/2-self.whiteL2.width/4;
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
                            [UIView animateWithDuration:1.5 animations:^{
                                self.kejianImage.transform = CGAffineTransformMakeScale(1.2, 1.2);
                            }];
                            [UIView animateWithDuration:1 delay:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                                self.kejianImage.transform = CGAffineTransformMakeScale(1, 1);
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
                    }];
                }];
            }];
        }else{
            for (int i = 0; i < 4; i ++) {
                UIImageView * huaBan = (id)[self.view viewWithTag:10+i];
                GZPLabel * label = (id)[huaBan viewWithTag:30+i];
                if ([label.text isEqualToString:self.model.cardAdjectiveChar]) {
                    self.handView.center = huaBan.center;
                    self.handView.alpha = 1;
                    if ([self.isPass isEqualToString:@"1"]) {
                        self.errorType = @"4";
                    }
                    self.isPass = @"0";
                    self.stayTimeList = @"";
                }
            }
        }
    }else{ //点击了干扰卡片
        if ([self.isPass isEqualToString:@"1"]) {
            GZPLabel * label = (id)[huaBan viewWithTag:20+huaBan.tag];
            self.disTurbName = label.text;
            for (NSDictionary * item in self.model.list) {
                if ([label.text isEqualToString:item[@"cardAdjectiveChar"]]) {
                    if ([item[@"isAdj"] isEqualToString:@"1"]) {
                        self.errorType = @"1";
                    }else{
                        self.errorType = @"2";
                    }
                }
            }
        }
        self.isPass = @"0";
        self.stayTimeList = @"";
        
        if (!self.hasRight1) {
            for (int i = 0; i < 4; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10+i];
                GZPLabel * L = (id)[H viewWithTag:30 + i];
                if ([L.text isEqualToString:self.model.cardAdjectiveChar]) {
                    self.handView.alpha = 1;
                    self.handView.center = H.center;
                }
            }
        }else if (!self.hasRight2){
            for (int i = 0; i < 4; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10+i];
                GZPLabel * L = (id)[H viewWithTag:30 + i];
                if ([L.text isEqualToString:self.model.cardNounChar]) {
                    self.handView.alpha = 1;
                    self.handView.center = H.center;
                }
            }
        }
    }
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self PostResult];
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
    
    NSString * allTime = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSinceDate:self.startDate]];
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"coursewareId":self.model.valueID, //课件id
                             @"scene":@"3", //训练,测试
                             @"module":@"1", //名词,动词,句子
                             @"startTime":[YuudeeDate getStartTime:self.startDate], //开始时间
                             @"pass":self.isPass, //是否通过
                             @"stayTimeList":self.stayTimeList, //停留时间
                             @"disTurbName":self.disTurbName, //干扰名称
                             @"errorType":self.errorType, //错误类型
                             @"stayTime":allTime, //总停留时间
                             @"groupId":[[NSUserDefaults standardUserDefaults] objectForKey:@"mcgid"], //组id
                             @"name":self.model.groupChar
                             };
    [[YuudeeRequest shareManager] request:Post url:PostResult paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",response[@"groupId"]] forKey:@"mcgid"];
            NSLog(@"提交成功");
            
            if (self.progressNum == self.yyTestArr.count-1) {
                NSLog(@"答题到第十道了");
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"mcgid"];
                [self HTTPProgress];
            }else{
                NSLog(@"未答题到第十道");
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"can"];
                MCYYCSVC * vc = [MCYYCSVC new];
                self.progressNum += 1;
                vc.progressNum = self.progressNum;
                vc.yyTestArr = self.yyTestArr;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            NSLog(@"提交失败");
        }
    }];
}
#pragma mark - HTTP名词
-(void)HTTPYY
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if (self.testToken.length > 0) {//单元测试
        paras[@"token"] = self.testToken;
    }else {
        paras[@"token"] = [[ZJNTool shareManager] getToken];
    }
    [[YuudeeRequest shareManager] request:Post url:MCKJ paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            if (self.success) {
                self.success(response);
            }
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * item in response[@"nounSense"]) {
                [array addObject:[GZPModel setModelWithDic:item]];
            }
            
            GuoDuVC * vc = [GuoDuVC new];
            vc.type = 5;
            vc.yyTestArr = array;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if (self.failure) {
                self.failure(error);
            }
            [self showHint:response[@"msg"]];
        }
    }];
}
#pragma mark - 获取当前答题进度
-(void)HTTPProgress
{
    if ([PlayerManager shared].itemsArr.count > 0 || !self.overCourse) return;
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if (self.testToken.length > 0) {
        paras[@"token"] = self.testToken;
    }else {
        paras[@"token"] = [[ZJNTool shareManager]getToken];
    }
    [[YuudeeRequest shareManager] request:Post url:GetProgress paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            if (self.success) {
                self.success(response);
            }
            NSDictionary * list = response[@"list"];
            if ([list[@"noun"] isEqualToString:@"3"]) {
                [self HTTPYY];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            if (self.failure) {
                self.failure(error);
            }
            [self showHint:response[@"msg"]];
        }
    }];
}
- (void)testFunction {
    [self viewDidLoad];
    self.hasRight1 = YES;
    self.isPass = @"1";
    self.isTest = YES;
    for (int a =0 ; a<3; a++) {
        UIView *view = [self.view viewWithTag:10+a];
        if (a == 0) {
            self.model.cardAdjectiveChar = @"汽车1";
        }else if(a == 1) {
            self.model.cardAdjectiveChar = @"汽车2";
            self.model.cardNounChar = @"汽车2";
        }
        [self huaBanClick:[view gestureRecognizers][0]];
    }
    
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
    [self HTTPProgress];
}

@end
