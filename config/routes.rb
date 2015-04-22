Rails.application.routes.draw do
  resources :moves, only: [:index, :show, :new, :create, :destroy, :edit, :update]
  get "all_moves", to: "moves#all_moves"

  resources :users, only: [:show, :edit, :update]

  resources :videos, only: [:index, :show, :new, :create, :destroy, :edit, :update] do
    member do
      get "edit_appearances", to: "video_appearances#edit", as: "edit_appearances"
      patch "edit_appearances", to: "video_appearances#update", as: "update_appearances"
      delete "destroy_appearances", to: "video_appearances#destroy", as: "destroy_appearances"
    end
  end
  get "all_videos", to: "videos#all_videos"

  get "/admin/approve_videos", to: "admin/approve_videos#new", as: "approve_videos"
  post "/admin/approve_videos/:id", to: "admin/approve_videos#create", as: "approve_video"
  delete "/admin/approve_videos/:id", to: "admin/approve_videos#destroy", as: "disapprove_video"

  scope :api, module: :api do
    get "search/moves", to: "searches#moves"
  end

  root to: "welcome#index"
end
