//
//  ZJNLoginViewController.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/7.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNLoginViewController.h"
#import "ZJNGeneralLoginView.h"
#import "ZJNFastLoginView.h"
@interface ZJNLoginViewController ()<UIScrollViewDelegate>
//记录当前被选中的按钮
@property (nonatomic ,strong)UIButton *signButton;
//小滑块儿
@property (nonatomic ,strong)UIView   *sliderView;
//
@property (nonatomic ,strong)UIScrollView *scrollView;
//容器View
@property (nonatomic ,strong)UIView *containerView;
//普通登录
@property (nonatomic ,strong)ZJNGeneralLoginView *generalLoginView;
//快捷登录
@property (nonatomic ,strong)ZJNFastLoginView *fastLoginView;
@end

@implementation ZJNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubviews];
    
    [self.homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //如果是注册页面 点击去登录按钮进入到登录界面：需要跳转到快捷登录页面，并且填充手机号
    if (self.registPhone.length>0) {
        UIButton *button = (UIButton *)[self.view viewWithTag:11];
        self.signButton.selected = NO;
        button.selected = YES;
        self.signButton = button;
        [UIView animateWithDuration:0.5 animations:^{
            self.sliderView.frame = CGRectMake(3*ScreenWidth()/4.0-ScreenAdapter(35), ScreenAdapter(180)+AddNav()+35, ScreenAdapter(70), 2);
            self.scrollView.contentOffset = CGPointMake(ScreenWidth(), 0);
        }];
    }
    // Do any additional setup after loading the view.
}
-(void)setUpSubviews{
    NSArray *titleArr = @[@"普通登录",@"快捷登录"];
    for (int i =0; i <2; i ++) {
        NSString *title = titleArr[i];
        UIButton *button = [UIButton itemWithTitle:title titleColor:RGBColor(19, 16, 29, 1) font:FontSize(16) target:self action:@selector(topButtonClick:)];
        button.tag = 10+i;
        [button setTitleColor:HexColor(yellowColor()) forState:UIControlStateSelected];
        button.frame = CGRectMake(i *ScreenWidth()/2.0, ScreenAdapter(180)+AddNav(), ScreenWidth()/2.0, 35);
        [self.view addSubview:button];
        if (i == 0) {
            button.selected = YES;
            self.signButton = button;
        }
    }
    
    [self.view addSubview:self.sliderView];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.sliderView.mas_bottom);
    }];
    
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(2*ScreenWidth());
        make.height.mas_equalTo(self.scrollView);
    }];
    
    [self.containerView addSubview:self.generalLoginView];
    [self.generalLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.containerView);
        make.width.mas_equalTo(ScreenWidth());
        make.height.equalTo(self.containerView);
    }];
    
    [self.containerView addSubview:self.fastLoginView];
    [self.fastLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.left.equalTo(self.containerView).offset(ScreenWidth());
        make.width.mas_equalTo(ScreenWidth());
        make.height.equalTo(self.containerView);
    }];
    [self.view layoutIfNeeded];
}
-(UIView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth()/4.0-ScreenAdapter(35), ScreenAdapter(180)+AddNav()+35, ScreenAdapter(70), 2)];
        _sliderView.backgroundColor = RGBColor(180, 109, 25, 1);
        
    }
    return _sliderView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
}
-(ZJNGeneralLoginView *)generalLoginView{
    if (!_generalLoginView) {
        _generalLoginView = [[ZJNGeneralLoginView alloc]init];
    }
    return _generalLoginView;
}

-(ZJNFastLoginView *)fastLoginView{
    if (!_fastLoginView) {
        _fastLoginView = [[ZJNFastLoginView alloc]init];
    }
    return _fastLoginView;
}
-(void)topButtonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    self.signButton.selected = NO;
    button.selected = YES;
    self.signButton = button;
    if (button.tag == 10) {
        [UIView animateWithDuration:0.5 animations:^{
            self.sliderView.frame = CGRectMake(ScreenWidth()/4.0-ScreenAdapter(35), ScreenAdapter(180)+AddNav()+35, ScreenAdapter(70), 2);
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.sliderView.frame = CGRectMake(3*ScreenWidth()/4.0-ScreenAdapter(35), ScreenAdapter(180)+AddNav()+35, ScreenAdapter(70), 2);
            self.scrollView.contentOffset = CGPointMake(ScreenWidth(), 0);
        }];
    }
}

#pragma mark-homeBtn
-(void)homeBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int i = scrollView.contentOffset.x/ScreenWidth();
    UIButton *leftBtn = (UIButton *)[self.view viewWithTag:10];
    UIButton *rightBtn = (UIButton *)[self.view viewWithTag:11];
    if (i == 1) {
        leftBtn.selected = NO;
        rightBtn.selected = YES;
        self.signButton = rightBtn;
        [UIView animateWithDuration:0.3 animations:^{
            self.sliderView.frame = CGRectMake(3*ScreenWidth()/4.0-ScreenAdapter(35), ScreenAdapter(180)+AddNav()+35, ScreenAdapter(70), 2);
        }];
    }else{
        leftBtn.selected = YES;
        rightBtn.selected = NO;
        self.signButton = leftBtn;
        [UIView animateWithDuration:0.5 animations:^{
            self.sliderView.frame = CGRectMake(ScreenWidth()/4.0-ScreenAdapter(35), ScreenAdapter(180)+AddNav()+35, ScreenAdapter(70), 2);
        }];
    }
}

-(void)setRegistPhone:(NSString *)registPhone{
    _registPhone = registPhone;
    self.fastLoginView.phone = registPhone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
