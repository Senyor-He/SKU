//
//  GoodsSpecHeadView.m
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/18.
//

#import "GoodsSpecHeadView.h"

@implementation GoodsSpecHeadView

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
    UILabel * specTitleLabel = [[UILabel alloc]init];
    specTitleLabel.font = MY_Font(14);
    specTitleLabel.textColor = PURE_COLOR(147);
    [self addSubview:specTitleLabel];
    [specTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(reallySize(30));
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.titleLabel = specTitleLabel;
}
@end
