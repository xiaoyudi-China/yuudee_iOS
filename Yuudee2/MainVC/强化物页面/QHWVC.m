//
//  QHWVC.m
//  Yuudee2
//
//  Created by GZP on 2018/10/11.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "QHWVC.h"
#import "XPQGifView.h"
#import "UIImage+GIF.h"
#import "DCXLVC.h"
#import "JZCZXLVC.h"
#import "JZFJXLVC.h"
#import "ZJNParentCenterViewController.h"

@interface QHWVC ()

@property(nonatomic,strong)XPQGifView * gif;

@property(nonatomic,strong)GZPLabel * coinNum; //金币数量
@property(nonatomic,strong)NSMutableArray * restArr; //剩余积木数组

@property(nonatomic,assign)BOOL dissVC; //标识页面是否已消失

@end

@implementation QHWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restArr = [NSMutableArray array];
    self.dissVC = NO;
    
    UIImageView * backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"qhwbg"];
    [self.view addSubview:backImage];
    
    UIImageView * coinImage = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W / 2 - AdFloat(75), AdFloat(130), AdFloat(64), AdFloat(64))];
    coinImage.image = [UIImage imageNamed:@"money"];
    [self.view addSubview:coinImage];
    
    GZPLabel * X = [[GZPLabel alloc] initWithFrame:CGRectMake(coinImage.right+AdFloat(10), coinImage.top, coinImage.width/2, coinImage.height)];
    [X fillWithText:@"X" color:@"92674a" font:AdFloat(26) aligenment:NSTextAlignmentCenter];
    X.font = [UIFont boldSystemFontOfSize:AdFloat(26)];
    [self.view addSubview:X];
    
    _coinNum = [[GZPLabel alloc] initWithFrame:CGRectMake(X.right, X.top - AdFloat(1), coinImage.width, coinImage.height)];
    [_coinNum fillWithText:@"" color:@"92674a" font:AdFloat(34) aligenment:NSTextAlignmentLeft];
    _coinNum.font = [UIFont boldSystemFontOfSize:AdFloat(34)];
    [self.view addSubview:_coinNum];
    
    //home按钮
    UIButton * homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W - AdFloat(44+84), AdFloat(44)+AddNav(), AdFloat(84), AdFloat(84))];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button_press"] forState:UIControlStateHighlighted];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    
    //gif
    _gif = [[XPQGifView alloc] initWithFrame:CGRectMake(0, 0, AdFloat(593), AdFloat(428+10))];
    _gif.center = backImage.center;
    _gif.sleep = 0.5;
    [self.view addSubview:_gif];

    NSArray * imageArr = @[@"k1",@"k2",@"k3",@"k4",@"k5",@"k6",@"k7",@"k8",@"k9"];
    for (int i = 0; i < imageArr.count; i ++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AdFloat(593), AdFloat(428))];
        image.centerX = backImage.centerX;
        image.centerY = backImage.centerY-AdFloat(4);
        image.image = [UIImage imageNamed:imageArr[i]];
        image.tag = i + 1;
        [self.view addSubview:image];
    }

    ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    if (![model.IsRemind isEqualToString:@"1"]) { //已完善儿童信息
        [self HTTPCoin];
    }else{
        self.coinNum.text = @"10";
    }
    [self HTTPRest];
}
#pragma mark - 查询累计的金币数量
-(void)HTTPCoin
{
    [[YuudeeRequest shareManager] request:Post url:GetCoin paras:@{@"token":[[ZJNTool shareManager] getToken]} completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSArray * array = response[@"data"];
            if (self.type - 1 < array.count) {
                NSDictionary * dic = array[self.type-1];
                NSString * gold = [NSString stringWithFormat:@"%@",dic[@"gold"]];
                self.coinNum.text = [NSString stringWithFormat:@"%ld",[gold integerValue]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSString * disStr = [NSString stringWithFormat:@"%ld",[gold integerValue] - 10];
                    if (self.isPass) {
                        disStr = @"0";
                    }else{
                        [self HTTPDisCoin];
                    }
                    [UIView animateWithDuration:0.5 animations:^{
                        self.coinNum.text = disStr;
                    }];
                });
            }
        }else{
            NSLog(@"查询金币失败:%@",response[@"msg"]);
        }
    }];
}
#pragma mark - 查询剩余积木数
-(void)HTTPRest
{
    [[YuudeeRequest shareManager] request:Post url:Rest paras:@{@"token":[[ZJNTool shareManager] getToken],@"module":[NSString stringWithFormat:@"%ld",self.type]} completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            
            for (NSDictionary * item in response[@"data"]) {
                [self.restArr addObject:[NSString stringWithFormat:@"%@",item[@"number"]]];
            }
            NSLog(@"剩余积木数:%ld %@",self.restArr.count,self.restArr);
            
            //将用掉的积木隐藏掉
            for (int i = 1; i < 10; i ++) {
                BOOL exist = NO;
                for (NSString * item in self.restArr) {
                    if ([item isEqualToString:[NSString stringWithFormat:@"%d",i]]) {
                        exist = YES;
                    }
                }
                if (!exist) {
                    UIImageView * image = (id)[self.view viewWithTag:i];
                    image.hidden = YES;
                }
            }
            
            //处理gif逻辑
            NSInteger arc = 1;
            NSMutableArray * allArray = [NSMutableArray array];
            for (int i = 1; i < 12; i ++) {
                [allArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            NSString * old = [[NSUserDefaults standardUserDefaults] objectForKey:@"qhw"];
            NSArray * oldArray = [old componentsSeparatedByString:@","];
            if (old.length == 0 || oldArray.count == 12) { //初始状态和循环完一遍
                if (oldArray.count == 12) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"qhw"];
                }
                arc = arc4random()%11 + 1;
                NSString * new = [@"" stringByAppendingString:[NSString stringWithFormat:@"%ld,",arc]];
                [[NSUserDefaults standardUserDefaults] setObject:new forKey:@"qhw"];
                
            }else{ //已随机过
                if (self.restArr.count == 9) { //换
                    NSMutableArray * muOldArr = [NSMutableArray arrayWithArray:oldArray];
                    [muOldArr removeLastObject];
                    NSMutableArray * allArray2 = [NSMutableArray arrayWithArray:allArray];
                    for (NSString * item in allArray) {
                        for (NSString * item2 in muOldArr) {
                            if ([item isEqualToString:item2]) {
                                [allArray2 removeObject:item];
                            }
                        }
                    }
                    NSInteger count = allArray2.count;
                    NSInteger a = arc4random()%count;
                    NSString * arcString = allArray2[a];
                    arc = [arcString integerValue];
                    
                    NSString * new = [old stringByAppendingString:[NSString stringWithFormat:@"%@,",arcString]];
                    [[NSUserDefaults standardUserDefaults] setObject:new forKey:@"qhw"];
                    
                }else{ //不换
                    for (int i = 0; i < oldArray.count; i ++) {
                        if (i == oldArray.count - 2) {
                            NSString * item = oldArray[i];
                            arc = [item integerValue];
                        }
                    }
                }
            }
            self.gif.gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"qhw%ld",arc] ofType:@"gif"]];
            [self.gif start];
            
            //通关那么全部飞走
            if (self.isPass) {
                NSLog(@"通关了,那么剩余积木全部飞走");
                
                [self resetJiMu];
                
                for (int i = 0; i < self.restArr.count; i ++) {
                    NSString * item = self.restArr[i];
                    UIImageView * disImage = (id)[self.view viewWithTag:[item integerValue]];
                    [UIView animateWithDuration:3 animations:^{
                        disImage.center = CGPointMake(Screen_W/2*3, AdFloat(200));
                    }completion:^(BOOL finished) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (self.dissVC) return ;
                            if (i == self.restArr.count-1) {
                                if (self.type == 1 || self.type == 2 || self.type == 4) {
                                    if (self.isAgainPass) {
                                        if (self.type == 4) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"Success" object:nil];
                                        }
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    }else{
                                        PassVC * vc = [PassVC new];
                                        vc.type = self.type;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }
                                }else{
                                    [self GoToJZFJ];
                                }
                            }
                        });
                    }];
                }
                
            }else{ //非通关,那么在剩余积木中随机一块飞走
                NSLog(@"未通关,那么随机一块积木飞走");

                NSInteger count = arc4random()%self.restArr.count + 1;
                NSLog(@"随机出来的积木编号:%ld",count);
                
                //已完善儿童信息,那么将随机的积木编号上传
                ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
                NSString * number = self.restArr[count-1];
                if (![model.IsRemind isEqualToString:@"1"]) {
                    [self HTTPPostNum:[number integerValue]];
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.coinNum.text = @"0";
                    });
                }
                
                //找到图片,执行动画
                UIImageView * disImage = (id)[self.view viewWithTag:[number integerValue]];
                [self.view insertSubview:disImage atIndex:13];
                [UIView animateWithDuration:3 animations:^{
                    disImage.center = CGPointMake(Screen_W/2*3, AdFloat(200));
                }completion:^(BOOL finished) {
                    NSInteger sleep = 10;
                    if (self.restArr.count == 1) {
                        sleep = 60;
                    }else{
                        sleep = 10;
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sleep * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self.dissVC) return ;
                        
                        if ([model.IsRemind isEqualToString:@"1"]) {
                            NSLog(@"未完善儿童信息,那么跳转家长中心");
                            ZJNParentCenterViewController *viewC = [[ZJNParentCenterViewController alloc]init];
                            [self.navigationController pushViewController:viewC animated:YES];
                        }else{
                            if (self.type == 1) {
                                [self HTTPMC];
                            }else if (self.type == 2){
                                [self HTTPDC];
                            }else if (self.type == 3){
                                [self HTTPJZCZ];
                            }else if (self.type == 4){
                                [self HTTPJZFJ];
                            }
                        }
                    });
                }];
            }
        }else if ([response[@"code"] isEqual:@205]){
            NSInteger count = arc4random()%10 + 1;
            UIImageView * disImage = (id)[self.view viewWithTag:count];
            [self.view insertSubview:disImage atIndex:13];
            [UIView animateWithDuration:3 animations:^{
                disImage.center = CGPointMake(Screen_W/2*3, AdFloat(200));
            }completion:^(BOOL finished) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
}
#pragma mark - HTTP将随机的积木编号上传
-(void)HTTPPostNum:(NSInteger)number
{
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"module":[NSString stringWithFormat:@"%ld",self.type],
                             @"number":[NSNumber numberWithInteger:number]
                             };
    NSLog(@"%@",paras);
    [[YuudeeRequest shareManager] request:Post url:Delete paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSLog(@"积木编号上传成功,%@",response);
        }else{
            NSLog(@"%@",response[@"msg"]);
//            [self showHint:response[@"msg"]];
        }
    }];
}
#pragma mark - HTTP名词
-(void)HTTPMC
{
    NSLog(@"token:%@",[[ZJNTool shareManager] getToken]);
    [[YuudeeRequest shareManager] request:Post url:MCKJ paras:@{@"token":[[ZJNTool shareManager] getToken]} completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSMutableArray * MCTrainArr = [NSMutableArray array];
            NSMutableArray * MCTestArr = [NSMutableArray array];
            NSMutableArray * MCYYTestArr = [NSMutableArray array];
            for (NSDictionary * item in response[@"nounTraining"]) {
                [MCTrainArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"nounTest"]) {
                [MCTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"nounSense"]) {
                [MCYYTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            XLAgainVC * vc = [XLAgainVC new];
            vc.type = 1;
            vc.helpTime = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%@",response[@"time"][@"helpTime"]]];
            vc.trainArr = MCTrainArr;
            vc.testArr = MCTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
//            [self showHint:response[@"msg"]];
        }
    }];
}
#pragma mark - HTTP动词
-(void)HTTPDC
{
    [[YuudeeRequest shareManager] request:Post url:DCKJ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
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
//            [self showHint:response[@"msg"]];
        }
    }];
}
#pragma mark - HTTP句子成组
-(void)HTTPJZCZ
{
    [[YuudeeRequest shareManager] request:Post url:JZCZ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSMutableArray * JZCZTrainArr = [NSMutableArray array];
            NSMutableArray * JZCZTestArr = [NSMutableArray array];
            NSMutableArray * JZCZHelpTime = [NSMutableArray array];
            for (NSDictionary * item in response[@"sentenceGroupTraining"]) {
                [JZCZTrainArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"sentenceGroupTest"]) {
                [JZCZTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"helptime"]) {
                [JZCZHelpTime insertObject:item[@"helpTime"] atIndex:[[NSString stringWithFormat:@"%@",item[@"sort"]]integerValue]-1];
            }
            XLAgainVC * vc = [XLAgainVC new];
            vc.type = 3;
            vc.helpTime = JZCZHelpTime;
            vc.trainArr = JZCZTrainArr;
            vc.testArr = JZCZTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
#pragma mark - HTTP句子分解
-(void)HTTPJZFJ
{
    [[YuudeeRequest shareManager] request:Post url:JZFJ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSMutableArray * JZFJTrainArr = [NSMutableArray array];
            NSMutableArray * JZFJTestArr = [NSMutableArray array];
            NSMutableArray * JZFJHelpTime = [NSMutableArray array];
            for (NSDictionary * item in response[@"sentenceResolveTraining"]) {
                [JZFJTrainArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"cosentenceResolveTestde"]) {
                [JZFJTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"helptime"]) {
                [JZFJHelpTime insertObject:item[@"helpTime"] atIndex:[[NSString stringWithFormat:@"%@",item[@"sort"]]integerValue]-1];
            }
            XLAgainVC * vc = [XLAgainVC new];
            vc.type = 4;
            vc.helpTime = JZFJHelpTime;
            vc.trainArr = JZFJTrainArr;
            vc.testArr = JZFJTestArr;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
//            [self showHint:response[@"msg"]];
        }
    }];
}
#pragma mark - HTTP句子成组通关,那么跳转句子分解
-(void)GoToJZFJ
{
    [[YuudeeRequest shareManager] request:Post url:JZFJ paras:nil completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSMutableArray * JZFJTrainArr = [NSMutableArray array];
            NSMutableArray * JZFJTestArr = [NSMutableArray array];
            NSMutableArray * JZFJHelpTime = [NSMutableArray array];
            for (NSDictionary * item in response[@"sentenceResolveTraining"]) {
                [JZFJTrainArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"cosentenceResolveTestde"]) {
                [JZFJTestArr addObject:[GZPModel setModelWithDic:item]];
            }
            for (NSDictionary * item in response[@"helptime"]) {
                [JZFJHelpTime insertObject:item[@"helpTime"] atIndex:[[NSString stringWithFormat:@"%@",item[@"sort"]]integerValue]-1];
            }
            if (self.isAgainPass) {
                JZFJXLVC * vc = [JZFJXLVC new];
                vc.helpTime = JZFJHelpTime;
                vc.trainArr = JZFJTrainArr;
                vc.testArr = JZFJTestArr;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                PassVC * vc = [PassVC new];
                vc.type = 3;
                vc.JZFJTrainArr = JZFJTrainArr;
                vc.JZFJTestArr = JZFJTestArr;
                vc.JZFJHelpTime = JZFJHelpTime;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
//            [self showHint:response[@"msg"]];
        }
    }];
}
#pragma mark - HTTP减金币
-(void)HTTPDisCoin
{
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"module":[NSString stringWithFormat:@"%ld",self.type],
                             @"state":@"1"
                             };
    NSLog(@"%@",paras);
    [[YuudeeRequest shareManager] request:Post url:AddCoin paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSLog(@"减少金币成功 %@",response);
        }else{
//            [self showHint:response[@"msg"]];
        }
    }];
}
-(void)homeClick
{
    self.dissVC = YES;
    if (self.type == 4 && self.isPass) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Success" object:nil];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)resetJiMu
{
    NSDictionary * paras = @{
                             @"token":[[ZJNTool shareManager] getToken],
                             @"module":[NSString stringWithFormat:@"%ld",self.type],
                             };
    [[YuudeeRequest shareManager] request:Post url:ResetJiMu paras:paras completion:^(id response, NSError *error) {
        if ([response[@"code"] isEqual:@200]) {
            NSLog(@"通关重置积木成功");
        }else{
            NSLog(@"重置积木失败");
        }
    }];
}

@end
