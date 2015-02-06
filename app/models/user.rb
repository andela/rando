class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable, omniauth_providers: [:google_oauth2]

  def self.find_for_google_oauth2 google_response
    data = google_response.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(email: data['email'], name: data['name'])
    end
    user
  end
end
