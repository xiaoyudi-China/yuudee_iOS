//
//  GZPModel.h
//  Yuudee2
//
//  Created by GZP on 2018/10/30.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZPModel : NSObject

+(GZPModel *)setModelWithDic:(NSDictionary *)dic;

@property(nonatomic,strong)NSString * valueID;

//名词训练
@property(nonatomic,strong)NSString * colorPenChar;
@property(nonatomic,strong)NSString * colorPenRecord;
@property(nonatomic,strong)NSNumber * createTime;
@property(nonatomic,strong)NSString * groupImage;
@property(nonatomic,strong)NSString * groupRecord;
@property(nonatomic,strong)NSString * groupWord;
@property(nonatomic,strong)NSString * states;
@property(nonatomic,strong)NSNumber * updateTime;
@property(nonatomic,strong)NSString * wireChar;
@property(nonatomic,strong)NSString * wireImage;
@property(nonatomic,strong)NSString * wireRecord;

//名词测试
@property(nonatomic,strong)NSString * cardColorChar;
@property(nonatomic,strong)NSString * cardColorImage;
@property(nonatomic,strong)NSString * cardColorRecord;
@property(nonatomic,strong)NSString * cardWireChar;
@property(nonatomic,strong)NSString * cardWireImage;
@property(nonatomic,strong)NSString * cardWireRecord;
@property(nonatomic,strong)NSNumber * fristAssistTime;
@property(nonatomic,strong)NSString * groupChar;
@property(nonatomic,strong)NSArray * list;
@property(nonatomic,strong)NSNumber * secondAssistTime;

//名词意义测试
@property(nonatomic,strong)NSString * cardAdjectiveChar;
@property(nonatomic,strong)NSString * cardAdjectiveImage;
@property(nonatomic,strong)NSString * cardAdjectiveRecord;
@property(nonatomic,strong)NSString * cardNounChar;
@property(nonatomic,strong)NSString * cardNounImage;
@property(nonatomic,strong)NSString * cardNounRecord;
@property(nonatomic,strong)NSString * disturbType;
@property(nonatomic,strong)NSString * idioType;

//动词训练
@property(nonatomic,strong)NSString * cardChar;
@property(nonatomic,strong)NSString * cardImage;
@property(nonatomic,strong)NSString * cardRecord;
@property(nonatomic,strong)NSString * endSlideshow;
@property(nonatomic,strong)NSString * startSlideshow;
@property(nonatomic,strong)NSString * verbChar;
@property(nonatomic,strong)NSString * verbRecord;
@property(nonatomic,strong)NSString * verbType;

//动词测试
@property(nonatomic,strong)NSString * verbImage;
@property(nonatomic,strong)NSNumber * cardOneTime;
@property(nonatomic,strong)NSString * cardTwoTime;
@property(nonatomic,strong)NSString * cardThreeTime;
@property(nonatomic,strong)NSString * cardFourTime;

//句子成组训练,测试
@property(nonatomic,strong)NSString * cardOneChar;
@property(nonatomic,strong)NSString * cardOneImage;
@property(nonatomic,strong)NSString * cardOneRecord;
@property(nonatomic,strong)NSString * cardTwoChar;
@property(nonatomic,strong)NSString * cardTwoImage;
@property(nonatomic,strong)NSString * cardTwoRecord;

//句子分解训练测试
@property(nonatomic,strong)NSString * cardFourChar;
@property(nonatomic,strong)NSString * cardFourImage;
@property(nonatomic,strong)NSString * cardFourRecord;
@property(nonatomic,strong)NSString * cardThreeChar;
@property(nonatomic,strong)NSString * cardThreeImage;
@property(nonatomic,strong)NSString * cardThreeRecord;

@end





