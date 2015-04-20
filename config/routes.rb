Rails.application.routes.draw do
  resources :moves, only: [:index, :show, :new, :create]
  get "all_moves", to: "moves#all_moves"

  resources :users, only: [:show, :edit, :update]

  resources :videos, only: [:index, :show, :new, :create] do
    member do
      get "edit_appearances", to: "video_appearances#edit", as: "edit_appearances"
      patch "edit_appearances", to: "video_appearances#update", as: "update_appearances"
    end
  end
  get "all_videos", to: "videos#all_videos"

  root to: "welcome#index"
end
