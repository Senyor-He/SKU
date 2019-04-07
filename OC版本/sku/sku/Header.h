//
//  Header.h
//  sku
//
//  Created by Ricky on 2019/4/7.
//  Copyright © 2019 Ricky. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define NSString(type,obj)  [NSString stringWithFormat:(type),(obj)]                                    //强转字符串
#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]   //RGB值
#define MY_Font(size)        [UIFont systemFontOfSize:size]                                             //字体
#define MAIN_COLOR          RGBA(241,2,21,1)                                                            //主题颜色
#define PURE_COLOR(rgb)     RGBA(rgb,rgb,rgb,1)                                                         //纯色
#define reallySize(size)    SCREEN_WIDTH / 750.0f * size                                                //计算真实尺寸
#define WeakSelf            __weak typeof(self) weakSelf = self;                                        //弱引用
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height //屏幕高度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})//判断机型是否为iPhone (X / XS / XR / XS Max)
#define STATEBAR_HEIGHT   (IPHONE_X ? 44.0f : 20.0f)    //状态栏高度
#define NAVBAR_HEIGHT     (STATEBAR_HEIGHT + 44.0f)     //导航栏高度
#define TABBAR_BOTTOM     (IPHONE_X ? 34.0f : 0.0f)     //标签栏距离底部高度
#define TABBAR_HEIGHT     (TABBAR_BOTTOM + 49.0f)       //标签栏高度

#import "LibraryManager.h"
#import <Masonry/Masonry.h>
#endif /* Header_h */
