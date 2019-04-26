//
//  ZJNParentCenterBasicView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNParentCenterBasicView.h"
@interface ZJNParentCenterBasicView()

@end
@implementation ZJNParentCenterBasicView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.topImageView];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(ScreenAdapter(80)+AddNav());
        }];
        
        [self addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.topImageView.mas_bottom);
        }];
        
        [self addSubview:self.homeBtn];
        [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(22)+AddNav());
            make.right.equalTo(self).offset(-ScreenAdapter(22));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(48), ScreenAdapter(51)));
        }];
    }
    return self;
}

-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = SetImage(@"family_bg1");
    }
    return _topImageView;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = SetImage(@"family_bg2");
    }
    return _bgImageView;
}

-(UIButton *)homeBtn{
    if (!_homeBtn) {
        _homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homeBtn setImage:SetImage(@"home_button1") forState:UIControlStateNormal];
        
    }
    return _homeBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
