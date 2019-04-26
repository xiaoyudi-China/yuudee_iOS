//
//  GZPTipView.h
//  Yuudee2
//
//  Created by GZP on 2018/10/12.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GZPTipView;
typedef void (^GZPTipViewBlock)(NSInteger type,GZPTipView * view); //0叉号,1去完善,2去评估,3继续填写,4确认退出

@interface GZPTipView : UIView

@property(nonatomic,copy)GZPTipViewBlock block;
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title block:(GZPTipViewBlock)block;
-(void)show;
@end
