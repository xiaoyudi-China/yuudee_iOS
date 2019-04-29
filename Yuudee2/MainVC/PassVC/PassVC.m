//
//  PassVC.m
//  Yuudee2
//
//  Created by GZP on 2018/11/8.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "PassVC.h"
#import "MCYYCSVC.h"
#import "JZFJXLVC.h"

@interface PassVC ()
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSInteger count;
@end

@implementation PassVC
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
    image.image = [UIImage imageNamed:[NSString stringWithFormat:@"pass%ld",self.type]];
    [self.view addSubview:image];
    
    [[PlayerManager shared] playLocalUrl:@"女-通关成功.MP3"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    });
}
#pragma mark - 倒计时,跳转相应测试页面
-(void)timeGo
{
    _count --;
    if (_count == 0) {
        if (self.type == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if (self.type == 3){
            JZFJXLVC * vc = [JZFJXLVC new];
            vc.helpTime = self.JZFJHelpTime;
            vc.trainArr = self.JZFJTrainArr;
            vc.testArr = self.JZFJTestArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.type == 2 || self.type == 4){
            [self.navigationController popToRootViewControllerAnimated:YES];
            if (self.type == 4) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Success" object:nil];
            }
        }
    }
}

- (void)testFunction {
    [self viewDidLoad];
    for (int a =0; a<4; a++) {
        self.type = a+1;
        self.count = 1;
        [self timeGo];
    }
}

@end
