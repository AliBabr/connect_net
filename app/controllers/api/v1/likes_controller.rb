# frozen_string_literal: true

class Api::V1::LikesController < ApplicationController
  before_action :authenticate

  # methode that enable disable user notification status
  def create
    if params[:post_id].present? && Post.find_by_id(params[:post_id].to_i)
      like = Like.new(post_id: params[:post_id].to_i, user_id: @user.id)
      if like.save
        render json: { message: "Post has been liked successfully..!" }, status: 200
      else
        render json: { errors: like.errors.messages }, status: 400
      end
    else
      render json: { message: "Post id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end
end
