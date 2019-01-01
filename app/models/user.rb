class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :downcase_email
  before_create :create_remember_digest

  has_secure_password

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    Digest::SHA1.hexdigest string
  end


  def create_remember_digest
    self.remember_token  = User.new_token
    self.remember_digest = User.digest(remember_token.to_s)
  end

    private

    def downcase_email
      email.downcase!
    end
end
