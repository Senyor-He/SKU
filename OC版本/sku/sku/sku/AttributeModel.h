//
//  AttributeModel.h
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttributeModel : NSObject

@property (nonatomic ,strong)NSString * standardListName;
@property (nonatomic ,strong)NSArray * standardInfoList;
@property (nonatomic ,strong)NSString * standardName;
@property (nonatomic ,strong)NSString * attrValueId;
@property (nonatomic ,strong)NSString * isSelect;

@end

NS_ASSUME_NONNULL_END
