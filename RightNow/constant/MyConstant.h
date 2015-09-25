//
//  MyConstant.h
//  RightNow
//
//  Created by 薄荷 on 15/4/11.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#ifndef RightNow_MyConstant_h
#define RightNow_MyConstant_h
//系统默认背景色
#define ViewBgColor @"1c1c1c"

//音乐类别
#define CATEGORY_ALL_ARR @"categoryAllArr"
#define CATEGORY_CURRENT @"categoryCurrent"
#define CURRENT_MUSIC_ARR @"currentMusicArr"
//储存是否是第一次启动
#define FIRST_LAUNCHE @"firstLaunche"
//用户token
#define USER_TOKEN @"userToken"
//请求的url   127.0.0.1
static NSString *baseUrl = @"http://127.0.0.1:8080/RightNow";//
static NSString *createUserUrl = @"/api/createUser";
static NSString *getCategoryUrl = @"/api/getCategory";
static NSString *getMusicListUrl = @"/api/getMusicList";
static NSString *getIsFavoriteUrl = @"/api/getIsFavorite";
static NSString *setFavoriteUrl = @"/api/setFavorite";

//资源url
static NSString *baseMusicResourcesUrl = @"http://127.0.0.1:8080/RightNow/music";//
static NSString *baseCateIconUrl = @"http:/127.0.0.1:8080/RightNow/picture/category";//
static NSString *basePlayPicUrl = @"http://127.0.0.1:8080/RightNow/picture/playPic";//
#endif
