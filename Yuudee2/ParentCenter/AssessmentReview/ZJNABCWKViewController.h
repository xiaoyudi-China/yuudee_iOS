//
//  ZJNABCWKViewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/13.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNABCWKViewController : UIViewController
@property (nonatomic ,copy)void (^abcRefreshBlock)(void);
@property (nonatomic ,copy)NSString *status;
-(instancetype)initWithStatus:(NSString *)status;

- (void)testFunction;
@end
