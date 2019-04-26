//
//  ZJNChartsView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/19.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNChartsView.h"

@interface ZJNChartsView()
@property (nonatomic ,strong)UILabel *titleLabel;

@end
@implementation ZJNChartsView
-(id)init{
    self = [super init];
    if (self) {
        
        UIView *dotView = [[UIView alloc]init];
        dotView.backgroundColor = HexColor(0x14101e);
        dotView.layer.cornerRadius = 2.5;
        dotView.layer.masksToBounds = YES;
        [self addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenAdapter(15));
            make.top.equalTo(self).offset(ScreenAdapter(20));
            make.size.mas_equalTo(CGSizeMake(5, 5));
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dotView);
            make.left.equalTo(dotView.mas_right).offset(ScreenAdapter(10));
        }];
        
        _lineChartsView = [[ZJNLineChartsView alloc]init];
        [self addSubview:self.lineChartsView];
        [self.lineChartsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(-ScreenAdapter(5));
            make.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTextColor:HexColor(textColor()) font:FontSize(14) numberOfLines:1];
        _titleLabel.text = @"总测试进度与语言评估量表分的关系";
    }
    return _titleLabel;
}
//-(void)setXArr:(NSArray *)xArr{
//    self.lineChartsView.xArr = xArr;
//}
//-(void)setYArr:(NSArray *)yArr{
//    self.lineChartsView.yArr = yArr;
//}
//-(void)setXStr:(NSString *)xStr{
//    self.lineChartsView.xStr = xStr;
//}
//-(void)setYStr:(NSString *)yStr{
//    self.lineChartsView.yStr = yStr;
//}
-(void)setTitleStr:(NSString *)titleStr{
    self.titleLabel.text = titleStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
