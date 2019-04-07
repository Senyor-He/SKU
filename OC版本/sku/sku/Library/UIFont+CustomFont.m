//
//  UIFont+CustomFont.m
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/6.
//

#import "UIFont+CustomFont.h"
#import <objc/runtime.h>

@implementation UIFont (CustomFont)
+ (void)load {
    Method newSystemMethod = class_getClassMethod([self class], @selector(custom_systemFontOfSize:));
    Method newBoldMethod = class_getClassMethod([self class], @selector(custom_boldSystemFontSize:));
    Method systemMethod = class_getClassMethod([self class], @selector(systemFontOfSize:));
    Method boldMethod = class_getClassMethod([self class], @selector(boldSystemFontOfSize:));
    method_exchangeImplementations(newSystemMethod, systemMethod);
    method_exchangeImplementations(newBoldMethod, boldMethod);
}
+ (UIFont *)custom_systemFontOfSize:(CGFloat)fontSize {
    UIFont * newFont = [UIFont custom_systemFontOfSize:fontSize * SCREEN_WIDTH / 375.0f];
    return newFont;
}
+ (UIFont *)custom_boldSystemFontSize:(CGFloat)fontSize {
    UIFont * newFont = [UIFont custom_boldSystemFontSize:fontSize * SCREEN_WIDTH / 375.0f];
    return newFont;
}
@end
