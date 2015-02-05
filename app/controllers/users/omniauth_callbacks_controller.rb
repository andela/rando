class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.find_for_google_oauth2(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in(:user, @user)
    else
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: 'account cannot be saved'
    end

    redirect_to root_path
  end
end
