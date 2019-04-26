//
//  ZJNHeaderView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/14.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNHeaderView.h"

@implementation ZJNHeaderView
-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(45), ScreenAdapter(45)));
        }];
        
        [self addSubview:self.phoneBg];
        [self.phoneBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(20));
            make.centerY.equalTo(self.headerImageView);
            make.width.mas_equalTo(ScreenAdapter(125));
            make.height.mas_equalTo(ScreenAdapter(35));
        }];
        
        [self addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.phoneBg).offset(-ScreenAdapter(10));
            make.centerY.equalTo(self.phoneBg);
        }];
        
        [self bringSubviewToFront:self.headerImageView];
        
    }
    return self;
}

-(UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [UIImageView itemWithImage:SetImage(@"boy") backColor:[UIColor whiteColor] Radius:ScreenAdapter(22.5)];
        _headerImageView.userInteractionEnabled = YES;
    }
    return _headerImageView;
}

-(UIImageView *)phoneBg{
    if (!_phoneBg) {
        _phoneBg = [UIImageView itemWithImage:SetImage(@"iphone_bg") backColor:[UIColor whiteColor] Radius:ScreenAdapter(35/2.0)];
    }
    return _phoneBg;
}
-(UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel createLabelWithTextColor:[UIColor whiteColor] font:FontSize(14)];
        _phoneLabel.text = @"181****7075";
        _phoneLabel.textAlignment = NSTextAlignmentRight;
    }
    return _phoneLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
