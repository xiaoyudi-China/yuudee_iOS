//
//  ZJNStudyProgressView.h
//  Yuudee2
//
//  Created by 朱佳男 on 2018/9/21.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "ZJNParentCenterBasicView.h"
typedef NS_ENUM(NSInteger ,StudyType) {
    MCDYStruct = 0,//名词短语结构
    DCDYStruct,//动词短语结构
    JZJGZCStruct,//句子结构组成
    JZJGFJStruct//句子结构分解
};
@interface ZJNStudyProgressView : ZJNParentCenterBasicView
@property (nonatomic ,assign)StudyType studyType;

- (void)testInfo:(NSString *)token
         success:(void (^) (id json))success
         failure:(void (^)(NSError *error))failure;
@end
