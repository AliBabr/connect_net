# frozen_string_literal: true

class Api::V1::ArticlesController < ApplicationController
    before_action :authenticate
    before_action :set_article, only: %i[destroy]

    def create
      article = Article.new(article_params)
      article.user = @user
      if article.save
        media_url = ''
        media_url = url_for(article.media) if article.media.attached?
        render json: { id: article.id, title: article.title, description: article.description, media: media_url }, status: 200
      else
        render json: article.errors.messages, status: 400
      end
    rescue StandardError => e
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    def index
      articles = Article.all; all_articles = []
      articles.each do |article|
        media_url = ''
        media_url = url_for(article.media) if article.media.attached?
        all_articles << { id: article.id, title: article.title, description: article.description, media: media_url }
      end
      render json: all_articles, status: 200
    rescue StandardError => e
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    def destroy
      @article.destroy
      render json: { message: 'article deleted successfully!' }, status: 200
    rescue StandardError => e # rescu if any exception occure
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    private
  
    def set_article # instance methode for article
      @article = Article.find_by_id(params[:id])
      if @article.present?
        return true
      else
        render json: { message: 'article Not found!' }, status: 404
      end
    end
  
    def article_params
      params.permit(:title, :description, :media)
    end
  end
  