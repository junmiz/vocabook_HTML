Rails.application.routes.draw do
  get 'problems/start/:typ', to: 'problems#start', as: 'problems_start'
  get 'problems/show/:typ/:id', to: 'problems#show', as: 'problems'
  get 'problems/answer/:typ/:prob_id/:ans_id', to: 'problems#answer', as: 'problems_answer'
  get 'problems/result/:typ', to: 'problems#result', as: 'problems_result'
  
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
