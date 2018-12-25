class UserMailer < ApplicationMailer
  def validate_code(user)
    @user = user
    @code = Raile.cache.fetch(@user.email,Settings.validate_code_time.minutes) do
      [*'0'..'9',*'A'..'Z'].sample(6).join
    end
    mail(to: @user.email, subject: '欢迎注册')
  end
end
