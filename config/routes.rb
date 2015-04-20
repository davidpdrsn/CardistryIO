Rails.application.routes.draw do
  resources :moves, only: [:index, :show, :new, :create]
  get "all_moves", to: "moves#all_moves"

  root to: "welcome#index"
end
