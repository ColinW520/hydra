Rails.application.routes.draw do
  root 'static_pages#home'
  match '/home' => "static_pages#home", via: [:get]
  match '/contact' => "static_pages#contact", via: [:get]
  match '/pricing' => "static_pages#pricing", via: [:get]

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }

  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :employees
  resources :organizations

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
