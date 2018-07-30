Rails.application.routes.draw do
  resources :vocab_books, format: false
  get 'vocabook/:show_id(/:id)' => 'vocab_books#show_vocabook'
  post 'vocabook/:status' => 'vocab_books#update_status'
  

  get 'home', to: 'homes#index'

  devise_for :users
  root 'tops#index'
  
  get 'tops/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
