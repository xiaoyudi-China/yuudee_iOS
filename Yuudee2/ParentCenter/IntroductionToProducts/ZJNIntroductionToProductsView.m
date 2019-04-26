//
//  ZJNIntroductionToProductsView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNIntroductionToProductsView.h"
@interface ZJNIntroductionToProductsView()
@property (nonatomic ,strong)UIWebView *webView;
@property (nonatomic ,strong)UILabel *titleLabel;
@end
@implementation ZJNIntroductionToProductsView
-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self addSubview:self.webView];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(35));
            make.bottom.equalTo(self.topImageView).offset(-ScreenAdapter(7));
        }];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.topImageView.mas_bottom);
        }];
        
        [self getDataFromService];
    }
    return self;
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.bounces = NO;
        _webView.opaque = NO;
    }
    return _webView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:[UIColor whiteColor] font:FontWeight(16, UIFontWeightHeavy)];
        _titleLabel.text = @"新雨滴产品使用说明";
    }
    return _titleLabel;
}
-(void)getDataFromService{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?type=%@",Host,ProductInfo,@"1"];
    [[ZJNRequestManager sharedManager] getWithUrlString:urlStr success:^(id data) {
        NSLog(@"%@",data);
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
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
