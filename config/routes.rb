# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  # Static Stuff
  root 'static_pages#home'
  match '/home' => "static_pages#home", via: [:get]
  match '/terms' => "static_pages#terms", via: [:get]

  # The User-facing App
  resource :dashboard, controller: 'dashboard' do
    collection do
      get :list_growth
    end
  end
  resources :lines
  resources :messages, only: [:index, :show]
  resources :message_requests
  resources :contacts
  # resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :imports
  resources :organizations do
    resources :billing_methods
    resources :subscriptions
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    invitations: 'users/invitations',
    passwords: 'users/passwords',
  }

  # Twilio Endpoints
  match '/twilio/authorize' => 'twilio/authorizations#authorize', via: [:get]
  match '/twilio/deauthorize' => 'twilio/authorizations#deauthorize', via: [:get]
  match '/twilio/callbacks/status' => 'twilio/callbacks#status', via: [:get]

  # Admin Space
  namespace :admin do
    authenticate :user, -> (user) { user.admin_role? } do
      require 'sidekiq/web'
      mount Sidekiq::Web => '/sidekiq'
    end
  end
end
