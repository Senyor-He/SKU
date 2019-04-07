//
//  GoodsSpecWindow.h
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsSpecWindow : UIView

@property (nonatomic ,assign)CGFloat viewHeight;//!<弹窗高度
@property (nonatomic ,strong)NSArray * attributeList;//!<规格属性列表
@property (nonatomic ,strong)NSDictionary * skuData;//!<sku数据
@property (nonatomic ,strong)NSArray * skuResult;//!<结果集

/**
 初始化方法

 @return 弹窗对象
 */
- (id)initWithViewHeight:(CGFloat)height;

/**
 显示弹窗
 */
- (void)showWindow;

/**
 关闭弹窗
 */
- (void)closeWindow;

@end

NS_ASSUME_NONNULL_END
