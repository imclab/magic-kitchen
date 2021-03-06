Magickitchen::Application.routes.draw do
  root :to => "home#index"
  
  devise_for :users, :path => "/registration",
                     :path_names  => {:sign_in => "signin", :sign_up => "join", :sign_out => "logout" },
                     :controllers => { :sessions => "sessions" } 
  
  get "/home" => "home#index"
  scope "/home" do
    resources :likes, :only => [:index, :show, :create, :destroy]
    resources :favorites, :only => [:index, :show, :create, :destroy]
    resources :history, :controller => :histories, :only => [:index, :show, :create]
    
    resources :followers, :only => [:index, :show]
    resources :following, :only => [:index, :show, :create, :destroy]
    
    resources :feeds, :only => [:index]
    resources :recs, :only => [:index]
  end
  
  get "/users" => "users#index", :as => :users_index
  resources :user, :controller => :users, :only => [:index, :show], do
    member do
      get :following, :followers, :feeds
    end
  end
  
  resources :recipes
  
  namespace :tags do
    namespace :recipes do
      get :ingredients
      get :tags
    end
  end
end