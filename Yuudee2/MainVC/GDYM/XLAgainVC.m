//
//  XLAgainVC.m
//  Yuudee2
//
//  Created by GZP on 2018/11/19.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "XLAgainVC.h"
#import "DCXLVC.h"
#import "JZCZXLVC.h"
#import "JZFJXLVC.h"

@interface XLAgainVC ()
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSInteger count;
@end

@implementation XLAgainVC
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [@"FEFDEB" hexStringToColor];
    _count = 3;
    
    CGFloat with = AdFloat(750);
    CGFloat height = AdFloat(880);
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_W - with) / 2, AdFloat(80), with, height)];
    image.image = [UIImage imageNamed:@"xlagain"];
    [self.view addSubview:image];
    
    GZPLabel * number = [[GZPLabel alloc] initWithFrame:CGRectMake((Screen_W-AdFloat(150)) / 2, image.bottom - AdFloat(50), AdFloat(150), AdFloat(150))];
    [number fillWithText:[NSString stringWithFormat:@"%ld",_count] color:@"ffa54f" font:55 aligenment:NSTextAlignmentCenter];
    number.font = [UIFont boldSystemFontOfSize:55];
    number.tag = 10;
    [self.view addSubview:number];
    
    [[PlayerManager shared] playLocalUrl:@"女-让我们再来一组训练.MP3"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    });
}
#pragma mark - 倒计时,跳转相应测试页面
-(void)timeGo
{
    GZPLabel * label = (id)[self.view viewWithTag:10];
    _count --;
    if (_count == 0) {
        if(self.type == 1){ //名词
            MCXLVC * vc = [MCXLVC new];
            vc.helpTime = self.helpTime;;
            vc.trainArr = self.trainArr;;
            vc.testArr = self.testArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.type == 2) { //动词
            DCXLVC * vc = [DCXLVC new];
            vc.helpTime = self.helpTime;;
            vc.trainArr = self.trainArr;;
            vc.testArr = self.testArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(self.type == 3){ //句子成组
            JZCZXLVC * vc = [JZCZXLVC new];
            vc.helpTime = self.helpTime;;
            vc.trainArr = self.trainArr;;
            vc.testArr = self.testArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(self.type == 4){ //句子分解
            JZFJXLVC * vc = [JZFJXLVC new];
            vc.helpTime = self.helpTime;;
            vc.trainArr = self.trainArr;;
            vc.testArr = self.testArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    label.text = [NSString stringWithFormat:@"%ld",_count];
}

- (void)testFunction {
    [self viewDidLoad];
    for (int a =0; a<4; a++) {
        self.type = a+1;
        [self timeGo];
    }
}

@end
