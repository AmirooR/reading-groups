class User < ActiveRecord::Base
        
	before_save do
                self.email = email.downcase
		self.login = login.downcase
        end

	VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	VALID_NAME_REGX = /\A\w+\Z/i

	before_create :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }, confirmation: true
	validates :email_confirmation, presence: true
	validates :login, presence: true, format: {with: VALID_NAME_REGEX}, uniqueness: { case_sensitive: false }

	validates :password, presence: true, length: {minimum: 8}
	validates :password_confirmation, presence: true

	has_secure_password

        def User.new_remember_token
                SecureRandom.urlsafe_base64
        end

        def User.digest(token)
                Digest::SHA1.hexdigest(token.to_s)
        end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
	
end
