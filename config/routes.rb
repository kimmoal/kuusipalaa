Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: "registrations", omniauth_callbacks: 'omniauth_callbacks' } do
    get "logout", to: "devise/sessions#destroy"
  end

  namespace :admin do
    root to: 'base#home'
    resources :posts
    resources :pages
    resources :meetings
    resources :seasons
    resources :stakes
  end

  resources :comments do
    resources :comments
  end

  resources :groups do
    resources :members do
      member do
        get :leave
        post :remove
      end
    end
  end

  resources :meetings do
    resources :comments
    member do
      post :rsvp
      post :cancel_rsvp
    end
    resources :users do
      resources :notifications
    end
  end


  resources :members do
    get :autocomplete_user_username, on: :collection
  end


  resources :pages

  resources :posts do
    resources :comments
    resources :users do
      resources :notifications
    end
  end

  resources :seasons do
    resources :stakes do
      collection do
        get :for_self
        get :for_group
      end
    end
  end

  resources :users do
    collection do
      get :check_unique
      get :mentions
      get :members_agreement
    end
    member do
      get :get_membership_details
    end
  end

  match '/users/auth/:provider/callback' => 'authentications#create', :via => :get
  delete '/users/signout' => 'devise/sessions#destroy', :as => :signout
  root to: 'home#index'
end
