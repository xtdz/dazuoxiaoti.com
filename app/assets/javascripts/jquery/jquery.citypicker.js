/**
 * ---------------------------------------- *
 * 城市选择组件 v1.0
 * Author: ZCM
 * QQ: 11565780
 * Mail: zcm@kepme.com
 * ---------------------------------------- *
 * Date: 2012-12-18
 * ---------------------------------------- *
 */

;(function($,undefined){

  function CityPicker(input, options){
    var that=this;
    this.input=input;
    this.settings={
      data:[],
      tipwords:"支持汉字/拼音查询",
      dataformat:/^(\w+)\|([\u4E00-\u9FA5\uf900-\ufa2dA-Za-z0-9_-]+)\|((\w)\w*)\|(.+)$/i,
      //match[1]:id
      //match[2]:name
      //match[3]:pinyin
      //match[4]:first pinyin char
      groupby:[
        ["A-C",/^[a-c]$/i],
        ["D-G",/^[d-g]$/i],
        ["H-J",/^[h-j]$/i],
        ["K-L",/^[k-l]$/i],
        ["M-Q",/^[m-q]$/i],
        ["R-U",/^[r-u]$/i],
        ["W-X",/^[w-x]$/i],
        ["Y-Z",/^[y-z]$/i]],
        placeholder:"请选择",
        showhot:0
    };
    $.extend(this.settings, options);
    /* 如果有预设值，则使用预设值初始化 */
    if (this.settings.value && this.settings.value !== this.settings.placeholder) {
      this.textFor({text:this.settings.value});
    } else {
      this.setValue({text:that.settings.placeholder,value:""});
    }
    this.fdata={};
    this.initialize();
  }

  CityPicker.prototype={
    initialize:function(){
      var that=this;
      this.formatData();

      $(this.input).on('click',function(){
        if(!that.pickPanel){
          that.createWarp();
        }else if(that.pickPanel.hasClass('hide')){
          // dropdown不存在或者dropdown隐藏的时候
          if(!that.dropdown || that.dropdown.hasClass('hide')){
            that.pickPanel.removeClass('hide');
            /* IE6 移除iframe 的hide 样式 */
            if(that.curtain){
              that.curtain.removeClass('hide');
              that.fixCurtain();
            }
          }
        }
      }).on('focus',function(){
        that.input.select();
        if(that.input.value == that.settings.placeholder){
          that.setValue({text:"",value:""});
        }
      }).on('blur',function(){
        if(that.input.value == ''){
          that.setValue({text:that.settings.placeholder,value:""});
        }
      }).on('keyup',function(event){
        var keycode = event.keyCode;
        that.pickPanel.addClass('hide');
        that.createDropdown();

        /* 移除iframe 的hide 样式 */
        that.curtain && that.curtain.removeClass('hide');

        // 下拉菜单显示的时候捕捉按键事件
        if(that.dropdown && !that.dropdown.hasClass('hide') && !that.isEmpty){
          that.pickPanel.addClass('hide');
          that.createDropdown();

          /* 移除iframe 的hide 样式 */
          that.curtain && that.curtain.removeClass('hide');

          // 下拉菜单显示的时候捕捉按键事件
          if(that.dropdown && !that.dropdown.hasClass('hide') && !that.isEmpty){

            var lis = that.dropdown.find('li');
            var len = lis.length;
            switch(keycode){
              case 40: //向下箭头↓
                that.count++;
              if(that.count > len-1) that.count = 0;
              lis.removeClass('on');
              $(lis[that.count]).addClass('on');
              break;
              case 38: //向上箭头↑
                that.count--;
              if(that.count<0) that.count = len-1;
              lis.removeClass('on');
              $(lis[that.count]).addClass('on');
              break;
              case 13: // enter键
                var li=$(lis[that.count]);
              that.setValue({text:li.find('.cityname').text(),value:li.data("value")});
              that.dropdown.addClass('hide');
              /* IE6 */
              that.curtain && that.curtain.addClass('hide');
              break;
              default:
                break;
            }
          }
        }
      });
    },

    setData:function(data){
      var that=this;
      this.settings.data=data||[];
      this.formatData();
      this.rootDiv && this.createPickPanel();
      this.setValue({text:that.settings.placeholder,value:""});
    },

    /**
     * 格式化城市数组为对象fdata，按照groupby分组：
     * {HOT:{groupbyIdx0:[a:[[d1id,d1name],[d2id,d2name]]]},groupbyIdx1:{c:[[d3id,d3name]]}}
     */
    formatData:function(){
      var data = this.settings.data,
      dataformat=this.settings.dataformat,
      groupby=this.settings.groupby,
      match,
      letter;

      for(var i=0,l=groupby.length;i<l;i++){
        this.fdata[i]={};
      }

      for (var i = 0, l = data.length; i < l; i++) {
        match = dataformat.exec(data[i]);
        letter = match[4].toUpperCase();
        for (var j=0,lj=groupby.length;j<lj;j++){
          if(groupby[j][1].test(letter)){
            if(!this.fdata[j][letter])this.fdata[j][letter]=[];
            this.fdata[j][letter].push([match[1],match[2]]);
            break;
          }
        }
      }
    },

    setValue:function(data){
      $(this.input).val(data.text).data("value",data.value);
      if(typeof this.settings.onselect==='function'){
        this.settings.onselect.call(this.input,data||{});
      }
    },

    textFor:function(data){
      var reg = new RegExp($.trim(data.text),'gi'),
      d = this.fdata||[],
      v = {},
      y = false;
      var cv=$(this.input).data("value");
      for(var i in d){
        for(var j in d[i]){
          for(var k in d[i][j]){
            if(reg.test(d[i][j][k][1])){
              v={text:d[i][j][k][1],value:d[i][j][k][0]};
              if(cv!==v.value){
                this.setValue(v);
              }
              y=true;
              break;
            }
          }
          if(y)break;
        }
        if(y)break;
      }
      if(!y){
        v={text:data.text,value:""};
        this.setValue(v);
      }

      if(typeof data.success === 'function'){
        data.success.call(this.input,v);
      }
    },

    /**
     * @createWarp
     * 创建CitiPicker HTML 框架
     */
    createWarp:function(){
      var that = this;
      var input=$(this.input);
      var offset=input.offset();
      offset.bottom=offset.top+input.outerHeight();

      // 设置点击文档隐藏弹出的城市选择框
      $(document).on('click',function(event){
        if(event.target==input[0]) return false;
        if(that.pickPanel)that.pickPanel.addClass("hide");
        if(that.dropdown)that.dropdown.addClass("hide");
        if(that.curtain)that.ie6mask.addClass("hide");
      });

      var rootDiv = this.rootDiv = $('<div>').addClass('cityPicker').css({
        "position":"absolute",
        "left":offset.left,
        "top":offset.bottom,
        "zIndex":999999
      }).on('click',function(){
        // 设置DIV阻止冒泡
        return false;
      });

      // 判断是否IE6，如果是IE6需要添加iframe才能遮住SELECT框
      var isIE = (document.all)?true:false;
      var isIE6 = isIE && !window.XMLHttpRequest;
      if(isIE6){
        this.curtain = $('<iframe>').attr({
          "frameborder":"0",
          "src":"about:blank"
        }).css({
          "position":"absolute",
          "zIndex":-1
        }).appendTo(this.rootDiv);
      }

      var groupby=this.settings.groupby;
      var template='<p class="tip">'+this.settings.tipwords+'</p><ul>';
      for(var i=0,l=groupby.length;i<l;i++){
        template+='<li data-nav="'+i+'"'+((i==0)?' class="on">':'>')+groupby[i][0]+'</li>';
      }
      template+='</ul>';

      var pickPanel = this.pickPanel = $('<div>').addClass("pickPanel").html(template);
      this.cityTabs =  $('<div>').addClass("cityTabs").appendTo(pickPanel);
      rootDiv.append(pickPanel);
      this.createPickPanel();
    },

    /**
     * @createPickPanel
     * TAB下面DIV：hot,a-h,i-p,q-z 分类HTML生成，DOM操作
     */
    createPickPanel:function(){
      var that=this;

      var fdata = this.fdata,
      key="";
      this.cityTabs.html("");
      for(key in fdata){
        var tabdiv = this["tab_"+key] = $('<div>').addClass("tab_"+key+" cityTab hide");

        var ckey="",sortKey=[];
        for(ckey in fdata[key]){
          sortKey.push(ckey);
        }
        // ckey按照ABCDEDG顺序排序
        sortKey.sort();

        for(var j=0,lj=sortKey.length;j<lj;j++){
          var alist = "";
          for(var i=0,a=fdata[key][sortKey[j]],l=a.length;i<l;i++){
            if(a[i][1].length>5){
              alist+='<a href="javascript:" data-value="'+a[i][0]+'" title="'+a[i][1]+'">'+a[i][1].substring(0,5)+'</a>';
            }else{
              alist+='<a href="javascript:" data-value="'+a[i][0]+'">'+a[i][1]+'</a>';
            }
          }
          tabdiv.append($('<dl>')
                        .append($('<dt>').html(sortKey[j] == 'hot'?'&nbsp;':sortKey[j]))
                        .append($('<dd>').html(alist))
                       );
        }

        this.cityTabs.append(tabdiv);
      }
      this.cityTabs.find('.cityTab:first').removeClass('hide');

      $(document.body).append(this.rootDiv);
      /* IE6 */
      this.fixCurtain();

      var navs=this.pickPanel.find('li');
      var tabs=this.cityTabs.find('.cityTab');
      navs.on('click',function(){
        navs.removeClass("on");
        tabs.addClass("hide");
        var nav=$(this);
        nav.addClass("on");
        var tab=that["tab_"+nav.data("nav")];
        if(tab)tab.removeClass("hide");

        /* IE6 改变TAB的时候 改变Iframe 大小*/
        that.fixCurtain();
      });

      this.cityTabs.find('a').on('click',function(){
        var a=$(this);
        that.setValue({text:a.attr('title')||a.text(),value:a.data("value")});
        that.pickPanel.addClass("hide");
        if(that.curtain)
          that.curtain.addClass("hide");
      });
    },

    /**
     * @createDropdown
     * 生成候选词列表
     */
    createDropdown:function () {
      var that=this;
      var value = $.trim($(this.input).val());
      // 当value不等于空的时候执行
      if (value !== '') {
        var data=this.settings.data,
        dataformat=this.settings.dataformat,
        reg = new RegExp("\\|"+value,'gi'),
        lihtml="";
        for (var i = 0, l = data.length, fist=true; i < l; i++) {
          if (reg.test(data[i])){
            var match = dataformat.exec(data[i]);
            if(fist){
              lihtml+='<li data-value="'+match[1]+'" class="on"><b class="cityname">'
              +match[2]+'</b><b class="cityspell">'+match[3]+'</b></li>';
              fist=false;
            }else{
              lihtml+='<li data-value="'+match[1]+'"><b class="cityname">'
              +match[2]+'</b><b class="cityspell">'+match[3]+'</b></li>';
            }
          }
        }
        this.isEmpty = false;
        // 如果搜索数据为空
        if (lihtml === "") {
          this.isEmpty = true;
          lihtml = '<li class="empty">对不起，没有找到数据 "<em>' + value + '</em>"</li>';
        }
        // 如果dropdown不存在则添加ul
        if (!this.dropdown) {
          // 记录按键次数，方向键
          this.count = 0;
          var dropdown = this.dropdown = $('<ul>').addClass("dropdown");
          this.rootDiv && this.rootDiv.append(dropdown);
        } else if (this.dropdown.hasClass('hide')) {
          this.count = 0;
          this.dropdown.removeClass('hide');
        }
        this.dropdown.html(lihtml).find('li').on('click',function(){
          var li=$(this);
          that.setValue({text:li.find('.cityname').text(),value:li.data("value")});
          that.dropdown.addClass('hide');
          /* IE6 下拉菜单点击事件 */
          that.curtain && that.curtain.addClass('hide');
        }).on('mouseover',function(){
          $(this).addClass("on");
        }).on('mouseout',function(){
          $(this).removeClass("on");
        });

        this.fixCurtain();
      }else{
        if(this.dropdown)
          this.dropdown.addClass('hide');
        this.pickPanel.removeClass('hide');
        this.curtain && this.curtain.removeClass('hide');

        this.fixCurtain();
      }
    },

    /* 改变IE6的SELECT遮罩IFRAME的大小 */
    fixCurtain:function(){
      var that=this;
      if(this.curtain){
        this.curtain.css({
          "width":that.rootDiv.width(),
          "height":that.rootDiv.heigth()
        });
      }
    }
  };

  $.fn.extend({
    citypicker:function(options){
      this.citypicker= new CityPicker(this[0],options);
      return this;
    }
  });

})(jQuery);
