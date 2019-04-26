//
//  PlayManager.h
//  Yuudee2
//
//  Created by GZP on 2018/10/11.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager : NSObject

+(instancetype)shared;

@property(nonatomic,strong)AVAudioPlayer * player;
-(void)playLocalUrl:(NSString *)url;

@property(nonatomic,strong)AVQueuePlayer * player2;
@property(nonatomic,strong)NSMutableArray * itemsArr;
-(void)playNetUrl:(NSString *)url;

-(void)pause;

@end
