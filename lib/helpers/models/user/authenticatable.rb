module Helpers
  module User
    module Authenticatable
      def self.included(base)
        base.has_one :authentication, :dependent => :destroy

        base.devise :database_authenticatable, :registerable, :omniauthable,
          :recoverable, :rememberable, :trackable, :validatable

        base.attr_accessible :email, :password, :password_confirmation, :remember_me,
          :authentication

        base.validates_associated :authentication, :if => :auth_exists?

        base.class_eval <<-METHOD
          def auth_exists?
            !authentication.nil?
          end

          def email_password_required?
            !auth_exists? || !password.nil? || !password_confirmation.nil? || !email.blank?
          end

          def email_required?
            email_password_required?
          end

          def password_required?
            if persisted? && !auth_exists?
              !password.nil? || !password_confirmation.nil?
            else
              email_password_required?
            end
          end

          def valid_password?(password)
            !password_required? || super(password)
          end

          def registered?
            @registered = !email_authentication.nil?
          end
        METHOD
      end
    end
  end
end
