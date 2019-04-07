//
//  LibraryManager.h
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LibraryManager : NSObject


/**
 消息提示框
 
 @param text 提示信息
 @param time 显示时间，默认2s
 */
+ (void)showAlertInfo:(NSString *)text withTime:(CGFloat)time;

/**
 获取文本框宽高
 
 @param content 内容
 @param width 布局宽度
 @param font 字体大小
 @return 返回文本框宽高
 */
+ (CGSize)getContentHeight:(NSString *)content labelWidth:(CGFloat)width labelFont:(CGFloat)font;


@end

NS_ASSUME_NONNULL_END
