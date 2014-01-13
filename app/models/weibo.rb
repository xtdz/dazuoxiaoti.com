class Weibo < ActiveRecord::Base
  belongs_to :project

  def src
    if uid.nil? or token.nil?
      "http://widget.weibo.com/livestream/listlive.php?language=zh_cn&width=0&height=500&uid=1789679217&skin=2&refer=0&pic=1&titlebar=0&border=1&publish=1&atalk=1&recomm=0&at=0&atopic=#{encoded_tag}&ptopic=#{encoded_tag}&appkey=3986218696&colordiy=1&color=99D9EA,D6F3F7,666666,0082CB,F1F0E2,ECFBFD&dpc=1"
    else
      "http://widget.weibo.com/weiboshow/index.php?language=&width=0&height=500&fansRow=1&ptype=0&speed=0&skin=-1&isTitle=0&noborder=1&isWeibo=1&isFans=0&uid=#{uid}&verifier=#{token}&colors=d6f3f7,f1f0e2,666666,0082cb,ecfbfd&dpc=1"
    end
  end

  def encoded_tag
    @encoded_tag ||= URI.encode(tag)
  end
end
