require "base64"
require "json"
require "openssl"

class SinaApp::AppController < ApplicationController
  layout 'sina_app'

  def authenticate
    auth = decode_request params["signed_request"]
    if auth["user_id"] and authenticate_user auth
      main
    else
      authorize
    end
  end

  def authorize
    @app_key = key
    @redirect_url = 'http://apps.weibo.com/dazuoxiaoti'
    render :authorize
  end

  def main
    @project = Project.find 6
    render :main
  end

  def decode_request signed_request
    if signed_request
      encoded_signature, payload = signed_request.split('.')
      if base64_decode(encoded_signature) == sign_message(payload)
        JSON.parse base64_decode(payload)
      else
        nil
      end
    else
      nil
    end
  end

  def base64_decode encoded_str
    formatted_str = encoded_str.gsub('-', '+').gsub('_', '/').concat("=" * (4 - encoded_str.length % 4))
    Base64.decode64 formatted_str
  end

  def sign_message message
    OpenSSL::HMAC.digest "sha256", secret, message
  end

  def secret
    @secret ||= Devise.omniauth_configs[:tsina_app].args[1]
  end

  def key
    @key ||= Devise.omniauth_configs[:tsina_app].args[0]
  end

  def authenticate_user auth_data
    auth = Authentication.find_by_provider_and_uid :tsina, auth_data["user_id"]
    if !auth
      user = User.new :nickname => "sina_user_#{auth_data["user_id"]}"
      auth = user.build_authentication(:provider => :tsina, :uid => auth_data['user_id'])
      if !user.save
        return false
      end
    end
    sign_in auth.user
    return true
  end
end
