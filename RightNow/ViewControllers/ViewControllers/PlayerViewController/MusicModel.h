//
//  MusicModel.h
//  RightNow
//
//  Created by 薄荷 on 15/5/4.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"

@interface MusicModel : NSObject <DOUAudioFile>

@property (nonatomic, strong) NSNumber *musicID;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *musicTitle;
@property (nonatomic, strong) NSURL *audioFileURL;

@end
