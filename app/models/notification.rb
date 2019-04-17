class Notification < ApplicationRecord
  belongs_to :user
  validates_presence_of :content, message: "不能为空"
  default_scope {where(is_delete: false)}

  def user_name
    if category == "all_user"
      return "所有人"
    else
      return user.nickname.truncate(10)
    end
  end
end
