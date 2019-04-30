//
//  PlayManager.m
//  Yuudee2
//
//  Created by GZP on 2018/10/11.
//  Copyright © 2018年 北京道口贷科技有限公司. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager
+(instancetype)shared
{
    static PlayerManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[PlayerManager alloc]init];
    });
    return manager;
}
-(void)playLocalUrl:(NSString *)url
{
    NSString * can = [[NSUserDefaults standardUserDefaults] objectForKey:@"can"];
    if (![can isEqualToString:@"1"]) return;
    if (url.length == 0) return;
    NSString * path = [[NSBundle mainBundle]pathForResource:url ofType:nil];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [_player play];
}
-(void)playNetUrl:(NSString *)url
{
    NSString * can = [[NSUserDefaults standardUserDefaults] objectForKey:@"can"];
    if (![can isEqualToString:@"1"]) return;

    if (url.length == 0) return;
    
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"] && ![url hasPrefix:@"HTTP://"] && ![url hasPrefix:@"HTTPS://"]) return;
    
    if (![url hasSuffix:@".mp3"] && ![url hasSuffix:@".MP3"]) return;
    
    #warning 测试，后续记得删掉
    ///////////////////测试//////////////////////
    return;
    //////////////////////测试////////////////////
    
    [self validateUrl:url];
    

}
-(void)finishedPlaying
{
    if (self.itemsArr.count > 0) {
        [self.itemsArr removeObjectAtIndex:0];
    }
    if (self.itemsArr.count > 0) {
        self.player2 = [[AVQueuePlayer alloc] initWithPlayerItem:[self.itemsArr firstObject]];
        [self.player2 play];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OverPlay" object:nil];
    }
}
-(NSMutableArray *)itemsArr
{
    if (_itemsArr == nil) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}
-(void)pause
{
    [self.player pause];
    [self.player2 pause];
}
-(void)validateUrl:(NSString *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error) {
            if (self.itemsArr.count > 0) {
                [self.itemsArr removeObjectAtIndex:0];
            }
            if (self.itemsArr.count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OverPlay" object:nil];
            }
        }else{
            [[NSNotificationCenter defaultCenter]removeObserver:self];
            [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(finishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            
            NSString * newURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL * URL2 = [NSURL URLWithString:newURL];
            AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:URL2];
            
            if (item != nil) {
                if (self.itemsArr.count == 0) {
                    [self.itemsArr addObject:item];
                    self.player2 = [[AVQueuePlayer alloc] initWithPlayerItem:[self.itemsArr firstObject]];
                    [self.player2 play];
                }else{
                    [self.itemsArr addObject:item];
                }
            }
        }
    }];
    [task resume];
}
-(void)dealloc
{
    [self.player2 removeObserver:self forKeyPath:@"status"];
}
@end
