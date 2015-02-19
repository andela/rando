shared_examples 'an unauthenticated user' do |actions_methods|
  actions_methods.each do |action_method|
    let(:action) { action_method.first }
    let(:method) { action_method.last }

    it 'gives an error message' do
      send action, method
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
    end

    it 'redirects to home page' do
      send action, method
      expect(response).to redirect_to :new_user_session
    end
  end
end

