class User < ApplicationRecord

  has_secure_password(validations: false)
  has_secure_token

  has_many :messages, dependent: :delete_all

  has_many :like,  dependent: :delete_all
  has_many :comments
  has_many :notifications
  has_many :limits

  validates_length_of :nickname, in: 2..10, message: "长度要小于10大于1"
  validates_length_of :password, in: 6..16, message: "长度要小于16大于5", allow_nil: true
  validates_confirmation_of :password, message: "不一致"
  validates_presence_of :email, message: "不能为空"
  validates_presence_of :nickname, message: "不能为空"
  validates_uniqueness_of  :email,message: "已被注册"
  validates_uniqueness_of  :nickname,message: "已被占用"

  default_scope {where(is_delete: false)}

  mount_uploader :avatar, AvatarUploader

  include LetterAvatar::AvatarHelper

  def self.get_validate_code(email)
    Rails.cache.read(email)
  end

  def self.search(filter)
    if filter.nil? || filter.strip.length == 0
      all
    else
      where("nickname ~ ? or email ~ ?",filter,filter)
    end
  end

  def is_admin?
    return admin
  end

  def is_limit?
    limits.not_relived.present?
  end

  def current_limit
    limits.is_relived
  end

  def destroy
    update(is_delete: true)
    messages.update_all(is_delete: true)
    comments.update_all(is_delete: true)
    notifications.update_all(is_delete: true)
  end
end
