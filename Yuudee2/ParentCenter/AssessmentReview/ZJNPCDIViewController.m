//
//  ZJNPCDIViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/5.
//  Copyright © 2018 险峰科技. All rights reserved.
//

#import "ZJNPCDIViewController.h"
/*导入JavaScriptCore*/
#import <JavaScriptCore/JavaScriptCore.h>
//定义可实现方法，用以JS里调用

@interface ZJNPCDIViewController ()<UIWebViewDelegate>

@property (nonatomic ,strong)UIWebView *webView;
@property (nonatomic, strong)JSContext *jsContext;
@end

@implementation ZJNPCDIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    http://47.95.244.242/XiaoyudiApplication/xiaoyudi/pages/pcdiRequired.html
    
    // Do any additional setup after loading the view.
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://47.95.244.242/XiaoyudiApplication/xiaoyudi/pages/pcdiRequired.html"]]];
    }
    return _webView;
}
#pragma mark-UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //创建JS的对象 并找到路径
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self.jsContext evaluateScript:@"var arr = [3, 4, 'abc'];"];
    self.jsContext[@"monitorOut"] = ^(){
        NSLog(@"此时需要返回上个界面");
    };
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
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
