Rails.application.routes.draw do
  resource :dashboard

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, only: [:show, :edit, :update, :create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]

    member do
      post :make_admin
      post :follow, to: "relationships#create"
      delete :follow, to: "relationships#destroy"
      get :following, to: "relationships#following"
      get :followers, to: "relationships#followers"
    end
  end

  resources :notifications, only: [:index] do
    collection do
      post :mark_all_read
    end
  end

  get "/sign_in", to: "clearance/sessions#new", as: "sign_in"
  delete "/sign_out", to: "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up", to: "clearance/users#new", as: "sign_up"

  concern :comments do
    resources :comments, only: [:create, :edit, :update]
  end

  concern :ratings do
    resources :ratings, only: [:create]
  end

  resources :creditable_users, only: [:index]

  resources(
    :moves,
    only: [:index, :show, :new, :create, :destroy, :edit, :update],
    concerns: [:comments, :ratings]) do
      collection do
        get "all"
      end
    end

  resources :videos, concerns: [:comments, :ratings] do
    resources :sharings, only: [:new, :create, :destroy] do
      collection do
        get "edit", to: "sharings#edit", as: "edit"
      end
    end

    collection do
      get "all"
    end

    member do
      get "edit_appearances", to: "video_appearances#edit", as: "edit_appearances"
      patch "edit_appearances", to: "video_appearances#update", as: "update_appearances"
      delete "destroy_appearances", to: "video_appearances#destroy", as: "destroy_appearances"
    end
  end
  get "videos_shared_with_you", to: "sharings#index", as: "shared_videos"

  get "/admin/approve_videos", to: "admin/approve_videos#new", as: "approve_videos"
  post "/admin/approve_videos/:id", to: "admin/approve_videos#create", as: "approve_video"
  delete "/admin/approve_videos/:id", to: "admin/approve_videos#destroy", as: "disapprove_video"

  scope :api, module: :api do
    get "search/moves", to: "searches#moves"
    get "search/users", to: "searches#users"

    post "videos/:id/approve", to: "videos#approve"
    get "videos/unapproved", to: "videos#unapproved"
    delete "videos/:id", to: "videos#destroy"
  end

  get "instagram", to: "instagram#index"
  get "instagram/oauth/callback", to: "instagram#callback"

  get "monitor", to: "monitor#services"
  get "monitor_stats", to: "monitor#stats"
  get "/search", as: "searches", to: "searches#show"

  root to: "welcome#index"

  post "/beta_signin", to: "welcome#beta_signin", as: :beta_signin
end
