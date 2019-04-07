//
//  SKUManager.h
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKUManager : NSObject

/**
 获取sku所有的组合方式及对应的价格 库存 id

 @param skuData sku数据
 @return 组合结果集
 */
+ (NSArray *)createDataSource:(NSDictionary *)skuData;


/**
 将数组中的元素从小到大排序

 @param array 排序前的数组
 @return 排序后的数组
 */
+ (NSArray *)change:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
