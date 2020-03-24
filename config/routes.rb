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
          get :get_twillio_token
          get :get_ratings
        end
        member do
          get :reset
        end
      end
      resources :categories
      resources :feedbacks do
        collection do
          post :customer_feedback
          post :professional_feedback
        end
      end
      resources :abouts do
        collection do
          put :update_about
          get :get_about
        end
      end
      resources :videos do
        collection do
          put :add_viewer
        end
      end
      resources :payment do
        collection do
          put :save_card_token
          put :save_stripe_connect_user
          put :process_paymnt
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
      resources :search do
        collection do
          get :search_by_user_id
          get :all_users
        end
      end
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
          put :deliver_order
          get :get_order
          get :professional_jobs
          get :posted_jobs
          get :filter_job
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
