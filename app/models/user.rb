class User < ApplicationRecord
  has_secure_password
  def set_validate_code
    Raile.cache.write(@user.email,Settings.validate_code_time.minutes) do
      [*'0'..'9',*'A'..'Z'].sample(6).join
    end
  end

  def validate_code
    Raile.cache.read(@user.email)
  end
end
