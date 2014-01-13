# -*- encoding: utf-8 -*-
class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.text :content
      t.string :topic
      t.integer :kind ,:default=>1
      t.integer :status

      t.timestamps
    end
    #u = User.new({:id=>-1,:email=>"admin@dazuoxiaoti.com",:password=>"123456",:nickname=>"系统管理员",:name=>"系统管理员"})
    #u.id=-1
    #u.save
  end
end
