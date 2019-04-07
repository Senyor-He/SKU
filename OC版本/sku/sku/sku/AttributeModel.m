//
//  AttributeModel.m
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/18.
//

#import "AttributeModel.h"

@implementation AttributeModel

- (id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在:%@",key);
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在:@property (nonatomic ,strong)NSString * %@;",key);
}

@end
