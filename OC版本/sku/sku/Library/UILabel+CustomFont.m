//
//  UILabel+CustomFont.m
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/6.
//

#import "UILabel+CustomFont.h"
#import <objc/runtime.h>

@implementation UILabel (CustomFont)

+ (void)load {
    Method method1 = class_getInstanceMethod([UILabel class], @selector(customer_awakeFromNib));
    Method method2 = class_getInstanceMethod([UILabel class], @selector(awakeFromNib));
    if (!class_addMethod([UILabel class], @selector(awakeFromNib), method_getImplementation(method1), method_getTypeEncoding(method2))) {
        method_exchangeImplementations(method1, method2);
    } else {
        class_replaceMethod(self, @selector(customer_awakeFromNib), method_getImplementation(method2), method_getTypeEncoding(method2));
    }
}

- (void)customer_awakeFromNib {
    [self customer_awakeFromNib];
    self.font = [UIFont fontWithDescriptor:self.font.fontDescriptor size:self.font.pointSize / 375.0f * SCREEN_WIDTH];
}
@end
