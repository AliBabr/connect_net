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
      resources :videos do
        collection do
          put :add_viewer
        end
      end
      resources :musics do
        collection do
          put :add_viewer
        end
      end
      resources :articles do
        collection do
          put :add_viewer
        end
      end
      resources :posts
      resources :likes
      resources :home
      resources :search
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
          post :place_order
          put :confirm_completion
        end
      end
      resources :skills do
        collection do
          put :add_skill
          put :remove_skill
        end
      end
    end
  end

  root to: "home#index"
end
