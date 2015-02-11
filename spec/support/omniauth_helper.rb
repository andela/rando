def set_valid_omniauth
  OmniAuth.config.add_mock(:google_oauth2, build_google_oauth2_response)
end

def set_invalid_omniauth
  OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
end

def build_google_oauth2_response(email = nil)
  OmniAuth::AuthHash.new({
       provider: 'google_auth2',
       uid: '123456789',
       info: {
           name: 'Christopher Columbus',
           email: email || 'christopher@andela.co',
           first_name: 'Christopher',
           last_name: 'Columbus',
           image: 'https://lh3.googleusercontent.com/url/photo.jpg'
       },
       credentials: {
           token: 'token',
           refresh_token: 'another_token',
           expires_at: 1354920555,
           expires: true
       },
       extra: {
           raw_info: {
               sub:  '123456789',
               email: 'user@domain.example.com',
               email_verified: true,
               name: 'Christopher Columbus',
               given_name: 'Christopher',
               family_name: 'Columbus',
               profile: 'https://plus.google.com/123456789',
               picture: 'https://lh3.googleusercontent.com/url/photo.jpg',
               gender: 'male',
               birthday: '0000-06-25',
               locale: 'en',
               hd: 'andela.co'
           }
       }
   })
end