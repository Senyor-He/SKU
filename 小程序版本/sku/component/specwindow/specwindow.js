// component/specwindow/specwindow.js
const {
  createDateSource,
  getObjKeys
} = require('../../config/sku.js');
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    propsList: Array, //属性列表
    skuData: Object, //sku数据
  },

  /**
   * 组件的初始数据
   */
  data: {
    skuResult: [], //处理好的排列组合方式
    selectedIdArray: [], //存放选中属性id的数组
    selectedValueArray: [], //存放选中属性名的数组
    initialPrice: '', //初始价格
    showPrice: '', //显示价格
    showSpecText: '', //显示规格
    goodsId: '', //商品id
    count: 0, //库存数
  },
  ///组件初始化 处理数据
  attached() {
    var skuData = {
      ...this.properties.skuData
    };
    var skuResult = createDateSource(skuData);
    this.setData({
      skuResult
    });
    this.reloadDataSource();
  },

  /**
   * 组件的方法列表
   */
  methods: {
    ///显示弹窗
    showModal: function () {
      var specwindow = this.selectComponent("#modal");
      specwindow.showModal();
    },
    ///隐藏弹窗
    hideModal: function () {
      var specwindow = this.selectComponent("#modal");
      specwindow.hideModal();
    },
    ///处理初始页面的展示数据 可选 选中 不可选
    reloadDataSource: function () {
      var {
        skuResult,
        propsList,
        selectedIdArray,
        selectedValueArray,
        showPrice,
        count,
      } = {
        ...this.data
      };
      var skuKeys = getObjKeys(skuResult);

      ///取出sku所有组合的价格 取出最大值和最小值 获得价格区间
      var allPrice = [];

      skuKeys.forEach(item => {
        var skuData = skuResult[item];
        var prices = skuData['prices'];
        count = count + skuData['stocksNumber'];
        allPrice = allPrice.concat(prices);
      });
      ///取出最大值和最小值 这就是初始价格
      var maxPrice = Math.max.apply(Math, allPrice);
      var minPrice = Math.min.apply(Math, allPrice);

      showPrice = maxPrice == minPrice ? `￥${minPrice}` : `￥${minPrice}~￥${maxPrice}`;

      if (propsList.length == 0) {
        return;
      }
      ///遍历属性列表
      propsList.forEach((item, i) => {
        var standardInfoList = item.standardInfoList;
        var x = -1;
        var attrValueId = '';
        var standardName = '';
        ///遍历各种规格的值的列表
        for (var j = 0; j < standardInfoList.count; j++) {
          var dict = standardInfoList[j];
          var isSelected = dict.isSelected;
          var AttrValueId = dict.attrValueId;
          var StandardName = dict.standardName;
          ///如果有选中的就跳出该循环
          if (isSelected == 1) {
            x = j;
            attrValueId = AttrValueId;
            standardName = StandardName;
            break;
          }
        }
        //如果x = -1表示当前没有选中的 添加默认值
        if (x == -1) {
          selectedIdArray.push('');
          selectedValueArray.push('');
        } else {
          //表示有选中的 把选中id添加到数组中
          selectedIdArray.push(attrValueId);
          selectedValueArray.push(standardName);
        }
      });
      this.setData({
        selectedIdArray,
        selectedValueArray,
        initialPrice: showPrice,
        showPrice,
        count,
      });
      this.handDisEnableData();
      this.handSpecifications();
    },
    ///处理不可选的数据
    handDisEnableData: function () {
      var {
        skuResult,
        propsList,
        selectedIdArray,
        selectedValueArray,
      } = {
        ...this.data
      };
      var skuKeys = getObjKeys(skuResult);
      ///遍历属性列表
      propsList.forEach((item, i) => {
        var standardInfoList = item.standardInfoList;
        standardInfoList.forEach(item2 => {
          var attrValueId = item2.attrValueId;
          ///将selectedIdArray赋值给一个临时数组 这个地方需要解构 不然会有问题
          var tempArray = [...selectedIdArray];
          ///从已经选好的组合中 移除当前组之前的id 并插入新的id
          tempArray.splice(i, 1, attrValueId);
          ///移除没有选中的组 即 '' 空字符串
          var next = true;
          while (next) {
            var index = tempArray.indexOf('');
            if (index == -1) {
              next = false;
            } else {
              tempArray.splice(index, 1);
            }
          }
          ///将处理完的组合排序
          tempArray.sort(function (value1, value2) {
            return parseInt(value1) - parseInt(value2);
          });
          ///排序之后进行拼接
          var resultKey = tempArray.join(";");
          ///如果找不到当前的组合 表示当前属性不可选 则改变属性列表中isSelect的值
          var index = skuKeys.indexOf(resultKey);
          if (index == -1) {
            item2.isSelect = -1;
          } else {
            ///如果之前是不可选的 然而后续可选  就将isSelect换为0
            if (item2.isSelect == -1) {
              item2.isSelect = 0;
            }
          }
        });
      });
      this.setData({
        propsList
      });
    },
    ///计算价格 库存 已经获取商品id
    calculatePrice: function () {
      var {
        skuResult,
        selectedIdArray,
        initialPrice,
        showPrice,
        goodsId,
        count,
      } = {
        ...this.data
      };
      var skuKeys = getObjKeys(skuResult);
      var tempArray = [...selectedIdArray];
      ///移除没有选中的组 即 '' 空字符串
      var next = true;
      while (next) {
        var index = tempArray.indexOf('');
        if (index == -1) {
          next = false;
        } else {
          tempArray.splice(index, 1);
        }
      }
      ///将处理完的组合排序
      tempArray.sort(function (value1, value2) {
        return parseInt(value1) - parseInt(value2);
      });
      ///排序之后进行拼接
      var resultKey = tempArray.join(";");
      var index = skuKeys.indexOf(resultKey);
      ///重置 在全部取消选中时需要还原
      showPrice = initialPrice;
      goodsId = '';
      count = 0;
      ///表示匹配到了
      if (index != -1) {
        var skuData = skuResult[resultKey];
        var prices = skuData['prices'];
        //取出最大值和最小值 
        var maxPrice = Math.max.apply(Math, prices);
        var minPrice = Math.min.apply(Math, prices);
        showPrice = maxPrice == minPrice ? `￥${minPrice}` : `￥${minPrice}~￥${maxPrice}`;

        if (tempArray.length == 5) {
          ///当五个属性全部选中时 只会有一个id 所以 取第一个就可以了
          var productIds = skuData['productIds'];
          goodsId = productIds[0];
          count = skuData['stocksNumber'];
        }
      }
      this.setData({
        showPrice,
        goodsId,
        count,
      });
    },
    ///处理规格
    handSpecifications: function () {
      var {
        selectedValueArray
      } = {
        ...this.data
      };
      var tempArray = [...selectedValueArray];
      ///移除没有选中的组 即 '' 空字符串
      var next = true;
      while (next) {
        var index = tempArray.indexOf('');
        if (index == -1) {
          next = false;
        } else {
          tempArray.splice(index, 1);
        }
      }
      var showSpecText = tempArray.join(',');
      this.setData({
        showSpecText,
      });
    },

    //属性点击事件
    itemClick: function (event) {
      var {
        propsList,
        selectedIdArray,
        selectedValueArray
      } = {
        ...this.data
      };
      ///取到当前点击的组
      var sectionIndex = event.target.dataset.section;
      var sectionItem = propsList[sectionIndex].standardInfoList;
      ///取到当前点击的行
      var rowIndex = event.target.dataset.row;
      var rowItem = sectionItem[rowIndex];
      var isSelect = rowItem.isSelect;
      ///表示不可选 直接return
      if (isSelect == -1) {
        return;
      }
      ///可选 替换原本的id 插入新的id
      if (isSelect == 0) {
        var attrValueId = rowItem.attrValueId;
        var standardName = rowItem.standardName;
        selectedIdArray.splice(sectionIndex, 1, attrValueId);
        selectedValueArray.splice(sectionIndex, 1, standardName);
        ///遍历当前组 如果已经有选中的 则去掉之前的选中
        sectionItem.forEach(item => {
          if (item.isSelect == 1) {
            item.isSelect = 0;
          }
        });
      }
      ///选中  取消选中
      else {
        selectedIdArray.splice(sectionIndex, 1, '');
        selectedValueArray.splice(sectionIndex, 1, '');
      }
      rowItem.isSelect = isSelect == 1 ? 0 : 1;
      this.setData({
        propsList,
        selectedIdArray,
        selectedValueArray
      });
      this.handDisEnableData();
      this.calculatePrice();
      this.handSpecifications();
    },
    ///提交
    submitAction: function () {
      var {
        goodsId,
        count,
      } = {
        ...this.data
      };
      wx.showToast({
        title: goodsId == '' ? `每一项均为必选` : `匹配到了一件商品，id为:${goodsId}，库存数:${count}`,
        icon: "none",
      });
    }
  }
})