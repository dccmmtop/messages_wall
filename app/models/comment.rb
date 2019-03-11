class Comment < ApplicationRecord
  belongs_to :message
  belongs_to :user
  has_many :likes, as: :likeable

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
end
