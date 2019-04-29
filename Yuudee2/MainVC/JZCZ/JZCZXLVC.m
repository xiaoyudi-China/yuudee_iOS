//
//  JZCZVC.m
//  Yuudee2
//
//  Created by GZP on 2018/10/10.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "JZCZXLVC.h"
#import "JZCZCSVC.h"

#define ziWith AdFloat(234-0)
#define ziHeight AdFloat(134-0)

@interface JZCZXLVC ()

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

@property(nonatomic,strong)NSMutableArray * finalArr; //组合帧动画
@property(nonatomic,strong)NSMutableArray * dcArr; //动词帧动画

@property(nonatomic,copy)NSString * isPass; //是否通过
@property(nonatomic,strong)NSDate * startDate; //开始答题时间
@property(nonatomic,copy)NSString * stayTimeList; //停留时间(逗号拼接)

@property(nonatomic,assign)BOOL dissVC;
@property(nonatomic,assign)BOOL overCourse; //标识课件各种操作已完成,可以跳转了

@end

@implementation JZCZXLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overPlay) name:@"OverPlay" object:nil];

    self.goTotal = 0;

    self.dissVC = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"can"];
    _hasRight1 = NO;
    _hasRight2 = NO;
    self.finalArr = [NSMutableArray array];
    self.dcArr = [NSMutableArray array];
    self.model = self.trainArr[_progressNum];
    
    self.startDate = [NSDate date];
    self.isPass = @"1";
    self.stayTimeList = @"1,1";
    
    CGRect rect1 = [self returnRect:self.model.cardOneChar];
    CGRect rect2 = [self returnRect:self.model.cardTwoChar];
    self.with1 = rect1.size.width;
    self.with2 = rect2.size.width;
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
    NSArray * array2 = [self.model.cardTwoImage componentsSeparatedByString:@","];
    for (int i = 0; i < array2.count - 1; i ++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 10, 10)];
        [image sd_setImageWithURL:[NSURL URLWithString:[array2[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.dcArr addObject:image];
        }];
        [self.view addSubview:image];
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
    NSString * string = [self.model.startSlideshow componentsSeparatedByString:@","][0];
    [self.kejianImage sd_setImageWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    self.kejianImage.animationDuration = 1.5;
    self.kejianImage.animationRepeatCount = 2;
    self.kejianImage.userInteractionEnabled = YES;
    [self.kejianImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(errorClick)]];
    [self.view addSubview:self.kejianImage];
    
    [[PlayerManager shared] playLocalUrl:@"男-谁在干什么.MP3"];
    NSInteger after1 = 1;
    if (!self.dissVC) {
        if (self.helpTime.count > 0) {
            after1 = [[NSString stringWithFormat:@"%@",self.helpTime[0]]integerValue];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.hasRight1 && !self.dissVC) {
            self.circleView.animationTime = after1;
            [self.circleView start];
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 + after1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.hasRight1 && !self.dissVC) {
            for (int i = 0; i < 2; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10 + i];
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
    
    //画板1
    _huaBan1 = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-AdFloat(468+50)) / 2, paperImage.bottom + AdFloat(50), AdFloat(234), AdFloat(134))];
    _huaBan1.image = [UIImage imageNamed:@"n_blank_bg"];
    _huaBan1.userInteractionEnabled = YES;
    [_huaBan1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(errorClick)]];
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
    [_fitL1 fillWithText:self.model.cardOneChar color:@"92674a" font:AdFloat(55) aligenment:NSTextAlignmentCenter];
    _fitL1.center = _whiteL1.center;
    _fitL1.alpha = 0;
    [self.view addSubview:_fitL1];
    
    //发光亮图
    _lightImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W-ziWith*2)/2, _whiteL1.top-AdFloat(15), ziWith*2, ziHeight+AdFloat(30))];
    [self.view addSubview:_lightImage];
    [self.view insertSubview:_lightImage belowSubview:_whiteL1];
    
    //画板2
    _huaBan2 = [[UIImageView alloc] initWithFrame:CGRectMake(_huaBan1.right + AdFloat(50), _huaBan1.top, _huaBan1.width, _huaBan1.height)];
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
    [_fitL2 fillWithText:self.model.cardTwoChar color:@"92674a" font:AdFloat(55) aligenment:NSTextAlignmentCenter];
    _fitL2.center = _whiteL2.center;
    _fitL2.alpha = 0;
    [self.view addSubview:_fitL2];
    
    [self.view insertSubview:_fitL1 aboveSubview:_whiteL2];
    
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
        NSDictionary * dic = list[i];
        UIImageView * keJian = [[UIImageView alloc] initWithFrame:CGRectMake((HuaBan_W - mc_WH) / 2, (HuaBan_H - mc_WH) / 2 - AdFloat(40), mc_WH, mc_WH)];
        if ([dic[@"cardChar"] isEqualToString:self.model.cardOneChar]) {
            [keJian sd_setImageWithURL:[NSURL URLWithString:[dic[@"cardImage"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }else{
            NSString * imageURL = [dic[@"cardImage"] componentsSeparatedByString:@","][0];
            [keJian sd_setImageWithURL:[NSURL URLWithString:[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
        keJian.tag = 20 + i;
        [huaBan addSubview:keJian];
        
        //文字
        GZPLabel * label = [[GZPLabel alloc] initWithFrame:CGRectMake(0, huaBan.height - AdFloat(80+15), HuaBan_W, AdFloat(80))];
        [label fillWithText:dic[@"cardChar"] color:@"6f4c28" font:AdFloat(45) aligenment:NSTextAlignmentCenter];
        label.tag = 30 + i;
        [huaBan addSubview:label];
    }
    
    //延迟执行吃的动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 2; i ++) {
            UIImageView * H = (id)[self.view viewWithTag:10 + i];
            UIImageView * image = (id)[H viewWithTag:20 + i];
            GZPLabel * L = (id)[H viewWithTag:30 + i];
            if ([L.text isEqualToString:self.model.cardTwoChar]) {
                image.animationImages = self.dcArr;
                image.animationDuration = 1.5;
                image.animationRepeatCount = 1000;
                [image startAnimating];
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
#pragma mark - 点击了画板
-(void)huaBanClick:(UITapGestureRecognizer *)tap
{
    UIImageView * huaBan = (id)tap.view;
    GZPLabel * label = (id)[self.view viewWithTag:20+huaBan.tag];
    
    if ([label.text isEqualToString:self.model.cardOneChar]) { //点击了第一个正确的卡片
        if ([_isPass isEqualToString:@"1"]) {
            self.stayTimeList = [NSString stringWithFormat:@"%.f,",[self.circleView stop]];
        }
        [[PlayerManager shared] playNetUrl:self.model.cardOneRecord];
        _hasRight1 = YES;
        self.handView.alpha = 0;
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
                    NSInteger after2 = 1;
                    if (!self.dissVC) {
                        if (self.helpTime.count > 0) {
                            after2 = [[NSString stringWithFormat:@"%@",self.helpTime[1]]integerValue];
                        }
                    }
                    if (!self.hasRight2 && !self.dissVC) {
                        self.circleView.animationTime = after2;
                        [self.circleView start];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!self.hasRight2 && !self.dissVC) {
                            for (int i = 0; i < 2; i ++) {
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
        
    }else{ //点击了第二个正确的卡片
        
        if (_hasRight1) {
            if ([self.isPass isEqualToString:@"1"]) {
                self.stayTimeList = [NSString stringWithFormat:@"%@%.f",self.stayTimeList,[self.circleView stop]];
            }
            [[PlayerManager shared] playNetUrl:self.model.cardTwoRecord];
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
        }else{ //暂未点击第一个正确的卡片
            for (int i = 0; i < 2; i ++) {
                UIImageView * H = (id)[self.view viewWithTag:10 + i];
                GZPLabel * L = (id)[H viewWithTag:30 + i];
                if ([L.text isEqualToString:self.model.cardOneChar]) {
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
    [self PostResult];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.progressNum == self.trainArr.count-1) {
        NSLog(@"答题到第十道了");
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"jzgid1"];
        GuoDuVC * vc = [GuoDuVC new];
        vc.type = 3;
        vc.testArr = self.testArr;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"未答题到第十道");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"can"];
        JZCZXLVC * vc = [JZCZXLVC new];
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
    NSString * allTime = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSinceDate:self.startDate]];
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"coursewareId":self.model.valueID, //课件id
                             @"scene":@"1", //训练,测试
                             @"module":@"3", //名词,动词,句子
                             @"startTime":[YuudeeDate getStartTime:self.startDate], //开始时间
                             @"pass":self.isPass, //是否通过
                             @"stayTimeList":self.stayTimeList, //停留时间
                             @"disTurbName":@"", //干扰名称
                             @"errorType":@"", //干扰类型
                             @"stayTime":allTime, //总停留时间
                             @"groupId":[[NSUserDefaults standardUserDefaults] objectForKey:@"jzgid1"], //组id
                             @"name":self.model.groupChar
                             };
    [[YuudeeRequest shareManager] request:Post url:PostResult paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",response[@"groupId"]] forKey:@"jzgid1"];
            NSLog(@"提交成功");
        }else{
            NSLog(@"提交失败");
        }
    }];
}
-(void)errorClick
{
    if (!_hasRight1) {
        for (int i = 0; i < 2; i ++) {
            UIImageView * H = (id)[self.view viewWithTag:10 + i];
            GZPLabel * L = (id)[H viewWithTag:30 + i];
            if ([L.text isEqualToString:self.model.cardOneChar]) {
                self.handView.center = H.center;
                self.handView.alpha = 1;
                self.isPass = @"0";
                self.stayTimeList = @"";
            }
        }
    }else{
        if (!_hasRight2) {
            for (int i = 0; i < 2; i ++) {
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
    }
}

- (void)testFunction {
    [self viewDidLoad];
    UIView *view = [self.view viewWithTag:10];
    [self huaBanClick:[view gestureRecognizers][0]];
    self.hasRight1 = YES;
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
