//
//  ZJNPersonVersionView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/17.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNPersonVersionView.h"
#import <JPUSHService.h>
@interface ZJNPersonVersionView()
@property (nonatomic ,strong)UIButton *evaluateBtn;
@property (nonatomic ,strong)UIButton *quitBtn;
@end
@implementation ZJNPersonVersionView
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
        titleLabel.text = @"当前版本";
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dotView);
            make.left.equalTo(dotView.mas_right).offset(ScreenAdapter(10));
        }];
        // 当前app的信息
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        
        NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
        UILabel *versionLabel = [UILabel createLabelWithTextColor:RGBColor(19, 16, 29, 1) font:FontSize(15)];
        versionLabel.text = [NSString stringWithFormat:@"v%@",app_Version];
        [self addSubview:versionLabel];
        [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(ScreenAdapter(15));
        }];
        
        [self addSubview:self.evaluateBtn];
        [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(versionLabel.mas_right).offset(ScreenAdapter(31));
            make.centerY.equalTo(versionLabel);
            make.height.mas_equalTo(ScreenAdapter(44));
        }];
        
        [self addSubview:self.quitBtn];
        [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(versionLabel);
            make.top.equalTo(versionLabel.mas_bottom).offset(ScreenAdapter(18));
            make.height.mas_equalTo(ScreenAdapter(44));
        }];
    }
    return self;
}

-(UIButton *)evaluateBtn{
    if (!_evaluateBtn) {
        _evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_evaluateBtn setTitle:@"评价打分" forState:UIControlStateNormal];
//        [_evaluateBtn setTitleColor:HexColor(yellowColor()) forState:UIControlStateNormal];
//        [_evaluateBtn setImage:SetImage(@"home_button_right") forState:UIControlStateNormal];
//        _evaluateBtn.titleLabel.font = FontSize(14);
//        [_evaluateBtn sizeToFit];
//        //交换button中title和image的位置
//        _evaluateBtn.titleLabel.backgroundColor = _evaluateBtn.backgroundColor;
//        _evaluateBtn.imageView.backgroundColor = _evaluateBtn.backgroundColor;
//        _evaluateBtn.hidden = YES;
//        CGFloat labelWidth = _evaluateBtn.titleLabel.width;
//        CGFloat imageWith = _evaluateBtn.imageView.width;
//        _evaluateBtn.imageEdgeInsets = UIEdgeInsetsMake(2, labelWidth+5, 0, -labelWidth-5);
//        _evaluateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
    }
    return _evaluateBtn;
}

-(UIButton *)quitBtn{
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_quitBtn setTitleColor:HexColor(yellowColor()) forState:UIControlStateNormal];
        [_quitBtn setImage:SetImage(@"home_button_right") forState:UIControlStateNormal];
        _quitBtn.titleLabel.font = FontSize(14);
        [_quitBtn sizeToFit];
        //交换button中title和image的位置
        _quitBtn.titleLabel.backgroundColor = _quitBtn.backgroundColor;
        _quitBtn.imageView.backgroundColor = _quitBtn.backgroundColor;
        CGFloat labelWidth = _quitBtn.titleLabel.width;
        CGFloat imageWith = _quitBtn.imageView.width;
        _quitBtn.imageEdgeInsets = UIEdgeInsetsMake(2, labelWidth+5, 0, -labelWidth-5);
        _quitBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
        [_quitBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}
-(void)logout
{
    //退出登录时，清空用户相关信息
    [[ZJNFMDBManager shareManager] deleteCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    [[ZJNTool shareManager] logout];
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
    } seq:0];
    AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [[ZJNNavigationController alloc] initWithRootViewController:[ZJNLoginAndRegisterViewController new]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
