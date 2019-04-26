//
//  ZJNPersonCircleView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/17.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPersonCircleView.h"
@interface ZJNPersonCircleView()
@property (nonatomic ,strong)UIImageView *imageView;
@end
@implementation ZJNPersonCircleView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(ScreenAdapter(88));
        }];
        
        [self addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.imageView).offset(-ScreenAdapter(12));
        }];
        
        [self addSubview:self.topLabel];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.imageView).offset(-ScreenAdapter(4));
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
        
        [self addSubview:self.changeBtn];
        [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.imageView.mas_bottom).offset(ScreenAdapter(2));
            make.height.mas_equalTo(ScreenAdapter(44));
        }];
        
    }
    return self;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView itemWithImage:SetImage(@"pic1") backColor:nil];
    }
    return _imageView;
}

-(UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(13)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.numberOfLines = 2;
    }
    return _topLabel;
}

-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [UILabel createLabelWithTextColor:[UIColor whiteColor] font:FontSize(13)];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

-(UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:HexColor(yellowColor()) forState:UIControlStateNormal];
        [_changeBtn setImage:SetImage(@"home_button_right") forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = FontSize(14);
        [_changeBtn sizeToFit];
        //交换button中title和image的位置
        _changeBtn.titleLabel.backgroundColor = _changeBtn.backgroundColor;
        _changeBtn.imageView.backgroundColor = _changeBtn.backgroundColor;
        CGFloat labelWidth = _changeBtn.titleLabel.width;
        CGFloat imageWith = _changeBtn.imageView.width;
        _changeBtn.imageEdgeInsets = UIEdgeInsetsMake(2, labelWidth+5, 0, -labelWidth-5);
        _changeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
    }
    return _changeBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
