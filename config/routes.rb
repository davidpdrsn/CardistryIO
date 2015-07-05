Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, only: [:show, :edit, :update, :create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]

    member do
      post :make_admin
    end
  end

  get "/sign_in", to: "clearance/sessions#new", as: "sign_in"
  delete "/sign_out", to: "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up", to: "clearance/users#new", as: "sign_up"

  resources :moves, only: [:index, :show, :new, :create, :destroy, :edit, :update] do
    resources :comments, only: [:create]
  end
  get "all_moves", to: "moves#all_moves"

  resources :videos do
    resources :comments, only: [:create]
    resources :sharings, only: [:new, :create, :destroy] do
      collection do
        get "edit", to: "sharings#edit", as: "edit"
      end
    end

    member do
      get "edit_appearances", to: "video_appearances#edit", as: "edit_appearances"
      patch "edit_appearances", to: "video_appearances#update", as: "update_appearances"
      delete "destroy_appearances", to: "video_appearances#destroy", as: "destroy_appearances"
    end
  end
  get "all_videos", to: "videos#all_videos"
  get "videos_shared_with_you", to: "sharings#index", as: "shared_videos"

  get "/admin/approve_videos", to: "admin/approve_videos#new", as: "approve_videos"
  post "/admin/approve_videos/:id", to: "admin/approve_videos#create", as: "approve_video"
  delete "/admin/approve_videos/:id", to: "admin/approve_videos#destroy", as: "disapprove_video"

  scope :api, module: :api do
    get "search/moves", to: "searches#moves"
    post "videos/:id/approve", to: "videos#approve"
    get "videos/unapproved", to: "videos#unapproved"
    delete "videos/:id", to: "videos#destroy"
  end

  get "instagram", to: "instagram#index"
  get "instagram/oauth/callback", to: "instagram#callback"

  root to: "welcome#index"
end
