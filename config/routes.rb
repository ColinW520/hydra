require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Static Stuff
  root 'static_pages#home'
  match '/home' => "static_pages#home", via: [:get]
  match '/terms' => "static_pages#terms", via: [:get]
  match '/anti-spam' => "static_pages#anti_spam", via: [:get]
  match '/changelog' => "static_pages#changelog", via: [:get]
  match '/privacy' => "static_pages#privacy", via: [:get]
  post '/form_contact', to: 'static_pages#form_contact', as: 'form_contact'

  # Supers only
  authenticate :user, lambda { |u| u.is_super_user? } do
    namespace :admin do
      resources :questions do
        post :update_row_order, on: :collection
      end
      # engines
      mount Sidekiq::Web => '/sidekiq'
      mount Blazer::Engine, at: "blazer"
      # dashboards
      get '/' => redirect('admin/dashboard')
      resource :dashboard, controller: 'dashboard' do
      end

      # Stripe resources
      resources :plans
      resources :subscriptions
      resources :invoices
    end
  end

  # The User-facing App
  resources :feed_items, path: 'activities'
  resource :dashboard, controller: 'dashboard' do
    collection do
      get :activity_chart
      get :usage
    end
  end
  resources :lines
  resources :messages, only: [:index, :show]
  resources :call_logs
  resources :message_requests
  resources :contacts
  resources :imports
  resources :invoices
  resources :organizations do
    resources :billing_methods
    resources :subscriptions
    resources :users
    member do
      get :connect
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    invitations: 'users/invitations',
    passwords: 'users/passwords',
  }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Twilio Endpoints
  # match '/twilio/authorize' => 'twilio/authorizations#authorize', via: [:get]
  # match '/twilio/deauthorize' => 'twilio/authorizations#deauthorize', via: [:get]
  # match '/twilio/callbacks/status' => 'twilio/callbacks#status', via: [:post]

  namespace :twilio do
    resources :messages
    resources :voice_calls
    resources :callbacks do
      collection do
        post :status
      end
    end
    resources :authorizations
  end
end
