//
//  GoodsSpecWindow.m
//  YXPharmacyMarket
//
//  Created by Ricky on 2019/3/18.
//

#import "GoodsSpecWindow.h"
#import "GoodsSpecCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "AttributeModel.h"
#import "GoodsSpecHeadView.h"
#import "SKUManager.h"

#define kGoodsSpecCell  @"GoodsSpecCell"
#define kGoodsSpecHeadView  @"GoodsSpecHeadView"

@interface GoodsSpecWindow ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong)UIView * alphaView;//!<阴影背景
@property (nonatomic ,strong)UIView * specView;//!<弹窗
@property (nonatomic ,strong)UICollectionView * collectionView;//!<规格
@property (nonatomic ,strong)NSMutableArray * dataSource;//!<数据源
@property (nonatomic ,strong)NSString * initailPrice;//!<初始价格
@property (nonatomic ,strong)UILabel * goodsPriceLabel;//!<价格
@property (nonatomic ,strong)NSMutableArray * selectedIdArray;//!<标记选中id的数组
@property (nonatomic ,strong)NSMutableArray * selectedValueArray;//!<标记选中title的数组
@property (nonatomic ,strong)NSMutableArray * allKeys;//!<skuResult中所有的key
@property (nonatomic ,strong)UILabel * specLabel;//!<已选规格
@property (nonatomic ,strong)NSString * goodsId;//!<库存
@property (nonatomic ,assign)int goodsCount;//!<商品id

@end

@implementation GoodsSpecWindow

- (id)initWithViewHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        _viewHeight = height;
        [self renderUI];
    }
    return self;
}

#pragma mark - 渲染UI
- (void)renderUI
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //阴影
    [self addSubview:self.alphaView];
    
    //弹窗
    [self addSubview:self.specView];
    
    ///商品背景
    UIView * goodsSuperView = [[UIView alloc]init];
    goodsSuperView.backgroundColor = PURE_COLOR(240);
    goodsSuperView.layer.cornerRadius = reallySize(10);
    goodsSuperView.layer.masksToBounds = YES;
    [self.specView addSubview:goodsSuperView];
    
    [goodsSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-reallySize(60));
        make.left.mas_equalTo(reallySize(30));
        make.width.mas_equalTo(reallySize(260));
        make.height.mas_equalTo(reallySize(260));
    }];
    
    ///商品图片
    UIImageView * goodsImageView = [[UIImageView alloc]init];
    goodsImageView.image = [UIImage imageNamed:@"icon_goods"];
    goodsImageView.layer.cornerRadius = reallySize(10);
    goodsImageView.layer.masksToBounds = YES;
    [goodsSuperView addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.5);
        make.left.mas_equalTo(0.5);
        make.right.mas_equalTo(-0.5);
        make.bottom.mas_equalTo(-0.5);
    }];
    
    ///已选规格
    UILabel * specLabel = [[UILabel alloc]init];
    specLabel.text = @"已选:";
    specLabel.font = MY_Font(12);
    [self.specView addSubview:specLabel];
    self.specLabel = specLabel;
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsSuperView.mas_right).with.offset(reallySize(10));
        make.bottom.equalTo(goodsSuperView.mas_bottom).with.offset(-reallySize(20));
        make.right.mas_equalTo(-reallySize(30));
    }];
    
    ///价格
    UILabel * priceLabel = [[UILabel alloc]init];
    priceLabel.text = @"￥65.00";
    priceLabel.textColor = MAIN_COLOR;
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.specView addSubview:priceLabel];
    self.goodsPriceLabel = priceLabel;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(specLabel);
        make.bottom.equalTo(specLabel.mas_top).with.offset(-reallySize(10));
        make.right.mas_equalTo(-reallySize(30));
    }];
    
    ///关闭
    UIButton * closeButton = [[UIButton alloc]init];
    [closeButton setImage:[UIImage imageNamed:@"icon_spec_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [self.specView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(reallySize(60));
        make.height.mas_equalTo(reallySize(60));
        make.right.mas_equalTo(-reallySize(20));
        make.top.mas_equalTo(reallySize(10));
    }];
    
    ///提交按钮
    UIButton * submitButton = [[UIButton alloc]init];
    [submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"icon_submit_button"] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.specView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-TABBAR_BOTTOM);
    }];
    
    ///规格列表
    [self.specView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(goodsSuperView.mas_bottom);
        make.bottom.equalTo(submitButton.mas_top);
    }];
    
    [self.collectionView registerClass:[GoodsSpecCell class] forCellWithReuseIdentifier:kGoodsSpecCell];
    [self.collectionView registerClass:[GoodsSpecHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGoodsSpecHeadView];
}

