//
//  GuoDuVC.m
//  Yuudee2
//
//  Created by GZP on 2018/9/29.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "GuoDuVC.h"
#import "DCCSVC.h"
#import "JZCZCSVC.h"
#import "JZFJCSVC.h"
#import "MCYYCSVC.h"

@interface GuoDuVC ()
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSInteger count;

@property(nonatomic,assign)NSInteger goldMC; //读取累计的金币数量
@property(nonatomic,assign)NSInteger goldDC;
@property(nonatomic,assign)NSInteger goldJZCZ;
@property(nonatomic,assign)NSInteger goldJZFJ;

@end

@implementation GuoDuVC
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self HTTPGold];
    self.view.backgroundColor = [@"FEFDEB" hexStringToColor];
    _count = 3;
    
    CGFloat with = AdFloat(750);
    CGFloat height = AdFloat(880);
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - with) / 2, AdFloat(80), with, height)];
    image.image = [UIImage imageNamed:@"page1"];
    [self.view addSubview:image];
    
    GZPLabel * number = [[GZPLabel alloc] initWithFrame:CGRectMake((Screen_W-AdFloat(150)) / 2, image.bottom - AdFloat(50), AdFloat(150), AdFloat(150))];
    [number fillWithText:[NSString stringWithFormat:@"%ld",_count] color:@"ffa54f" font:55 aligenment:NSTextAlignmentCenter];
    number.font = [UIFont boldSystemFontOfSize:55];
    number.tag = 10;
    [self.view addSubview:number];
    
    [[PlayerManager shared] playLocalUrl:@"女-让我们测试一下吧.MP3"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    });
}
#pragma mark - HTTP请求当前金币数量
-(void)HTTPGold
{
    [[YuudeeRequest shareManager] request:Post url:GetCoin paras:@{@"token":[[ZJNTool shareManager]getToken]} completion:^(id response, NSError *error) {
        self.goldMC = 0;
        self.goldDC = 0;
        self.goldJZCZ = 0;
        self.goldJZFJ = 0;
        if ([response[@"code"] isEqual:@200]) {
            NSArray * array = response[@"data"];
            for (NSDictionary * item in array) {
                if ([item[@"module"] isEqualToString:@"1"]) {
                    self.goldMC = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                }
                if ([item[@"module"] isEqualToString:@"2"]) {
                    self.goldDC = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                }
                if ([item[@"module"] isEqualToString:@"3"]) {
                    self.goldJZCZ = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                }
                if ([item[@"module"] isEqualToString:@"4"]) {
                    self.goldJZFJ = [[NSString stringWithFormat:@"%@",item[@"gold"]]integerValue];
                }
            }
        }
    }];
}
#pragma mark - 倒计时,跳转相应测试页面
-(void)timeGo
{
    GZPLabel * label = (id)[self.view viewWithTag:10];
    _count --;
    if (_count == 0) {
        if(self.type == 1){ //名词
            MCCSVC * vc = [MCCSVC new];
            ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
            if (![model.IsRemind isEqualToString:@"1"]) {
                vc.coinNumber = self.goldMC;
            }else{
                vc.coinNumber = 0;
            }
            vc.testArr = self.testArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.type == 2) { //动词
            DCCSVC * vc = [DCCSVC new];
            vc.coinNumber = self.goldDC;
            vc.testArr = self.testArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(self.type == 3){ //句子成组
            JZCZCSVC * vc = [JZCZCSVC new];
            vc.coinNumber = self.goldJZCZ;
            vc.testArr = self.testArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(self.type == 4){ //句子分解
            JZFJCSVC * vc = [JZFJCSVC new];
            vc.coinNumber = self.goldJZFJ;
            vc.testArr = self.testArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.type == 5){
            MCYYCSVC * vc = [MCYYCSVC new];
            vc.yyTestArr = self.yyTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    label.text = [NSString stringWithFormat:@"%ld",_count];
}


@end
