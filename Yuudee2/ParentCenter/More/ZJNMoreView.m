//
//  ZJNMoreView.m
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/13.
//  Copyright © 2018年 险峰科技. All rights reserved.
//

#import "ZJNMoreView.h"
#import "ZJNHeaderView.h"
//个人信息
#import "ZJNPersonFirstInfoView.h"
#import "ZJNPersonSecondInfoView.h"
//联系与反馈
#import "ZJNPersonContactView.h"
//当前版本
#import "ZJNPersonVersionView.h"
//微信二维码
#import "ZJNWeChatQRCodeView.h"
//修改儿童昵称
#import "ZJNChangeNickNameViewController.h"
//修改账号密码
#import "ZJNChangePasswordViewController.h"
//修改绑定手机号
#import "ChangePhoneNumberViewController.h"
//完善儿童信息
#import "ZJNPerfectInfoViewController.h"
@interface ZJNMoreView()<QRCodeViewDelegate,ZJNPersonSecondInfoViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger type;//0 完善信息 1 修改信息
}
@property (nonatomic ,strong)ZJNHeaderView *headerView;
@property (nonatomic ,strong)UIScrollView  *scrollView;
@property (nonatomic ,strong)UIView        *containerView;
//个人信息1
@property (nonatomic ,strong)ZJNPersonFirstInfoView *firstInfoView;

@property (nonatomic ,strong)ZJNPersonSecondInfoView *secondInfoView;
//联系与反馈
@property (nonatomic ,strong)ZJNPersonContactView *contactView;
//当前版本
@property (nonatomic ,strong)ZJNPersonVersionView *versionView;
//二维码
@property (nonatomic ,strong)ZJNWeChatQRCodeView *qrCodeView;