#pragma mark - Set
//属性列表数据源
- (void)setAttributeList:(NSArray *)attributeList
{
    _attributeList = attributeList;
}
- (void)setSkuData:(NSDictionary *)skuData
{
    ///获取结果集
    self.skuResult = [SKUManager createDataSource:skuData];
    [self reloadDataSource];
}
#pragma mark - 处理初始页面的展示数据 初始价格 可选 选中 不可选
- (void)reloadDataSource
{
    ///取出skuResult中所有组合方式的价格
    NSMutableArray * allPrice = [[NSMutableArray alloc]init];
    [self.allKeys removeAllObjects];
    for (NSDictionary * sku in self.skuResult) {
        NSString * skuKey = sku.allKeys.firstObject;
        [self.allKeys addObject:skuKey];
        NSDictionary * skuValue = sku[skuKey];
        NSArray * prices = skuValue[@"prices"];
        [allPrice addObjectsFromArray:prices];
    }
    NSArray * tempPrice = [SKUManager change:allPrice];
    NSString * minPrice = tempPrice.firstObject;//最小值
    NSString * maxPrice = tempPrice.lastObject;//最大值
    self.initailPrice = [maxPrice isEqualToString:minPrice] ? NSString(@"￥%@", minPrice) : [NSString stringWithFormat:@"￥%@~￥%@",minPrice,maxPrice];
    self.goodsPriceLabel.text = self.initailPrice;
    
    ///处理页面展示数据源
    if ([self.attributeList isKindOfClass:[NSNull class]]) {
        return;
    }
    int i = 0;
    [self.dataSource removeAllObjects];
    for (NSDictionary * sectionDic in self.attributeList) {
        AttributeModel * sectionModel = [[AttributeModel alloc]init];
        [sectionModel setValuesForKeysWithDictionary:sectionDic];
        NSArray * standardInfoList = sectionModel.standardInfoList;
        NSMutableArray * rowArray = [[NSMutableArray alloc]init];
        
        int x = -1;
        int j = 0;
        NSString * attrValueId = @"";
        NSString * standardName = @"";
        for (NSDictionary * rowDic in standardInfoList) {
            AttributeModel * rowModel = [[AttributeModel alloc]init];
            [rowModel setValuesForKeysWithDictionary:rowDic];
            [rowArray addObject:rowModel];
            //表示当前行已经选中 将下标赋值给x 跳出当前循环
            if (rowModel.isSelect.intValue == 1) {
                x = j;
                attrValueId = NSString(@"%@", rowModel.attrValueId);
                standardName = NSString(@"%@", rowModel.standardName);
                break;
            }
            j++;
        }
        
        ///表示当前组没有选中的  添加占位符
        if (x == -1) {
            [self.selectedIdArray addObject:@""];
            [self.selectedValueArray addObject:@""];
        }
        else
        {
            [self.selectedIdArray addObject:attrValueId];
            [self.selectedValueArray addObject:standardName];
        }
        [sectionModel setValue:rowArray forKey:@"standardInfoList"];
        [self.dataSource addObject:sectionModel];
        i++;
    }
    [self calculatePrice];
    [self handSpecifications];
    [self handDisEnableData];
}
///处理不可选的数据
- (void)handDisEnableData
{
    int i = 0;
    for (AttributeModel * sectionModel in self.dataSource) {
        NSArray * standardInfoList = sectionModel.standardInfoList;
        int j = 0;
        for (AttributeModel * rowModel in standardInfoList) {
            NSString * attrValueId = NSString(@"%@", rowModel.attrValueId);
            NSMutableArray * tempSelectIdArray = [[NSMutableArray alloc]initWithArray:self.selectedIdArray];
             //从已经选好的组合中，移除当前组之前的id，并插入新的id
            [tempSelectIdArray removeObjectAtIndex:i];
            [tempSelectIdArray insertObject:attrValueId atIndex:i];

            NSMutableArray * resultArray = [[NSMutableArray alloc]init];
            ///添加不为空的项 即移除tempSelectIdArray中为空的项
            for (NSString * attrValueIdString in tempSelectIdArray) {
                if (![attrValueIdString isEqualToString:@""]) {
                    [resultArray addObject:attrValueIdString];
                }
            }
            ///排序 并拼接 得到一个临时组合
            NSString * tempKey = [[SKUManager change:resultArray] componentsJoinedByString:@";"];
            ///如果所有组合方式中有当前的临时组合  表示该项可选 否则不可选
            if (![self.allKeys containsObject:tempKey]) {
                [rowModel setValue:@"-1" forKey:@"isSelect"];
            }
            else
            {
                ///如果之前是不可选的 然而后续可选  就将isSelect换为0
                if (rowModel.isSelect.intValue == -1) {
                    [rowModel setValue:@"0" forKey:@"isSelect"];
                }
            }
            j++;
        }
        i++;
    }
    [self.collectionView reloadData];
}

