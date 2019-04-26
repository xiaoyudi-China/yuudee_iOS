//
//  ZJNPCTopAlertView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/10/31.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPCTopAlertView.h"

@implementation ZJNPCTopAlertView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBColor(0, 0, 0, 0.6);
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(50));
            make.bottom.equalTo(self).offset(-ScreenAdapter(5));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(115), ScreenAdapter(40)));
        }];
        
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ScreenAdapter(50));
            make.bottom.equalTo(self).offset(-ScreenAdapter(5));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(115), ScreenAdapter(40)));
        }];
        
        [self addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(10));
            make.right.equalTo(self).offset(-ScreenAdapter(10));
            make.bottom.equalTo(self.leftButton.mas_top).offset(-ScreenAdapter(5));
        }];
    }
    return self;
}

-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = FontSize(14);
        _infoLabel.text = @"您可以和孩子一起先体验训练，在进入正式的个性化训练课前，您需要先完善儿童信息。";
    }
    return _infoLabel;
}

-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setBackgroundImage:SetImage(@"home_button_bg") forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton setTitle:@"立即体验产品" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = FontWeight(15, UIFontWeightBlack);
        _leftButton.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setBackgroundImage:SetImage(@"home_button_bg") forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"完善儿童信息" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = FontWeight(15, UIFontWeightBlack);
        _rightButton.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(void)leftButtonClick:(UIButton *)button{
    if (self.leftButtonBlock) {
        self.leftButtonBlock();
    }
}

-(void)rightButtonClick:(UIButton *)button{
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
