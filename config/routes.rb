# frozen_string_literal: true

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
      resources :categories
      resources :posts
      resources :likes
      resources :comments do
        collection do
          put :edit_comment
        end
      end
      resources :events do
        collection do
          put :set_going
        end
      end
      resources :jobs do
        collection do
          post :apply
          get :get_all_proposals
        end
      end

    end
  end

  root to: 'home#index'
end
