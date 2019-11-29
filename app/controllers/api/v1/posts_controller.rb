# frozen_string_literal: true

class Api::V1::PostsController < ApplicationController
  before_action :authenticate
  before_action :set_post, only: %i[destroy]

  # methode that enable disable user notification status
  def create
    post = Post.new(post_params)
    post.user = @user
    if params[:media].present?
      images = params[:media].values
      post.media = images
    end
    if post.save
      media = media_urls(post)
      render json: { id: post.id, title: post.text, first_name: @user.first_name, last_name: @user.last_name, user_id: @user.id, media: media }, status: 200
    else
      render json: post.errors.messages, status: 400
    end
  rescue StandardError => e
    render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
  end

  def index
    posts = Post.all; all_posts = []
    posts.each do |post|
      media = media_urls(post)
      all_posts << { id: post.id, title: post.text, first_name: post.user.first_name, last_name: post.user.last_name, user_id: post.user.id, media: media }
    end
    render json: all_posts, status: 200
  rescue StandardError => e
    render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
  end

  def destroy
    @post.destroy
    render json: { message: 'post deleted successfully!' }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
  end

  private

  def set_post # instance methode for post
    @post = Post.find_by_id(params[:id])
    if @post.present?
      return true
    else
      render json: { message: 'post Not found!' }, status: 404
    end
  end

  def post_params
    params.permit(:text)
  end

  def media_urls(post)
    media = []
    if post.media.attached?
      post.media.each do |photo|
        media << url_for(photo)
      end
    end
    media
  end
end