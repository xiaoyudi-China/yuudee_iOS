//
//  ZJNPersonSecondInfoView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/17.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNUserInfoModel.h"
@protocol ZJNPersonSecondInfoViewDelegate<NSObject>
@required
//type:0账号密码 1儿童昵称 2手机号
-(void)personSecondInfoViewChangeInfoWithType:(NSInteger)type;
@end
@interface ZJNPersonSecondInfoView : UIView
@property (nonatomic ,weak)id<ZJNPersonSecondInfoViewDelegate>delegate;
@property (nonatomic ,strong)ZJNUserInfoModel *infoModel;
@end
