class Notification < ApplicationRecord
  belongs_to :user
  validates_presence_of :content, message: "不能为空"
  default_scope {where(is_delete: false)}
end
