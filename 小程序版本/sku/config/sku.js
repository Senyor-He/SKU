var resultData = [];
//初始化得到结果集
export function createDateSource(data) {
  var i, j, skuKeys = getObjKeys(data);
  for (i = 0; i < skuKeys.length; i++) {
    var skuKey = skuKeys[i];//一条SKU信息key
    var sku = data[skuKey]; //一条SKU信息value
    var skuKeyAttrs = skuKey.split(";"); //SKU信息key属性值数组
    skuKeyAttrs.sort(function (value1, value2) {
      return parseInt(value1) - parseInt(value2);
    });
    //对每个SKU信息key属性值进行拆分组合
    var combArr = combInArray(skuKeyAttrs);

    for (j = 0; j < combArr.length; j++) {
      add2SKUResult(combArr[j], sku);
    }

    //结果集接放入SKUResult
    resultData[skuKeyAttrs.join(";")] = {
      stocksNumber: sku.stocksNumber,
      prices: [sku.price],
      productIds: [sku.productId],
    }
  }
  return resultData;
}

//把组合的key放入结果集SKUResult
function add2SKUResult(combArrItem, sku) {
  var key = combArrItem.join(";");
  if (resultData[key]) {//SKU信息key属性·
    resultData[key].stocksNumber += sku.stocksNumber;
    resultData[key].prices.push(sku.price);
    resultData[key].productIds.push(sku.productId);
  } else {
    resultData[key] = {
      stocksNumber: sku.stocksNumber,
      prices: [sku.price],
      productIds: [sku.productId],
    };
  }
}

//获得对象的key
export function getObjKeys(obj) {
  if (obj !== Object(obj)) throw new TypeError('Invalid object');
  var keys = [];
  for (var key in obj)
    if (Object.prototype.hasOwnProperty.call(obj, key))
      keys[keys.length] = key;
  return keys;
}

//获取数组对象数组本身之外所有可能得组合方式
function combInArray(array) {
  if (array.length == 0) {
    return [];
  }
  var len = array.length;
  var newArray = [];
  for (var n = 0; n < len; n++) {
    var aaFlag = getComFlags(len, n);
    while (aaFlag.length != 0) {
      var aFlag = aaFlag[0];
      aaFlag.splice(0, 1);
      var aComb = [];
      for (var i = 0; i < len; i++) {
        if (aFlag[i] == 1) {
          aComb.push(array[i]);
        }
      }
      newArray.push(aComb);
    }
  }
  return newArray;
}

function getComFlags(len, n) {
  if (!n || n < 1) {
    return [];
  }
  var bNext = true;
  var aFlag = [];
  for (var i = 0; i < len; i++) {
    var q = i < n ? 1 : 0;
    aFlag.push(q);
  }
  var aResult = [];
  aResult.push(copyArr(aFlag));
  var iCnt1 = 0;
  while (bNext) {
    iCnt1 = 0;
    for (var i = 0; i < len - 1; i++) {
      if (aFlag[i] == 1 && aFlag[i + 1] == 0) {
        for (var j = 0; j < i; j++) {
          var w = j < iCnt1 ? 1 : 0;
          aFlag.splice(j, 1, w);
        }
        aFlag.splice(i, 1, 0);
        aFlag.splice(i + 1, 1, 1);
        var aTmp = copyArr(aFlag);
        aResult.push(aTmp);
        var e = aTmp.length;
        var tempString = '';
        for (var r = e - n; r < e; r++) {
          tempString = `${tempString}${aTmp[r]}`;
        }
        if (tempString.indexOf('0') == -1) {
          bNext = false;
        }
        break;
      }
      if (aFlag[i] == 1) {
        iCnt1++;
      }
    }
  }
  return aResult;

}

//深拷贝aFlag数组
function copyArr(arr) {
  var res = [];
  for (var i = 0; i < arr.length; i++) {
    res.push(arr[i]);
  }
  return res;
}
