# frozen_string_literal: true

class Api::V1::VideosController < ApplicationController
    before_action :authenticate
    before_action :set_video, only: %i[destroy]

    def create
      video = Video.new(video_params)
      video.user = @user
      if video.save
        media_url = ''
        media_url = url_for(video.media) if video.media.attached?
        render json: { id: video.id, title: video.title, description: video.description, media: media_url }, status: 200
      else
        render json: video.errors.messages, status: 400
      end
    rescue StandardError => e
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    def index
      videos = Video.all; all_videos = []
      videos.each do |video|
        media_url = ''
        media_url = url_for(video.media) if video.media.attached?
        all_videos << { id: video.id, title: video.title, description: video.description, media: media_url }
      end
      render json: all_videos, status: 200
    rescue StandardError => e
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    def destroy
      @video.destroy
      render json: { message: 'video deleted successfully!' }, status: 200
    rescue StandardError => e # rescu if any exception occure
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    private
  
    def set_video # instance methode for video
      @video = Video.find_by_id(params[:id])
      if @video.present?
        return true
      else
        render json: { message: 'video Not found!' }, status: 404
      end
    end
  
    def video_params
      params.permit(:title, :description, :media)
    end
  end
  