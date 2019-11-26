Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post :sign_in
          post :sign_in_with_social
          post :sign_up
          post :sign_up_with_social
          post :log_out
          post :update_password
          post :update_account
          post :forgot_password
          post :reset_password
          get :get_user
        end
        member do
          get :reset
        end
      end
      post '/notifications/toggle_notification', to: 'notifications#toggle_notification'
      resources :categories
      resources :history, only: [:create, :index]
      end
    end

  root to: "home#index"

end
