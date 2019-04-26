//
//  GZPTipView.m
//  Yuudee2
//
//  Created by GZP on 2018/10/12.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "GZPTipView.h"
@interface GZPTipView ()

@property(nonatomic,strong)UIImageView * backImage;

@end

@implementation GZPTipView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title block:(GZPTipViewBlock)block
{
    ZJNUserInfoModel *model = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
    if (self = [super initWithFrame:frame]) {
        _block = block;
        NSString * content = @"";
        if ([title isEqualToString:@"完善训练儿童信息"]){
            content = @"因为每个孩子的能力不同,为了使每个孩子都按照自己的节奏进步,新雨滴提供了个性化的训练和指导方案,在继续学习前,需要了解孩子的基础能力,请家长先完善训练儿童个人信息和问卷评估。";
            
        }else if ([title isEqualToString:@"问卷评估提醒"]) {
            content = @"因为每个孩子的能力不同,为了使每个孩子都按照自己的节奏进步,新雨滴提供了个性化的训练和指导方案,在继续学习前,需要了解孩子的基础能力,请家长先完成问卷评估。";
            
        }else if ([title isEqualToString:@"定期问卷评估提醒"]){
            content = [NSString stringWithFormat:@"亲爱的新雨滴用户家长, %@小朋友使用我们的新雨滴已经超过三个月啦!考虑到小朋友的自然生长以及在生活中学习的能力,您需要再次填写语言评估和行为评估问卷,以便更好的了解小朋友的学习进展和语言能力变化,更好的帮助小朋友学习!",model.chilName];
            
        }else if ([title isEqualToString:@"通关填写问卷提醒"]){
            content = [NSString stringWithFormat:@"恭喜您! %@在全部课程完成后,如再次完成全部必做和选做部分,将获得幼童学习进展的对比评估,以便您了解幼童的学习成果,以后在生活中进行更好的巩固和学习。",model.chilName];
            
        }else if ([title isEqualToString:@""]){
            content = @"        您尚未填写完问卷评估,如果您现在退出,我们将会为您已经填写的部分保留1周时间,如果超过1周需要重新填写,因为孩子可能已经发生了很大的进步!您确定退出吗?";
            
        }
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self makeUI:title content:content];
    }
    return self;
}
-(void)makeUI:(NSString *)title content:(NSString *)content
{
    //木板背景图片
    _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_W - AdFloat(60), AdFloat(550))];
    _backImage.center = self.center;
    _backImage.image = [UIImage imageNamed:@"tankuangbig"];
    [self addSubview:_backImage];
    
    //叉按钮
    UIImageView * chaImage = [[UIImageView alloc] initWithFrame:CGRectMake(_backImage.right - AdFloat(30+60), _backImage.top + AdFloat(60), AdFloat(60), AdFloat(60))];
    chaImage.image = [UIImage imageNamed:@"sign_button_close"];
    [chaImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chaClick)]];
    chaImage.userInteractionEnabled = YES;
    if (title.length == 0) {
        chaImage.hidden = YES;
    }
    [self addSubview:chaImage];
    
    //标题
    GZPLabel * titleL = [[GZPLabel alloc] initWithFrame:CGRectMake(_backImage.left, chaImage.top + AdFloat(10), _backImage.width, AdFloat(50))];
    [titleL fillWithText:title color:@"c06d00" font:AdFloat(36) aligenment:NSTextAlignmentCenter];
    if (title.length == 0) {
        titleL.top = chaImage.top - AdFloat(20);
        titleL.height = AdFloat(1);
    }
    [self addSubview:titleL];
    
    //内容
    NSString * redStr = @"超过三个月";
    GZPLabel * contentL = [[GZPLabel alloc] initWithFrame:CGRectMake(_backImage.left + AdFloat(50), titleL.bottom + AdFloat(30), _backImage.width - AdFloat(100), 10)];
    contentL.numberOfLines = 0;
    [contentL fillWithText:content color:@"333333" font:AdFloat(32) aligenment:NSTextAlignmentLeft];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:AdFloat(5)];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:content];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    if ([content rangeOfString:redStr].location != NSNotFound) {
        [setString addAttribute:NSForegroundColorAttributeName value:[@"cb4848" hexStringToColor] range:[content rangeOfString:redStr]];
    }
    [contentL  setAttributedText:setString];
    [contentL sizeToFit];
    
    [self addSubview:contentL];
    
    //去评估按钮
    UIButton * goBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AdFloat(338-38-30), AdFloat(112-12))];
    goBtn.centerX = _backImage.centerX;
    goBtn.centerY = contentL.bottom + AdFloat(30) + goBtn.height/2;
    [goBtn setBackgroundImage:[UIImage imageNamed:@"home_button_bg"] forState:UIControlStateNormal];
    if ([title isEqualToString:@"完善训练儿童信息"]) {
        [goBtn setTitle:@"去完善" forState:UIControlStateNormal];
    }else{
        [goBtn setTitle:@"去评估" forState:UIControlStateNormal];
    }
    goBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AdFloat(36)];
    [goBtn setTitleColor:[@"ffffff" hexStringToColor] forState:UIControlStateNormal];
    goBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
    [goBtn addTarget:self action:@selector(goClick:) forControlEvents:UIControlEventTouchUpInside];
    goBtn.tag = 10;
    [self addSubview:goBtn];
    
    if (title.length == 0) {
        NSArray * titleArr = @[@"继续填写",@"确定退出"];
        for (int i = 0; i < 2; i ++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((_backImage.width-goBtn.width*2-AdFloat(30)) / 2 + (goBtn.width+AdFloat(30))*i + AdFloat(30), goBtn.top, goBtn.width, goBtn.height)];
            [btn setBackgroundImage:[UIImage imageNamed:@"home_button_bg"] forState:UIControlStateNormal];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:AdFloat(36)];
            [btn setTitleColor:[@"ffffff" hexStringToColor] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
            [btn addTarget:self action:@selector(goClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 11+i;
            [self addSubview:btn];
        }
        goBtn.hidden = YES;
    }
    
    _backImage.height = goBtn.bottom - _backImage.top + AdFloat(60);
}
#pragma mark - 按钮Click
-(void)goClick:(UIButton *)btn
{
    if (btn.tag == 10) {
        if ([btn.titleLabel.text isEqualToString:@"去完善"]) {
            self.block(1, self);
        }else{
            self.block(2, self);
        }
    }else if (btn.tag == 11){
        self.block(3, self);
        [self removeFromSuperview];
    }else if (btn.tag == 12){
        self.block(4, self);
    }
}
#pragma mark - 叉号
-(void)chaClick
{
    self.block(0, self);
}
-(void)show
{
    AppDelegate * delegate = (id)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
}
@end
