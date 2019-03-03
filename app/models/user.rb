class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :messages, dependent: :delete_all

  validates_length_of :nickname, in: 2..10, message: "昵称长度要小于10大于2"
  validates_length_of :password, in: 6..16, message: "密码长度要小于16大于6", allow_nil: true
  validates_presence_of :email, message: "邮箱不能为空"
  validates_presence_of :nickname, message: "昵称不能为空"
  validates_uniqueness_of  :email,message: "邮箱已被注册"
  validates_uniqueness_of  :nickname,message: "昵称已被占用"

  def self.get_validate_code(email)
    Rails.cache.read(email)
  end
end
