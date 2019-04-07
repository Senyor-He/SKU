//
//  SKUManager.m
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/18.
//

#import "SKUManager.h"

@implementation SKUManager

+ (NSArray *)createDataSource:(NSDictionary *)skuData
{
    ///重组数据源
    NSDictionary * dic = [SKUManager reCreateDataSource:skuData];
    NSArray * allKeys = dic[@"allKeys"];
    NSArray * valuesArray = dic[@"allValues"];
    
    NSMutableArray * resultDataSource = [[NSMutableArray alloc]init];
    for (int j = 0; j < allKeys.count; j++) {
        NSString * key = allKeys[j];//34;29;18;9;2,
        //使用" ; " 分割当前的字符串
        NSArray * subKeyAttrs = [key componentsSeparatedByString:@";"]; //[34,29,18,9,2]
        NSMutableArray * newArray = [[NSMutableArray alloc]initWithArray:subKeyAttrs];
        
        NSArray * resultArray = [SKUManager change:newArray];
        NSArray * combArray = [SKUManager getAllKeysFromArray:resultArray];
        NSDictionary * value = valuesArray[j];
        
        ///处理结果集的数据
        for (int k = 0; k < combArray.count; k++) {
            NSArray * combArrayItem = combArray[k];
            NSString * tempKey = [combArrayItem componentsJoinedByString:@";"];
            NSMutableArray * keysArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dic in resultDataSource) {
                NSString * keys = dic.allKeys.firstObject;
                [keysArray addObject:keys];
            }
            if ([keysArray containsObject:tempKey]) {
                NSString * price = NSString(@"%@", value[@"price"]);
                NSString * productId = NSString(@"%@", value[@"productId"]);
                NSString * count = NSString(@"%@", value[@"stocksNumber"]);
                int i = 0;
                for (NSDictionary * dict in resultDataSource) {
                    NSString * newKey = dict.allKeys.firstObject;
                    if ([newKey isEqualToString:tempKey]) {
                        NSDictionary * skuDic = dict[newKey];
                        
                        NSString * reCount = NSString(@"%@", skuDic[@"stocksNumber"]);
                        int newCount = [reCount intValue] + [count intValue];
                        
                        NSMutableArray * prices = [[NSMutableArray alloc]initWithArray:skuDic[@"prices"]];
                        [prices addObject:price];
                        
                        NSMutableArray * productIds = [[NSMutableArray alloc]initWithArray:skuDic[@"productIds"]];
                        [productIds addObject:productId];
                        NSDictionary * valueDic = @{@"prices":prices,@"productIds":productIds,@"stocksNumber":@(newCount)};
                        NSDictionary * resultDic = @{newKey:valueDic};
                        //将之前的组合移除，并添加新的组合，跳出循环
                        [resultDataSource removeObjectAtIndex:i];
                        [resultDataSource insertObject:resultDic atIndex:i];
                        break;
                    }
                    i++;
                }
            }
            else
            {
                NSString * price = NSString(@"%@", value[@"price"]);
                NSString * productId = NSString(@"%@", value[@"productId"]);
                NSString * count = NSString(@"%@", value[@"stocksNumber"]);
                NSMutableArray * productIds = [[NSMutableArray alloc]init];
                NSMutableArray * prices = [[NSMutableArray alloc]init];
                [productIds addObject:productId];
                [prices addObject:price];
                NSDictionary * valueDic = @{@"stocksNumber":count,@"prices":prices,@"productIds":productIds};
                NSDictionary * resultDic = @{tempKey:valueDic};
                [resultDataSource addObject:resultDic];
            }
        }
        ///添加完整的组合，即五项全部选中
        NSString * keys = [resultArray componentsJoinedByString:@";"];
        NSString * price = [NSString stringWithFormat:@"%@",value[@"price"]];
        NSString * productId = NSString(@"%@", value[@"productId"]);
        NSString * count = [NSString stringWithFormat:@"%@",value[@"stocksNumber"]];
        NSMutableArray * prices = [[NSMutableArray alloc]init];
        NSMutableArray * productIds = [[NSMutableArray alloc]init];
        [prices addObject:price];
        [productIds addObject:productId];
        NSDictionary * valueDic = @{@"stocksNumber":count,@"prices":prices,@"productIds":productIds};
        NSDictionary * resultDic = @{keys:valueDic};
        [resultDataSource addObject:resultDic];
    }
    return resultDataSource;
}
///重组数据源 获取数据源中所有的key和value
+ (NSDictionary *)reCreateDataSource:(NSDictionary *)skuData
{
    NSArray * allKeys = skuData.allKeys;
    NSMutableArray * keysArray = [[NSMutableArray alloc]init];
    NSMutableArray * valuesArray = [[NSMutableArray alloc]init];
    NSMutableArray * resultArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < allKeys.count; i++) {
        NSString * key = allKeys[i];
        NSDictionary * value = [skuData objectForKey:key];
        NSDictionary * newDic = @{key:value};
        [keysArray addObject:key];
        [valuesArray addObject:value];
        [resultArray addObject:newDic];
    }
    return @{@"newData":resultArray,@"allKeys":keysArray,@"allValues":valuesArray};
}

