//
//  ZJNBasicViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/8/24.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNBasicViewController.h"

@interface ZJNBasicViewController ()

@end
@implementation ZJNBasicViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[PlayerManager shared].itemsArr removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)dealloc{
    NSLog(@"---------%@销毁----------",NSStringFromClass([self class]));
}

- (void)testFunction{
    [self viewDidLoad];
    [self viewWillDisappear:YES];
    [self viewWillAppear:YES];
}

@end
