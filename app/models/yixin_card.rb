# -*- encoding: utf-8 -*-
class YixinCard < ActiveRecord::Base
	belongs_to :user
    before_save :send_message_to_user
	def self.unused_card
		where("user_id is null").first
	end
	def send_message_to_user
		return if !user_id_changed? || user_id.blank?
		num = self.user.yixin_cards.count+1
		title = "【领取您的第#{num}张宜农贷爱心助农卡】"
		content= %Q(亲爱的#{user.name}，感谢您参加“爱心宜农贷-她的命运因您而改变”答题活动,您已答对#{num*20}题，
			这是您的第<span style="color:orange;font-size:20px">#{num}</span>张宜农贷<span style="color:orange;font-size:20px">5</span>元爱心助农卡，
			可在“宜农贷官网”（<a href='http://www.yinongdai.com'>www.yinongdai.com</a>）以出借的形式资助贫困农村妇女发展生产，
			农户还款后，该笔资金会返回您的宜农贷账户，并可直接提现。爱心助农卡卡号：#{cards}，密码：#{password}.爱心助农卡有效期：#{expire_at.try(:to_date)||"2013-12-31"}。
			爱心助农卡使用地址：<a href='http://www.yinongdai.com/account/account/helpCardView'>http://www.yinongdai.com/account/account/helpCardView</a>,注册后登录,流程:“我的账户”页面—左侧“账户管理”—“助农卡”—右侧“使用实体卡”—输入卡号+密码,期待您的继续参与！)
		Message.send_message(-1,user_id,{"title"=>title,"content"=>content,"topic"=>"系统邮件"})
	end
end
