# frozen_string_literal: true

class Api::V1::MusicsController < ApplicationController
    before_action :authenticate
    before_action :set_music, only: %i[destroy]

    def create
      music = Music.new(music_params)
      music.user = @user
      if music.save
        media_url = ''
        media_url = url_for(music.media) if music.media.attached?
        render json: { id: music.id, title: music.title, description: music.description, media: media_url }, status: 200
      else
        render json: music.errors.messages, status: 400
      end
    rescue StandardError => e
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    def index
      musics = Music.all; all_musics = []
      musics.each do |music|
        media_url = ''
        media_url = url_for(music.media) if music.media.attached?
        all_musics << { id: music.id, title: music.title, description: music.description, media: media_url }
      end
      render json: all_musics, status: 200
    rescue StandardError => e
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    def destroy
      @music.destroy
      render json: { message: 'music deleted successfully!' }, status: 200
    rescue StandardError => e # rescu if any exception occure
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    private
  
    def set_music # instance methode for music
      @music = Music.find_by_id(params[:id])
      if @music.present?
        return true
      else
        render json: { message: 'music Not found!' }, status: 404
      end
    end
  
    def music_params
      params.permit(:title, :description, :media)
    end
  end
  