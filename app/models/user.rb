class User < ApplicationRecord

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def update_with_password(params, *options)
    if options.present?
        ActiveSupport::Deprecation.warn <<-DEPRECATION.strip_heredoc
        [Devise] The second argument of `DatabaseAuthenticatable#update_with_password`
        (`options`) is deprecated and it will be removed in the next major version.
        It was added to support a feature deprecated in Rails 4, so you can safely remove it
        from your code.
        DEPRECATION
    end

	puts 'update_with_password ' + params[:password] + ' ' + params[:password].blank?.to_s

    current_password = params.delete(:current_password)

    if params[:password].blank?
		puts 'NOPASS'
        params.delete(:password)
        params.delete(:password_confirmation) if params[:password_confirmation].blank?
		self.errors.add(:password, :blank)
		return false
    end

    result = update(params, *options)
        
    clean_up_passwords
    result
  end

end
