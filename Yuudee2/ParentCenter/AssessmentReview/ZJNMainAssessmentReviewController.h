//
//  ZJNMainAssessmentReviewController.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/11/16.
//  Copyright © 2018 北京道口贷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNMainAssessmentReviewController : UIViewController

- (void)testFunction;
- (void)testToAssess:(NSString *)token
                    success:(void (^) (id json))success
                    failure:(void (^)(NSError *error))failure;
@end