///将数组中的对象从小到大排序
+ (NSArray *)change:(NSMutableArray *)array{
    if (array.count > 1) {
        for (int  i =0; i<[array count]-1; i++) {
            for (int j = i+1; j<[array count]; j++) {
                if ([array[i] intValue]>[array[j] intValue]) {
                    [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    NSArray * resultArray = [[NSArray alloc]initWithArray:array];
    return resultArray;
}

///获取所有可能的组合
+ (NSArray *)getAllKeysFromArray:(NSArray *)array
{
    if ([array isKindOfClass:[NSNull class]] || array.count == 0) {
        return @[];
    }
    int len = (int)array.count;
    NSMutableArray * resultArray = [[NSMutableArray alloc]init];
    for (int n = 1; n < len; n++) {
        NSMutableArray * aFlags = [[NSMutableArray alloc]initWithArray:[SKUManager getComFlags:len n:n]];
        while (aFlags.count != 0) {
            NSMutableArray * aFlag = [[NSMutableArray alloc]initWithArray:aFlags.firstObject];
            [aFlags removeObjectAtIndex:0];
            NSMutableArray * aComb = [[NSMutableArray alloc]init];
            for (int i = 0; i < len; i++) {
                if ([aFlag[i] intValue] == 1) {
                    [aComb addObject:array[i]];
                }
            }
            [resultArray addObject:aComb];
        }
    }
    return resultArray;
    
}
///获取一个以len为长度的二维数组，其二维数组长度也为len
+ (NSArray *)getComFlags:(int)len n:(int)n
{
    if (!n || n < 1) {
        return @[];
    }
    NSMutableArray * aFlag = [[NSMutableArray alloc]init];
    BOOL bNext = YES;
    for (int i = 0; i < len; i++) {
        int q = i < n ? 1 : 0;
        [aFlag addObject:[NSNumber numberWithInt:q]];
    }
    NSMutableArray * aResult = [[NSMutableArray alloc]init];
    [aResult addObject:[aFlag copy]];
    int iCnt1 = 0;
    while (bNext) {
        iCnt1 = 0;
        for (int i = 0; i < len - 1; i++) {
            if ([aFlag[i] intValue] == 1 && [aFlag[i+1] intValue] == 0) {
                for (int  j = 0; j < i; j++) {
                    int w = j < iCnt1 ? 1 : 0;
                    [aFlag removeObjectAtIndex:j];
                    [aFlag insertObject:[NSNumber numberWithInt:w] atIndex:j];
                }
                [aFlag removeObjectAtIndex:i];
                [aFlag insertObject:@(0) atIndex:i];
                [aFlag removeObjectAtIndex:i+1];
                [aFlag insertObject:@(1) atIndex:i+1];
                NSArray * aTmp = [aFlag copy];
                [aResult addObject:aTmp];
                int e = (int)aTmp.count;
                NSString * tempString;
                for (int r = e - n; r < e; r ++) {
                    tempString = [NSString stringWithFormat:@"%@%@",tempString,aTmp[r]];
                }
                if ([tempString rangeOfString:@"0"].location == NSNotFound) {
                    bNext = false;
                }
                break;
            }
            if ([aFlag[i] intValue] == 1) {
                iCnt1++;
            }
        }
    }
    return aResult;
}
@end
