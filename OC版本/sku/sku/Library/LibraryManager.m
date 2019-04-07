//
//  LibraryManager.m
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/6.
//

#import "LibraryManager.h"

@implementation LibraryManager

+ (void)showAlertInfo:(NSString *)text withTime:(CGFloat)time
{
    //弹窗宽度
    CGFloat width = (text.length + 2) * 15;
    if (width > SCREEN_WIDTH - 60) {
        width = SCREEN_WIDTH - 60;
    }
    CGFloat height = [LibraryManager getContentHeight:text labelWidth:width - 20 labelFont:15].height;
    
    ///黑色阴影
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height + 30)];
    backView.layer.shadowOffset = CGSizeMake(1, 1);
    backView.layer.shadowOpacity = 0.8;
    backView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    ///蓝色背景
    UIView * subView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, width - 2, height + 28)];
    subView.backgroundColor = RGBA(0, 0, 0, 0.5);
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;
    
    ///提示信息
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, width - 20, height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    [subView addSubview:label];
    
    [backView addSubview:subView];
    
    backView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    
    if (time == 0) {
        time = 2;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backView removeFromSuperview];
    });
}

+ (CGSize)getContentHeight:(NSString *)content labelWidth:(CGFloat)width labelFont:(CGFloat)font
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size;
}

@end
