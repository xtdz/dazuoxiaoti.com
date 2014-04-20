# All this logic will automatically be available in application.js.  # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/ 
jQuery ($) ->

  $('div.tab_menu a').bind('click', ->
    $('div.tab.displayed').removeClass('displayed').addClass('hidden')
    if ($(this).attr("name")==".question_tab")
      $(".information").hide()
    else
      $(".information").show()  
    $(this.name).removeClass('hidden').addClass('displayed')
    $('a.tab_label.selected').removeClass('selected')
    $(this).addClass('selected')
    return false
  )
  
  submit_answer_flag = true
  
  $.submit_answer = (value, index) ->
    if submit_answer_flag
      setTimeout($.activate_submit_answer, 3000)
      $('#answer').val(value)
      $('#index').val(index)
      $('.question_form').submit()
      submit_answer_flag = false
  
  $.activate_submit_answer = () ->
    submit_answer_flag = true
  
  $.submit_category = (id, wanted) ->
    $('#id').val(id)
    $('#wanted').val(wanted)
    $('.category_form').submit()

  $.submit_survey = (index) ->
    $('#index').val(index)
    $('.survey_form').submit()

  $.fix_height = () ->
    $('.middle_bottom').height($('.center').height() - 184)

window.weibo_button = (cla, content, path, image_path, size) ->
  _w = 19
  _h = 16
  type = '3'
  if (size == 'big')
    _w = 110
    _h = 24
    type = '5'
  param = {
    url: 'http://' + location.host + path,
    type: type,
    count:'',                                                      # 是否显示分享数，1显示(可选)
    appkey:'',                                                     # 您申请的应用appkey,显示分享来源(可选)
    title: content,                                                # 分享的文字内容(可选，默认为所在页面的title)
    pic:'http://' + location.host + image_path, # 分享图片的路径(可选)
    ralateUid:'2420322617',                                        # 关联用户的UID，分享微博会@该用户(可选)
    language:'zh_cn',                                              # 设置语言，zh_cn|zh_tw(可选)
    rnd: new Date().valueOf()
  }
  temp = (k + '=' + encodeURIComponent( v || '' )  for k, v of param)
  $("."+cla).html('<iframe allowTransparency="true" frameborder="0" scrolling="no" src="http://hits.sinajs.cn/A1/weiboshare.html?' + temp.join('&') + '" width="'+ _w+'" height="'+_h+'"></iframe>')

window.renren_button = (cla, content, path, image_path, size) ->
  html =  '<span class="xn_share_wrapper xn_share_right"><span class="xn_share_small"><span class="xn_share_icon">'
  if (size == 'big')
    html =  '<span class="xn_share_wrapper xn_share_right"><span class="xn_share_medium"><span class="xn_share_button">'
    html += '<span class="xn_share_button_head"></span><span class="xn_share_label">分享到人人</span><span 
class="xn_share_button_end"></span>'
  html += '</span></span></span>'
  param = {
    app_id: '165411',
    url: 'http://' + location.host + path,
    redirect_uri: 'http://www.dazuoxiaoti.com?in=rr',
    name: '小题大作---戳这里进入答题',
    description: '轻松做公益-------【小题大作】是一个趣味性公益问答网站，旨在通过简单、有趣、透明的方式让更多人能够收获知识、贡献爱心。',
    display: 'page',
    message: content,
    image: 'http://' + location.host + image_path
  }
  temp = (k + '=' + encodeURIComponent( v || '' )  for k, v of param)
  style = document.createElement('link')
  style.rel = 'stylesheet'
  style.type = 'text/css'
  style.href = 'http://s.xnimg.cn/connect/css/share_button.css'
  document.getElementsByTagName('head')[0].appendChild(style)
  a = '<a id="xn_button" href="http://widget.renren.com/dialog/feed?' + temp.join('&') + '">' + html + '</a>'
  $("."+cla).html(a)
  document.getElementById('xn_button').onclick = () ->
    window.open(this.href)
    return false

window.qq_button = (cla, content, path, image_path, size) ->
  param = {
    url: 'http://' + location.host + path,
    appkey: '801076262',
    pic: 'http://' + location.host + image_path,
    assname : 'dazuoxiaoti',
    title: content
  }
  temp = (k + '=' + encodeURIComponent( v || '' )  for k, v of param)
  html = '<a id="qq_button" href="http://share.v.t.qq.com/index.php?c=share&a=index&' + temp.join('&') + '">'
  if (size == 'big')
    html += '<img src="http://mat1.gtimg.com/app/vt/images/share/b24.png" valign="middle" border="0" alt="" /></a>'
  else
    html += '<img src="http://v.t.qq.com/share/images/s/weiboicon16.png" valign="middle" border="0" alt="" /></a>'
  $("."+cla).html(html)
  document.getElementById('qq_button').onclick = () ->
    window.open(this.href)
    return false