@property (nonatomic ,strong)ZJNUserInfoModel *infoModel;
@end
@implementation ZJNMoreView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.infoModel = [[ZJNFMDBManager shareManager] searchCurrentUserInfoWithUserId:[[ZJNTool shareManager] getUserId]];
        if ([self.infoModel.IsRemind isEqualToString:@"1"]) {
            //未完善
            type = 0;
        }else{
            //已完善
            type = 1;
        }
        
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ScreenAdapter(20)+AddNav());
            make.left.equalTo(self).offset(ScreenAdapter(20));
            make.size.mas_equalTo(CGSizeMake(ScreenAdapter(145), ScreenAdapter(45)));
        }];
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgImageView);
        }];
        
        [self.scrollView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.size.equalTo(self.scrollView);
        }];
        if (type == 0) {
            [self.containerView addSubview:self.firstInfoView];
            [self.firstInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self.containerView);
                make.height.mas_equalTo(ScreenAdapter(86));
            }];
        }else{
            [self.containerView addSubview:self.secondInfoView];
            [self.secondInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self.containerView);
                make.height.mas_equalTo(ScreenAdapter(195));
            }];
        }
        
        __block NSInteger kType = type;
        [self.containerView addSubview:self.contactView];
        [self.contactView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            if (kType == 0) {
                make.top.equalTo(self.firstInfoView.mas_bottom);
            }else{
                make.top.equalTo(self.secondInfoView.mas_bottom);
            }
            
            make.height.mas_equalTo(ScreenAdapter(165));
        }];
        
        [self.containerView addSubview:self.versionView];
        [self.versionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.contactView.mas_bottom);
            make.height.mas_equalTo(ScreenAdapter(116));
        }];
        
        [self getDataFromService];
    }
    return self;
}
-(void)getDataFromService{
    // 当前app的信息
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dic = @{@"versionsNumber":app_Version,@"token":[[ZJNTool shareManager] getToken],@"type":@"2"};
    [[ZJNRequestManager sharedManager] postWithUrlString:AboutUs parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            self.infoModel.childNickName = data[@"data"][@"name"];
            self.secondInfoView.infoModel = self.infoModel;
            [self.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:SetStr(data[@"data"][@"img"])]];
            self.contactView.infoDic = data[@"data"][@"suggest"];
            self.qrCodeView.imagePath = SetStr(data[@"data"][@"suggest"][@"weixin"]);
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.viewController showHint:ErrorInfo];
    }];
    
}
-(ZJNHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZJNHeaderView alloc]init];
//        [_headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.photo]];
        _headerView.phoneLabel.text = [NSString changePhontNumber:self.infoModel.phoneNumber];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeaderImage)];
        [_headerView.headerImageView addGestureRecognizer:tapGesture];
    }
    return _headerView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
}
//个人信息1
-(ZJNPersonFirstInfoView *)firstInfoView{
    if (!_firstInfoView) {
        _firstInfoView = [[ZJNPersonFirstInfoView alloc]init];
        [_firstInfoView.infoButton addTarget:self action:@selector(firstInfoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstInfoView;
}

-(ZJNPersonSecondInfoView *)secondInfoView{
    if (!_secondInfoView) {
        _secondInfoView = [[ZJNPersonSecondInfoView alloc]init];
        _secondInfoView.delegate = self;
    }
    return _secondInfoView;
}
//联系与反馈
-(ZJNPersonContactView *)contactView{
    if (!_contactView) {
        _contactView = [[ZJNPersonContactView alloc]init];
        [_contactView.showButton addTarget:self action:@selector(showQRCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactView;
}
//当前版本
-(ZJNPersonVersionView *)versionView{
    if (!_versionView) {
        _versionView = [[ZJNPersonVersionView alloc]init];
    }
    return _versionView;
}
//二维码
-(ZJNWeChatQRCodeView *)qrCodeView{
    if (!_qrCodeView) {
        _qrCodeView = [[ZJNWeChatQRCodeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), ScreenHeight())];
        _qrCodeView.delegate = self;
    }
    return _qrCodeView;
}

#pragma mark-展示二维码
-(void)showQRCodeButtonClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.qrCodeView];
}
#pragma mark-查看二维码
//分享二维码
-(void)shareQRCode{
    [self.qrCodeView removeFromSuperview];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"分享到" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *QQAction = [UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *weChatAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:QQAction];
    [alertC addAction:weChatAction];
    [alertC addAction:cancelAction];
    [self.viewController.navigationController presentViewController:alertC animated:YES completion:nil];
}
//保存二维码
-(void)saveImageWithResult:(NSString *)result{
    [self.viewController showHint:result];
}
#pragma mark-完善个人信息
-(void)firstInfoButtonClick{
    NSLog(@"完善个人信息");
    ZJNPerfectInfoViewController *viewC = [[ZJNPerfectInfoViewController alloc]init];
    [self.viewController.navigationController pushViewController:viewC animated:YES];
}
#pragma mark-修改个人信息
//type:0账号密码 1儿童昵称 2手机号
-(void)personSecondInfoViewChangeInfoWithType:(NSInteger)type{
    if (type == 0) {
        ZJNChangePasswordViewController *viewC = [[ZJNChangePasswordViewController alloc]init];
        viewC.token = self.infoModel.token;
        [self.viewController.navigationController pushViewController:viewC animated:YES];
    }else if (type == 1){
        ZJNChangeNickNameViewController *viewC = [[ZJNChangeNickNameViewController alloc]init];
        viewC.token = self.infoModel.token;
        __weak typeof(self) weakSelf = self;
        viewC.updateNickname = ^(NSString *nickName) {
            weakSelf.infoModel.childNickName = nickName;
            weakSelf.secondInfoView.infoModel = weakSelf.infoModel;
        };
        [self.viewController.navigationController pushViewController:viewC animated:YES];
    }else{
        ChangePhoneNumberViewController *viewC = [[ChangePhoneNumberViewController alloc]init];
        [self.viewController.navigationController pushViewController:viewC animated:YES];
    }
}
//修改头像
-(void)changeHeaderImage{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    UIAlertAction *showAllInfoAction = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.viewController presentViewController:picker animated:YES completion:nil];
        
    }];
    [showAllInfoAction setValue:HexColor(0x444444) forKey:@"_titleTextColor"];
    UIAlertAction *pickAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }];
    [pickAction setValue:HexColor(0x444444) forKey:@"_titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancelAction setValue:HexColor(0x444444) forKey:@"_titleTextColor"];
    [actionSheetController addAction:pickAction];
    [actionSheetController addAction:showAllInfoAction];
    [actionSheetController addAction:cancelAction];
    [self.viewController presentViewController:actionSheetController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.headerView.headerImageView.image = portraitImg;
    
    [self imguploadwithimg:portraitImg];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imguploadwithimg:(UIImage *)image
{
    [[ZJNRequestManager sharedManager] postWithUrlString:FileUpload parameters:nil image:image success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            NSArray *array = data[@"data"][@"images"];
            [self uploadChildPhoto:array[0]];
        }else{
            [self.viewController showHint:data[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.viewController showHint:ErrorInfo];
    }];
}
-(void)uploadChildPhoto:(NSString *)imagePath{
    NSLog(@"%@",imagePath);
    NSDictionary *dic = @{@"token":[[ZJNTool shareManager] getToken],@"photo":imagePath};
    [[ZJNRequestManager sharedManager] postWithUrlString:UpdateChildInfo parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        if ([[data[@"code"] stringValue] isEqualToString:@"200"]) {
            self.infoModel.photo = imagePath;
            [[ZJNFMDBManager shareManager] updateCurrentUserInfoWithModel:self.infoModel];
        }
        [self.viewController showHint:data[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.viewController showHint:ErrorInfo];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
