//
//  Header.h
//  SKUDemo
//
//  Created by HFL on 2018/4/26.
//  Copyright © 2018年 albee. All rights reserved.
//

#ifndef Header_h
#define Header_h

#pragma mark - 常用宏定义
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height //屏幕高度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width //屏幕宽度

#define iPhone_X    SCREEN_HEIGHT == 812.0f && SCREEN_WIDTH == 375.0f ? YES : NO //iPhone X

#define STATEBAR_HEIGHT   (iPhone_X ? 44.0f : 20.0f)    //状态栏高度
#define NAVBAR_HEIGHT     (STATEBAR_HEIGHT + 44.0f)     //导航栏高度
#define TABBAR_BOTTOM     (iPhone_X ? 34.0f : 0.0f)     //标签栏距离底部高度
#define TABBAR_HEIGHT     (TABBAR_BOTTOM + 49.0f)       //标签栏高度

#define reallySize(size)    SCREEN_WIDTH / 375.0f * size                                                   //计算真实尺寸
#define objIsEmpty(obj)     (obj == nil || [obj isKindOfClass:[NSNull class]])                          //对象是否为空
#define NSString(type,obj)  [NSString stringWithFormat:(type),(obj)]                                    //强转字符串
#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]   //RGB值
#define UIFont(size)        [UIFont systemFontOfSize:size]                                              //字体



#endif /* Header_h */
