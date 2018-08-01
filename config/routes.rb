Rails.application.routes.draw do
  get 'vocabook/show/:show_id(/:id)', to: 'vocabook#show'
  put 'vocabook/update/:status/:id', to: 'vocabook#update', as: 'vocabook'
  
  put 'vocabook_config/update/:filter', to: 'vocab_book_configs#update', as: 'vocabook_config'
  
  resources :vocab_books, format: false

  get 'home', to: 'homes#index'

  devise_for :users
  root 'tops#index'
  
  get 'tops/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
