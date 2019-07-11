Rails.application.routes.draw do

  post "follows/:at_user_id/create" => "follows#create"
  post "follows/:at_user_id/destroy" => "follows#destroy"

  post "likes/:post_id/create" => "likes#create"
  post "likes/:post_id/destroy" => "likes#destroy"

  get "posts/index" => "posts#index"
  post "posts/create" => "posts#create"
  get "posts/:id" => "posts#detailPost"
  get "posts/:id/edit" => "posts#editPost"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"
  get "posts/:id/follows" => "posts#follows"

  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "signup" => "users#new"
  get "users/index" => "users#index"
  get "users/:id" => "users#show"
  post "login" => "users#login"
  post "logout" => "users#logout"
  get "login" => "users#login_form"
  post "users/:id/destroy" => "users#destroy"
  get "users/:id/likes" => "users#likes"
  get "users/:id/follows" => "users#follows"
end
