//
//  ZJNPersonFirstInfoView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/14.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPersonFirstInfoView.h"
@interface ZJNPersonFirstInfoView()

@end
@implementation ZJNPersonFirstInfoView
-(instancetype)init{
    self = [super init];
    if (self) {
        UIView *dotView = [[UIView alloc]init];
        dotView.backgroundColor = RGBColor(19, 16, 29, 1);
        dotView.layer.cornerRadius = ScreenAdapter(2.5);
        dotView.layer.masksToBounds = YES;
        [self addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(30));
            make.left.equalTo(self).offset(ScreenAdapter(35));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(5), ScreenAdapter(5)));
        }];
        
        UILabel *titleLabel = [UILabel createLabelWithTextColor:RGBColor(19, 16, 29, 1) font:FontSize(15)];
        titleLabel.text = @"个人信息";
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dotView);
            make.left.equalTo(dotView.mas_right).offset(ScreenAdapter(10));
        }];
        
        [self addSubview:self.infoButton];
        [self.infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.mas_equalTo(ScreenAdapter(44));
        }];
    }
    return self;
}

-(UIButton *)infoButton{
    if (!_infoButton) {
        _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoButton setTitle:@"完善个人信息" forState:UIControlStateNormal];
        [_infoButton setTitleColor:HexColor(yellowColor()) forState:UIControlStateNormal];
        [_infoButton setImage:SetImage(@"home_button_right") forState:UIControlStateNormal];
        _infoButton.titleLabel.font = FontSize(14);
        [_infoButton sizeToFit];
         //交换button中title和image的位置
        _infoButton.titleLabel.backgroundColor = _infoButton.backgroundColor;
        _infoButton.imageView.backgroundColor = _infoButton.backgroundColor;
        CGFloat labelWidth = _infoButton.titleLabel.width;
        CGFloat imageWith = _infoButton.imageView.width;
        _infoButton.imageEdgeInsets = UIEdgeInsetsMake(2, labelWidth+5, 0, -labelWidth-5);
        _infoButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
    }
    return _infoButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
