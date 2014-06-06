class AuthenticationsController < ApplicationController
	include Devise::Controllers::Rememberable

  def tsina
    auth = request.env["omniauth.auth"]
    @auth_data = {
      'provider' => :tsina,
      'uid' => auth.extra.raw_info.id,
      'user_info' => {
        'image' => auth.extra.raw_info.profile_image_url,
        'username' => auth.extra.raw_info.screen_name
      }
    }
    common
  end

  def renren
    auth = request.env["omniauth.auth"]
    @auth_data = {
      'provider' => :renren,
      'uid' => auth.uid.to_s,
      'user_info' => {
        'image' => auth.info.image,
        'username' => auth.info.name
      }
    }
    common
  end

  def tqq
    auth = request.env["omniauth.auth"]
    @auth_data = {
      'provider' => :tqq,
      'uid' => auth.uid,
      'user_info' => {
        'image' => auth.extra.raw_info.head + "/100",
        'username' => auth.extra.raw_info.nick
      }
    }
    common
  end

  private
  def common
    @auth = Authentication.find_by_provider_and_uid @auth_data['provider'], @auth_data['uid']
    avatar_url = @auth_data['user_info']['image']
    if @auth
      @user = @auth.user
      @user.avatar_url = avatar_url
      @user.nickname = @auth_data['user_info']['username']
      @user.save
      sign_in @user
      respond_to do |format|
        format.html { redirect_to session_manager.current_url, :notice => t(:'devise.sessions.signed_in') }
      end
    else
      @user = User.new :nickname => @auth_data['user_info']['username']
      @auth = @user.build_authentication(:provider => @auth_data['provider'], :uid => @auth_data['uid'])
      @user.avatar_url = avatar_url
      if @user.save
        sign_in @user
        #clear_category_bits @user
        add_answers_to_user @user
        redirect_to session_manager.current_url, :notice => t(:'devise.sessions.signed_in')
      else
        redirect_to root_path, :notice => t(:'session.failed_auth')
      end
    end
    remember_me(@user)
  end

  def add_answers_to_user user
    if user.persisted? and session[:answers]
      session[:answers].each do |project_id, answers|
        project = Project.find project_id
        if project
          answers ||= []
          answers = answers.map {|a| (a.is_a? Answer) ? a : Answer.new(a)}
          referer = session[:referer_id] ? User.find(session[:referer_id]) : nil
          user.add_answers_for_project answers, project, referer
        end
      end
    end
  end

  def clear_category_bits user
    if user.persisted?
      last_id = (Category.maximum :id) || 0
      bits = 0b0
      last_id.times {bits = (bits << 1) | 0b1}
      user.category_bits = bits
      user.save
    end
  end
end
