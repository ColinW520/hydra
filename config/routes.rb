Rails.application.routes.draw do
  resources :message_recipients
  resources :lines do
    member do
      post :release
    end
  end

  resources :messages do
    collection do
      get :download
    end
  end

  resources :employees, path: :members do
    collection do
      get :download
    end
  end

  root 'static_pages#home'
  match '/home' => "static_pages#home", via: [:get]
  match '/contact' => "static_pages#contact", via: [:get]
  match '/terms' => "static_pages#terms", via: [:get]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }

  match '/twilio/authorize' => 'twilio/authorizations#authorize', via: [:get]
  match '/twilio/deauthorize' => 'twilio/authorizations#deauthorize', via: [:get]

  resource :dashboard, controller: 'dashboard' do
    collection do
      get :list_growth
    end
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :imports
  resources :organizations do
    resources :billing_methods
    resources :subscriptions
  end

  namespace :admin do
    authenticate :user, -> (user) { user.admin_role? } do
      require 'sidekiq/web'
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
