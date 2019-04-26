//
//  ZJNProtocolViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2019/3/13.
//  Copyright © 2019 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNProtocolViewController.h"

@interface ZJNProtocolViewController ()
@property (nonatomic ,strong)UIWebView *webView;
@end

@implementation ZJNProtocolViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/agreement/register.html",Host]]]];
    
    UIButton * homeBtn = [[UIButton alloc] init];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button_press"] forState:UIControlStateHighlighted];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    // Do any additional setup after loading the view.
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

-(void)homeClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
