class Message < ApplicationRecord
  validates_length_of :content ,minimum: 10, too_short: "留言内容不能少于十个字符"
  validates_presence_of :content,:latitude,:longitude,:limit_days, message: "不能为空"


  default_scope {where(is_delete: false)}
  belongs_to :user

  has_many :like, as: :likeable

  acts_as_mappable :default_units => :kms,
    :default_formula => :sphere,
    :distance_field_name => :distance,
    :lat_column_name => :latitude,
    :lng_column_name => :longitude

  def liked_by_user?(user)
    return false if user.nil?
    like.find_by_user_id(user.id) ? true : false
  end
end
