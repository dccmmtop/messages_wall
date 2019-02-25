class UserMailer < ApplicationMailer
  def validate_code(email)
    @code = Rails.cache.fetch(email,expires_in: Settings.validate_code_time.minutes) do
      [*'0'..'9',*'A'..'Z'].sample(6).join
    end
    mail(to: email, subject: '欢迎注册')
  end
end
