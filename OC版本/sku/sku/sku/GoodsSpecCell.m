//
//  GoodsSpecCell.m
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/18.
//

#import "GoodsSpecCell.h"

@implementation GoodsSpecCell

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // cell页面布局
        [self renderUI];
    }
    return self;
}

#pragma mark - 渲染UI
- (void)renderUI
{
    WeakSelf
    UILabel * specLabel = [[UILabel alloc]init];
    specLabel.font = MY_Font(14);
    specLabel.layer.cornerRadius = reallySize(25);
    specLabel.layer.masksToBounds = YES;
    [self addSubview:specLabel];
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(reallySize(50));
        make.centerY.equalTo(weakSelf);
    }];
    self.titleLabel = specLabel;
}

#pragma mark - 懒加载
@end
