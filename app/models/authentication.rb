class Authentication < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :provider, :uid

  def self.find_by_provider_and_uid(provider, uid)
    self.where(:provider => provider, :uid => uid).includes(:user).first
  end

  def user_type
    case provider
    when 'tsina'
      :'user.type.sina'
    when 'renren'
      :'user.type.renren'
    when 'tqq'
      :'user.type.qq'
    else
      :'user.type.dazuoxiaoti'
    end
  end
  
  def user_link
    case provider
    when 'tsina'
      'http://weibo.com/u/' + uid + '?out=xiaotidazuo'
    when 'renren'
      'http://www.renren.com/' + uid + '?out=xiaotidazuo'
    when 'tqq'
      'http://t.qq.com/' + uid + '?out=xiaotidazuo'
    else
      ''
    end
  end
end
