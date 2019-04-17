class Limit < ApplicationRecord
  belongs_to :user

  validates_presence_of :day, message: "不能为空"
  validates_presence_of :reason, message: "不能为空"

  def self.relived
    where("is_relived = ?",true)
  end

  def self.not_relived
    find_by_is_relived(false)
  end

  def self.out_date
    where("created_at + interval '1' day * day <= now()")
  end

  def self.relived!
    update_all(is_relived: true)
  end
end

