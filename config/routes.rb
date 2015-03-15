Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } do
    get '/users/auth/:provider', to: 'users/omniauth_callbacks#passthru'
  end

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  get 'users/distribute', to: 'distributors#index', as: :distributors
  get 'users/allocate_money/new', to: 'distributors#new_allocation', as: :new_allocation
  post 'users/allocate_money', to: 'distributors#allocate_money', as: :allocate_money

  resources :users, only: :index
  put 'users/roles/update', to: 'roles#update_multiple', as: :update_user_roles
  get 'users/roles/edit', to: 'roles#edit_multiple', as: :edit_user_roles

  resources :campaigns

  post 'transaction/deposit/', to: 'transactions#deposit', as: :deposit
  post 'transaction/withdraw/', to: 'transactions#withdraw', as: :withdraw

  get 'transaction/deposit/new', to: 'transactions#new_deposit', as: :new_deposit
  get 'transaction/withdraw/new', to: 'transactions#new_withdrawal', as: :new_withdrawal

  resources :transactions, only: [:index]


  get 'my_andonation', to: 'my_andonation#index', as: :my_andonation

  get 'my_andonation/campaigns', to: 'my_andonation#campaigns', as: :my_campaigns

# You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
