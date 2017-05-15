Rails.application.routes.draw do
  get 'login/index'
  get 'levels/:id' =>'candidates#levels'
  get 'home/index'

  root 'candidates#index'
  post 'candidates/:id/send_response' => 'candidates#send_response'
  patch 'candidates/:id/desagree' => 'candidates#desagree'
  get 'pendientes' => 'candidates#candidates_waiting'
  get 'finalizados' => 'candidates#candidates_finalized'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get 'logout' => 'sessions#destroy'
  get '/login' => 'login#index'
  resources 'candidates'
  resources 'users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
