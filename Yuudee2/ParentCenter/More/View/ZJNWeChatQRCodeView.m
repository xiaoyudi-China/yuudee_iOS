//
//  ZJNWeChatQRCodeView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/17.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNWeChatQRCodeView.h"
#import <Photos/Photos.h>
@interface ZJNWeChatQRCodeView()
@property (nonatomic ,strong)UILabel *titleLabel;

@property (nonatomic ,strong)UIImageView *QRCodeImageView;
@end
@implementation ZJNWeChatQRCodeView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBColor(0, 0, 0, 0.5);
        [self addSubview:self.QRCodeImageView];
        [self.QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(220)+AddNav());
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(180), ScreenAdapter(180)));
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.QRCodeImageView);
            make.bottom.equalTo(self.QRCodeImageView.mas_top).offset(-ScreenAdapter(10));
        }];
        
        //如需打开分享功能 请解注释下方代码（分享所需账号信息没有提供）

//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.QRCodeImageView);
//            make.bottom.equalTo(self.QRCodeImageView.mas_top).offset(-ScreenAdapter(10));
//        }];
        
//        [self addSubview:self.shareBtn];
//        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.titleLabel);
//            make.right.equalTo(self.QRCodeImageView);
//            make.height.mas_equalTo(ScreenAdapter(44));
//        }];
        
        [self addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.QRCodeImageView.mas_bottom).offset(ScreenAdapter(20));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(155), ScreenAdapter(56)));
        }];
    }
    return self;
}

-(UIImageView *)QRCodeImageView{
    if (!_QRCodeImageView) {
        _QRCodeImageView = [[UIImageView alloc]init];
    }
    return _QRCodeImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithTitle:@"新雨滴微信号" textColor:[UIColor whiteColor] font:FontSize(16) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _titleLabel;
}

-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:HexColor(yellowColor()) forState:UIControlStateNormal];
        [_shareBtn setImage:SetImage(@"home_button_right") forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = FontSize(14);
        [_shareBtn sizeToFit];
        //交换button中title和image的位置
        _shareBtn.titleLabel.backgroundColor = _shareBtn.backgroundColor;
        _shareBtn.imageView.backgroundColor = _shareBtn.backgroundColor;
        CGFloat labelWidth = _shareBtn.titleLabel.width;
        CGFloat imageWith = _shareBtn.imageView.width;
        _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(2, labelWidth+5, 0, -labelWidth-5);
        _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
        [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
//分享
-(void)shareBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareQRCode)]) {
        [self.delegate shareQRCode];
    }
}
//保存图片
-(UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton itemWithTitle:@"保存图片" titleColor:[UIColor whiteColor] font:FontWeight(16, UIFontWeightBlack) target:self action:@selector(saveBtnClick)];
        [_saveButton setBackgroundImage:SetImage(@"shortButton") forState:UIControlStateNormal];
        _saveButton.titleEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
    }
    return _saveButton;
}

#pragma mark-保存图片
-(void)saveBtnClick{
    UIImageWriteToSavedPhotosAlbum(self.QRCodeImageView.image, self, @selector(image:didFinishSavingWithError:contexInfo:), nil);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contexInfo:(void *)contextInfo{
    NSString *info;
    if (error) {
        info = @"保存失败";
    }else{
        info = @"保存成功";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveImageWithResult:)]) {
        [self.delegate saveImageWithResult:info];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

-(void)setImagePath:(NSString *)imagePath{
    [self.QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
