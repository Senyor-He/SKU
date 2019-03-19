// component/modal/modal.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    height:Number,//弹窗的高度 px为单位
  },

  /**
   * 组件的初始数据
   */
  data: {
    isShow: false,
    animationData: {},
  },

  /**
   * 组件的方法列表
   */
  methods: {
    ///显示弹窗
    showModal: function () {
      var that = this;
      that.setData({
        isShow: true
      })
      var animation = wx.createAnimation({
        duration: 600,//动画的持续时间 默认400ms   数值越大，动画越慢   数值越小，动画越快
        timingFunction: 'ease',//动画的效果 默认值是linear
      });
      this.animation = animation;
      setTimeout(function () {
        that.showAnimation();//调用显示动画
      }, 200);
    },
    //显示动画
    showAnimation: function () {
      this.animation.translateY(0).step()
      this.setData({
        animationData: this.animation.export()//动画实例的export方法导出动画数据传递给组件的animation属性
      });
    },

    // 隐藏弹窗
    hideModal: function () {
      var that = this;
      var animation = wx.createAnimation({
        duration: 800,//动画的持续时间 默认400ms   数值越大，动画越慢   数值越小，动画越快
        timingFunction: 'ease',//动画的效果 默认值是linear
      });
      this.animation = animation;
      that.hideAnimation();//调用隐藏动画   
      setTimeout(function () {
        that.setData({
          isShow: false
        })
      }, 720)//先执行下滑动画，再隐藏模块
    },
    //隐藏动画
    hideAnimation: function () {
      var height = this.data.height;
      this.animation.translateY(height).step()
      this.setData({
        animationData: this.animation.export(),
      })
    }, 
  }
})
