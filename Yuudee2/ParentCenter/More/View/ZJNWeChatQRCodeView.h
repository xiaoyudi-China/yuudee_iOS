//
//  ZJNWeChatQRCodeView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/17.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QRCodeViewDelegate<NSObject>
@required
//分享二维码
-(void)shareQRCode;
//保存图片
-(void)saveImageWithResult:(NSString *)result;
@end
@interface ZJNWeChatQRCodeView : UIView
@property (nonatomic ,strong)NSString *imagePath;
@property (nonatomic ,strong)UIButton *shareBtn;
@property (nonatomic ,strong)UIButton *saveButton;
@property (nonatomic ,weak)id<QRCodeViewDelegate>delegate;
@end
