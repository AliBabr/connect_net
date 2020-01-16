# frozen_string_literal: true

class Api::V1::CommentsController < ApplicationController
  before_action :authenticate
  before_action :set_comment, only: %i[destroy]

  # methode that enable disable user notification status
  def create
    if params[:post_id].present? && Post.find_by_id(params[:post_id].to_i)
      comment = Comment.new(comment_params)
      comment.user = @user
      comment.post = Post.find_by_id(params[:post_id].to_i)
      if comment.save
        render json: { comment_id: comment.id, text: comment.text }, status: 200
      else
        render json: { errors: comment.errors.messages }, status: 400
      end
    else
      render json: { message: "Post id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def edit_comment
    if params[:comment_id].present? && Comment.find_by_id(params[:comment_id].to_i)
      comment = Comment.find_by_id(params[:comment_id].to_i)
      comment.update(comment_params)
      if comment.errors.any?
        render json: { errors: comment.errors.messages }, status: 400
      else
        render json: { comment_id: comment.id, text: comment.text }, status: 200
      end
    else
      render json: { message: "Comment id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy
    @comment.destroy
    render json: { message: "comment deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def set_comment # instance methode for post
    @comment = Comment.find_by_id(params[:id])
    if @comment.present?
      return true
    else
      render json: { message: "post Not found!" }, status: 404
    end
  end

  def comment_params
    params.permit(:text)
  end
end
