//
//  ProductVC.m
//  Yuudee2
//
//  Created by GZP on 2018/10/15.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ProductVC.h"

@interface ProductVC ()<UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic ,strong)UIWebView *webView;
@end

@implementation ProductVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self.view);
    }];
    
    [self getDataFromService];
    
    
    UIButton * homeBtn = [[UIButton alloc] init];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button_press"] forState:UIControlStateHighlighted];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.delegate = self;
    }
    return _webView;
}
-(void)getDataFromService{
    [self showHudInView:self.view hint:nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?type=%@",Host,ProductInfo,@"2"];
    [[ZJNRequestManager sharedManager] getWithUrlString:urlStr success:^(id data) {
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                                    "<head> \n"
                                    "<style type='text/css'> \n"
                                    "body {font-size:15px;}\n"
                                    "</style> \n"
                                    "</head> \n"
                                    "<body>"
                                    "<script type='text/javascript'>"
                                    "window.onload = function(){\n"
                                    "var $img = document.getElementsByTagName('img');\n"
                                    "for(var p in $img){\n"
                                    " $img[p].style.width = '100%%';\n"
                                    "$img[p].style.height ='auto'\n"
                                    "}\n"
                                    "}"
                                    "</script>%@"
                                    "</body>"
                                    "</html>",data[@"data"][@"content"]];
            [self.webView loadHTMLString:htmlString baseURL:nil];
        }else{
            [self showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
}
-(void)homeClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
