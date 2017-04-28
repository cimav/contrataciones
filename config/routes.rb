Rails.application.routes.draw do
  root 'candidates#index'
  post 'candidates/:id/send_response' => 'candidates#send_response'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get 'logout' => 'sessions#destroy'
  get '/login' => 'login#index'
  resources 'candidates'
  resources 'users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
