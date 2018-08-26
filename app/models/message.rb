class Message < ApplicationRecord
  default_scope {where(is_delete: false)}
end
