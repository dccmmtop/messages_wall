class Message < ApplicationRecord
  validates_length_of :content ,minimum: 10, too_short: "留言内容不能少于十个字符"
  validates_presence_of :content,:latitude,:longitude,:limit_days, message: "不能为空"


  default_scope {where(is_delete: false)}
  belongs_to :user

  has_many :likes, as: :likeable
  has_many :reads
  has_many :comments

  acts_as_mappable :default_units => :kms,
    :default_formula => :sphere,
    :distance_field_name => :distance,
    :lat_column_name => :latitude,
    :lng_column_name => :longitude

  def liked_by_user?(user)
    return false if user.nil?
    likes.find_by_user_id(user.id) ? true : false
  end

  def like_by_user(user)
    if user && likes.find_by_user_id(user.id).nil?
      likes.create(user_id: user.id)
    end
  end

  def cancel_like_by_user(user)
    if user && like = likes.find_by_user_id(user.id)
      like.delete
    end
  end

  def read_by_user(user)
    if user && self.reads.find_by_user_id(user.id).nil?
      self.reads.create(user_id: user.id)
    end
  end
  
  def self.search(filter)
    if filter.nil? || filter.strip.length == 0
      all
    else
      where("content ~ ?",filter)
    end
  end

  def destroy
    update(is_delete: true)
    comments.update_all(is_delete: true)
  end

  def repeat(distance)
    origin = Geokit::LatLng.new(latitude, longitude)
    @messages = Message.within(distance * 0.001,:origin => origin).where("now() - created_at < interval '1' day * limit_days")
  end
end
