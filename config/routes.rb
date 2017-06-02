Rails.application.routes.draw do
  post 'departments/create' => 'departments#create'

  get 'login/index'
  get 'home/index'
  get 'candidates/:id/documento' => 'candidates#document'


  root 'candidates#index'
  post 'candidates/:id/send_response' => 'candidates#send_response'
  patch 'candidates/:id/desagree' => 'candidates#desagree'
  post 'candidates/:id/close_votation' => 'candidates#close_votation'
  get 'pendientes' => 'candidates#candidates_waiting'
  get 'finalizados' => 'candidates#candidates_finalized'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get 'logout' => 'sessions#destroy'
  get '/login' => 'login#index'
  resources 'candidates'
  resources 'users'
  post 'candidates/:id/curriculum' => 'candidates#display_curriculum'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
