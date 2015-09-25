//
//  MyUtils.m
//  RightNow
//
//  Created by 薄荷 on 15/4/11.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "MyUtils.h"
#import "MusicModel.h"

@implementation MyUtils

static MyUtils *instance = nil;

+ (CGFloat)getScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)getScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}



+ (UIColor *)color:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (CGRect)getTopFrame:(CGRect)frame{
    CGRect f = frame;
    f.origin.y = - f.size.height;
    return f;
}
+ (CGRect)getButtomFrame:(CGRect)frame{
    CGRect f = frame;
    f.origin.y =  f.size.height;
    return f;
}

+ (NSArray *)getMusicCategoryData{
    static int index = 0;
    NSArray *allCategory = [[NSUserDefaults standardUserDefaults] objectForKey:CATEGORY_ALL_ARR];
    NSMutableArray *currentArr = [NSMutableArray array];
    for (int i = 0;  i < 7 ; i ++) {
        [currentArr addObject:allCategory[(i + index * 7) % allCategory.count]];
    }
    index ++;
    return currentArr;
}

//歌单内随机算法，每次生成一个随机播放队列
+ (NSArray *)getMusicData{
    NSMutableArray *allMusic = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_MUSIC_ARR]];
    NSMutableArray *randomMusicArr = [NSMutableArray array];
    int random;
    while (allMusic.count > 0) {
        random = arc4random() % allMusic.count;
        [randomMusicArr addObject:[allMusic objectAtIndex:random]];
        [allMusic removeObjectAtIndex:random];
    }
    
    NSMutableArray *musicArr = [NSMutableArray array];
    NSString *url;
    for (NSDictionary *temp in randomMusicArr) {
        MusicModel *mm = [[MusicModel alloc] init];
        [mm setMusicID:[temp objectForKey:@"musicID"]];
        [mm setMusicTitle:[temp objectForKey:@"musicTitle"]];
        [mm setArtist:[temp objectForKey:@"artist"]];
        url = [NSString stringWithFormat:@"%@/%@",baseMusicResourcesUrl,[temp objectForKey:@"musicUrl"]];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [mm setAudioFileURL:[NSURL URLWithString:url]];
        [musicArr addObject:mm];
        mm = nil;
    }
    return musicArr;
}

+ (NSString *)getToken{//获取本地存储的token
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN];
    return uuid;
}

+ (NSString *)createToken{//创建token
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (void)saveToken:(NSString *)token{//保存token'到本地
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_TOKEN];
}

+ (BOOL)getIsFirstLaunche{//判断是否首次登陆
    NSString *versionStr = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_LAUNCHE];
    if (versionStr == nil) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)setFirstLaunche{//设置为不是首次登陆
    NSString *versionStr = @"1.0";
    [[NSUserDefaults standardUserDefaults] setObject:versionStr forKey:FIRST_LAUNCHE];
}
@end
