//
//  ZJNParentCenterBottomView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNParentCenterBottomView.h"
@interface ZJNParentCenterBottomView()
@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,strong)UIButton    *signBtn;
@end
@implementation ZJNParentCenterBottomView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        NSArray *titleArr = @[@"产品介绍",@"训练档案",@"评估评测",@"更多"];
        CGFloat btnWidth = ScreenAdapter(89);
        CGFloat btnHeight = ScreenAdapter(42);
        CGFloat interval = (ScreenWidth()-4*btnWidth)/5.0;
        for (int i = 0; i <4; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 10+i;
            [button setBackgroundImage:SetImage(@"shortButton") forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:RGBColor(207, 183, 147, 1) forState:UIControlStateNormal];
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = FontWeight(16, UIFontWeightBlack);
            button.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                button.selected = YES;
                self.signBtn = button;
            }
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(interval+i*(btnWidth+interval));
                if (i == 0) {
                    make.top.mas_equalTo(ScreenAdapter(20));
                }else{
                    make.top.mas_equalTo(ScreenAdapter(30));
                }
                make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
            }];
        }
    }
    return self;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = SetImage(@"family_bg3");
    }
    return _bgImageView;
}

#pragma mark-
-(void)buttonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    self.signBtn.selected = NO;
    [self.signBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenAdapter(30));
    }];
    
    button.selected = YES;
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenAdapter(20));
    }];
    
    self.signBtn = button;
    if (self.bottomViewBlock) {
        self.bottomViewBlock(button.tag-10);
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
