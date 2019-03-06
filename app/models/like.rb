class Like < ApplicationRecord
  belongs_to :likeable , polymorphic: true

  validates_uniqueness_of :likeable_type,scope: [:likeable_id, :user_id]
end
