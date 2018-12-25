class UserMailer < ApplicationMailer
  def validate_code(user)
    @user = user
  end
  mail(to: @user.email, subject: 'Welcome to My Awesome Site')
end
