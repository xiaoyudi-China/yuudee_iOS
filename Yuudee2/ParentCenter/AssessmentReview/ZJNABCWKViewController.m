//
//  ZJNABCWKViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/13.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNABCWKViewController.h"
#import <WebKit/WebKit.h>
@interface ZJNABCWKViewController()<WKScriptMessageHandler>

@property (nonatomic ,strong)WKWebView *webView;

@end

@implementation ZJNABCWKViewController

-(instancetype)initWithStatus:(NSString *)status{
    self = [super init];
    if (self) {
        _status = status;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"goBack"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"goBack"];
}
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenHeight())];
        _webView.allowsLinkPreview = NO;
        /**/
        //禁止长按弹出 UIMenuController 相关
        //禁止选择 css 配置相关
        NSString*css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
        //css 选中样式取消
        NSMutableString*javascript = [NSMutableString string];
        
        [javascript appendString:@"var style = document.createElement('style');"];
        
        [javascript appendString:@"style.type = 'text/css';"];
        
        [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
        
        [javascript appendString:@"style.appendChild(cssContent);"];
        
        [javascript appendString:@"document.body.appendChild(style);"];
        
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        
        //javascript 注入
        
        WKUserScript *noneSelectScript = [[WKUserScript alloc]initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        WKUserContentController*userContentController = [[WKUserContentController alloc] init];
        
        [userContentController addUserScript:noneSelectScript];
        
        WKWebViewConfiguration*configuration = [[WKWebViewConfiguration alloc] init];
        
        configuration.userContentController = userContentController;
        
        //控件加载
        
        [_webView.configuration.userContentController addUserScript:noneSelectScript];
        /**/
        _webView.scrollView.bounces = NO;
        NSString *urlStr;
        if ([self.status isEqualToString:@"1"]) {
            //abc问卷
            urlStr = [NSString stringWithFormat:@"%@%@?token=%@",Host,ABC,[[ZJNTool shareManager] getToken]];
        }else if ([self.status isEqualToString:@"2"]){
            //abc结果页
            urlStr = [NSString stringWithFormat:@"%@%@?token=%@&status=%@",Host,ABCPresentation,[[ZJNTool shareManager] getToken],@"core"];
        }else{
            //abc问卷未完成
            urlStr = [NSString stringWithFormat:@"%@%@?token=%@&status=%@",Host,ABC,[[ZJNTool shareManager] getToken],@"1"];
        }
        if(@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
    return _webView;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"goBack"]) {
        [self goBack];
    }
}

-(void)goBack{
    if (self.abcRefreshBlock) {
        self.abcRefreshBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)testFunction{
    [self viewDidLoad];
    [self viewWillAppear:YES];
    [self viewWillDisappear:YES];
    [self goBack];
}

@end
