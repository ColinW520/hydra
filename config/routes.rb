Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'

  match '/home' => "static_pages#home", via: [:get]
  match '/contact' => "static_pages#contact", via: [:get]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
