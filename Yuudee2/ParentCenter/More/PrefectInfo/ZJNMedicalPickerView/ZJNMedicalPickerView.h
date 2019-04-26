//
//  ZJNMedicalPickerView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/12/3.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <BRPickerView/BRPickerView.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ZJNMedicalResultBlock)(NSString *medical);
typedef void (^ZJNMedicalCancelBlock)(void);
@interface ZJNMedicalPickerView : BRBaseView
+(void)showZJNMedicalPickerViewWithResultBlock:(ZJNMedicalResultBlock)resultBlock;
-(instancetype)initWithResultBlock:(ZJNMedicalResultBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END