///计算价格 库存 商品id
- (void)calculatePrice
{
    NSMutableArray * resultArray = [[NSMutableArray alloc]init];
    ///添加不为空的项 即移除tempSelectIdArray中为空的项
    for (NSString * attrValueIdString in self.selectedIdArray) {
        if (![attrValueIdString isEqualToString:@""]) {
            [resultArray addObject:attrValueIdString];
        }
    }
    ///排序 并拼接 得到一个临时组合
    NSString * tempKey = [[SKUManager change:resultArray] componentsJoinedByString:@";"];
    
    ///重置 在全部取消选中时需要还原
    NSString * price = self.initailPrice;
    NSString * goodsId = @"";
    int count = 0;
    
    for (NSDictionary * sku in self.skuResult) {
        NSString * newKey = sku.allKeys.firstObject;
        if ([newKey isEqualToString:tempKey]) {
            NSDictionary * skuValue = sku[newKey];
            NSArray * prices = skuValue[@"prices"];
            NSArray * tempPrice = [SKUManager change:[[NSMutableArray alloc]initWithArray:prices]];
            NSString * minPrice = tempPrice.firstObject;//最小值
            NSString * maxPrice = tempPrice.lastObject;//最大值
            price = [maxPrice isEqualToString:minPrice] ? NSString(@"￥%@", minPrice) : [NSString stringWithFormat:@"￥%@~￥%@",minPrice,maxPrice];
            
            ///全部选中时 可以得到商品id
            if (resultArray.count == 5) {
                goodsId = NSString(@"%@", skuValue[@"productIds"][0]);
                count = [skuValue[@"stocksNumber"] intValue];
            }
        }
    }
    self.goodsPriceLabel.text = price;
    self.goodsId = goodsId;
    self.goodsCount = count;
}
///处理规格
- (void)handSpecifications
{
    NSMutableArray * resultArray = [[NSMutableArray alloc]init];
    ///添加不为空的项 即移除tempSelectIdArray中为空的项
    for (NSString * attrValueString in self.selectedValueArray) {
        if (![attrValueString isEqualToString:@""]) {
            [resultArray addObject:attrValueString];
        }
    }
    self.specLabel.text = [@"已选:" stringByAppendingString:[resultArray componentsJoinedByString:@","]];
}

#pragma mark - 事件
- (void)showWindow
{
    self.hidden = NO;
    self.alphaView.hidden = NO;
    self.specView.hidden = NO;
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.specView.frame = CGRectMake(0, SCREEN_HEIGHT - weakSelf.viewHeight, SCREEN_WIDTH, weakSelf.viewHeight);
    }];
}

- (void)closeWindow
{
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.specView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, weakSelf.viewHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.alphaView.hidden = YES;
            weakSelf.hidden = YES;
            weakSelf.specView.hidden = YES;
        }
    }];
}
///提交
- (void)submitAction
{
    if ([self.goodsId isEqualToString:@""]) {
        [LibraryManager showAlertInfo:@"每一项均为必选" withTime:2];
    }
    else
    {
        [LibraryManager showAlertInfo:[NSString stringWithFormat:@"已经匹配到一件商品，商品id为:%@,库存数为%d",self.goodsId,self.goodsCount] withTime:2];
    }
}

