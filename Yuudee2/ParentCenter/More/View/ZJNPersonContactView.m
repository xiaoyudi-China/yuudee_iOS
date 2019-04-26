//
//  ZJNPersonContactView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/14.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPersonContactView.h"
@interface ZJNPersonContactView()
//网站
@property (nonatomic ,strong)UILabel *webLabel;
//邮箱
@property (nonatomic ,strong)UILabel *emailLabel;
//QQ群
@property (nonatomic ,strong)UILabel *QQLabel;
//微信群
@property (nonatomic ,strong)UILabel *weChatLabel;

@end
@implementation ZJNPersonContactView
-(instancetype)init{
    self = [super init];
    if (self) {
        UIView *dotView = [[UIView alloc]init];
        dotView.backgroundColor = RGBColor(19, 16, 29, 1);
        dotView.layer.cornerRadius = ScreenAdapter(2.5);
        dotView.layer.masksToBounds = YES;
        [self addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(10));
            make.left.equalTo(self).offset(ScreenAdapter(35));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(5), ScreenAdapter(5)));
        }];
        
        UILabel *titleLabel = [UILabel createLabelWithTextColor:RGBColor(19, 16, 29, 1) font:FontSize(15)];
        titleLabel.text = @"联系与反馈";
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dotView);
            make.left.equalTo(dotView.mas_right).offset(ScreenAdapter(10));
        }];
        
        [self addSubview:self.webLabel];
        [self.webLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(ScreenAdapter(18));
        }];
        
        [self addSubview:self.emailLabel];
        [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.webLabel);
            make.top.equalTo(self.webLabel.mas_bottom).offset(ScreenAdapter(15));
        }];
        
        [self addSubview:self.QQLabel];
        [self.QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.webLabel);
            make.top.equalTo(self.emailLabel.mas_bottom).offset(ScreenAdapter(15));
        }];
        
        [self addSubview:self.weChatLabel];
        [self.weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.webLabel);
            make.top.equalTo(self.QQLabel.mas_bottom).offset(ScreenAdapter(15));
        }];
        
        [self addSubview:self.showButton];
        [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.weChatLabel.mas_right);
            make.centerY.equalTo(self.weChatLabel);
            make.height.mas_equalTo(ScreenAdapter(44));
            
        }];
    }
    return self;
}

-(UILabel *)webLabel{
    if (!_webLabel) {
        _webLabel = [UILabel createLabelWithTitle:@"网站：" textColor:RGBColor(19, 16, 29, 1) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _webLabel;
}

-(UILabel *)emailLabel{
    if (!_emailLabel) {
        _emailLabel = [UILabel createLabelWithTitle:@"邮箱：" textColor:RGBColor(19, 16, 29, 1) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _emailLabel;
}

-(UILabel *)QQLabel{
    if (!_QQLabel) {
        _QQLabel = [UILabel createLabelWithTitle:@"QQ号：" textColor:RGBColor(19, 16, 29, 1) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _QQLabel;
}

-(UILabel *)weChatLabel{
    if (!_weChatLabel) {
        _weChatLabel = [UILabel createLabelWithTitle:@"微信号：" textColor:RGBColor(19, 16, 29, 1) font:FontSize(14) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _weChatLabel;
}

-(UIButton *)showButton{
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton setTitle:@"查看二维码" forState:UIControlStateNormal];
        [_showButton setTitleColor:HexColor(yellowColor()) forState:UIControlStateNormal];
        [_showButton setImage:SetImage(@"home_button_right") forState:UIControlStateNormal];
        _showButton.titleLabel.font = FontSize(14);
        [_showButton sizeToFit];
        //交换button中title和image的位置
        _showButton.titleLabel.backgroundColor = _showButton.backgroundColor;
        _showButton.imageView.backgroundColor = _showButton.backgroundColor;
        CGFloat labelWidth = _showButton.titleLabel.width;
        CGFloat imageWith = _showButton.imageView.width;
        _showButton.imageEdgeInsets = UIEdgeInsetsMake(2, labelWidth+5, 0, -labelWidth-5);
        _showButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
    }
    return _showButton;
}
-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    self.webLabel.text = [NSString stringWithFormat:@"网站：%@",SetStr(infoDic[@"network"])];
    self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@",SetStr(infoDic[@"mail"])];
    self.QQLabel.text = [NSString stringWithFormat:@"QQ号：%@",SetStr(infoDic[@"qqun"])];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