///阴影点击
- (void)alphaClick
{
    [self closeWindow];
}
#pragma mark - 代理方法
#pragma mark - collectionView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AttributeModel * model = self.dataSource[section];
    return model.standardInfoList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsSpecCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsSpecCell forIndexPath:indexPath];
    AttributeModel * sectionModel = self.dataSource[indexPath.section];
    AttributeModel * rowModel = sectionModel.standardInfoList[indexPath.row];
    cell.titleLabel.text = NSString(@"  %@  ", rowModel.standardName);
    NSString * isSelect = NSString(@"%@", rowModel.isSelect);
    ///未选中
    if (isSelect.intValue == 0) {
        cell.titleLabel.textColor = PURE_COLOR(147);
        cell.titleLabel.backgroundColor = PURE_COLOR(234);
    }
    ///选中
    else if (isSelect.intValue == 1){
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.backgroundColor = MAIN_COLOR;
    }
    ///不可选
    else
    {
        cell.titleLabel.textColor = PURE_COLOR(200);
        cell.titleLabel.backgroundColor = PURE_COLOR(245);
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttributeModel * sectionModel = self.dataSource[indexPath.section];
    AttributeModel * rowModel = sectionModel.standardInfoList[indexPath.row];
    NSString * string = NSString(@"  %@  ", rowModel.standardName);;
    CGFloat width = [LibraryManager getContentHeight:string labelWidth:SCREEN_WIDTH labelFont:14].width;
    return CGSizeMake(width, reallySize(50));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    GoodsSpecHeadView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kGoodsSpecHeadView forIndexPath:indexPath];
    AttributeModel * sectionModel = self.dataSource[indexPath.section];
    headView.titleLabel.text = NSString(@"%@", sectionModel.standardListName);
    return headView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, reallySize(60));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttributeModel * sectionModel = self.dataSource[indexPath.section];
    AttributeModel * rowModel = sectionModel.standardInfoList[indexPath.row];
    ///表示不可选 直接return
    int isSelect = rowModel.isSelect.intValue;
    if (isSelect == -1) {
        return;
    }
    ///可选 替换原本的id 插入新的id
    if (isSelect == 0) {
        NSString * attrValueId = NSString(@"%@", rowModel.attrValueId);
        NSString * standardName = NSString(@"%@", rowModel.standardName);
        [self.selectedIdArray removeObjectAtIndex:indexPath.section];
        [self.selectedIdArray insertObject:attrValueId atIndex:indexPath.section];
        [self.selectedValueArray removeObjectAtIndex:indexPath.section];
        [self.selectedValueArray insertObject:standardName atIndex:indexPath.section];
        ///去掉之前的选中状态
        for (AttributeModel * model in sectionModel.standardInfoList) {
            if (model.isSelect.intValue == 1) {
                [model setValue:@(0) forKey:@"isSelect"];
            }
        }
    }
    //选中  取消选中
    else
    {
        [self.selectedIdArray removeObjectAtIndex:indexPath.section];
        [self.selectedIdArray insertObject:@"" atIndex:indexPath.section];
        [self.selectedValueArray removeObjectAtIndex:indexPath.section];
        [self.selectedValueArray insertObject:@"" atIndex:indexPath.section];
    }
    [rowModel setValue:isSelect == 1 ? @(0) : @(1) forKey:@"isSelect"];
    [self calculatePrice];
    [self handSpecifications];
    [self handDisEnableData];
}

#pragma mark - 懒加载
- (UIView *)alphaView
{
    if (_alphaView == nil) {
        _alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _alphaView.backgroundColor = RGBA(0, 0, 0, 0.3);
        _alphaView.hidden = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alphaClick)];
        [_alphaView addGestureRecognizer:tap];
    }
    return _alphaView;
}
- (UIView *)specView
{
    if (_specView == nil) {
        _specView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _viewHeight)];
        _specView.backgroundColor = [UIColor whiteColor];
    }
    return _specView;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewLeftAlignedLayout * layout = [[UICollectionViewLeftAlignedLayout alloc]init];
        layout.minimumInteritemSpacing = reallySize(16);
        layout.minimumLineSpacing = reallySize(16);
        layout.sectionInset = UIEdgeInsetsMake(reallySize(8), reallySize(30), reallySize(8), reallySize(30));
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _collectionView.backgroundColor = PURE_COLOR(250);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (NSMutableArray *)selectedIdArray
{
    if (_selectedIdArray == nil) {
        _selectedIdArray = [[NSMutableArray alloc]init];
    }
    return _selectedIdArray;
}
- (NSMutableArray *)selectedValueArray
{
    if (_selectedValueArray == nil) {
        _selectedValueArray = [[NSMutableArray alloc]init];
    }
    return _selectedValueArray;
}
- (NSMutableArray *)allKeys
{
    if (_allKeys == nil) {
        _allKeys = [[NSMutableArray alloc]init];
    }
    return _allKeys;
}
@end
