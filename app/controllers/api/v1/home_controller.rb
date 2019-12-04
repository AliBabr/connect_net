# frozen_string_literal: true

class Api::V1::HomeController < ApplicationController
    before_action :authenticate
  
    def index
      home = []
      videos = get_videos
      music = get_music
      articles = get_articles
      events = get_events
      home << {events: events, videos: videos, music: music, articles: articles}
      render json: home, status: 200
    rescue StandardError => e
      render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
    end
  
    private

    def get_videos
      all_videos = []
      videos = Video.where("created_at > ?", 2.days.ago)
      views_videos = Video.all.order("total_viewers desc").limit(10)
      videos.each do |video|
        media_url = ''
        media_url = url_for(video.media) if video.media.attached?
        all_videos<< {id: video.id, title: video.title, description: video.description, media: media_url}
      end
      views_videos.each do |video|
        media_url = ''
        media_url = url_for(video.media) if video.media.attached?
        all_videos<< {id: video.id, title: video.title, description: video.description, media: media_url}
      end
      all_videos.uniq! {|e| e[:id] }
      return all_videos
    end
  
    def get_music
      all_music = []
      musics = Music.where("created_at > ?", 2.days.ago)
      views_music = Music.all.order("total_listioner desc").limit(10)
      musics.each do |music|
        media_url = ''
        media_url = url_for(music.media) if music.media.attached?
        all_music<< {id: music.id, title: music.title, description: music.description, media: media_url}
      end
      views_music.each do |music|
        media_url = ''
        media_url = url_for(music.media) if music.media.attached?
        all_music<< {id: music.id, title: music.title, description: music.description, media: media_url}
      end
      all_music.uniq! {|e| e[:id] }
      return all_music
    end

    def get_articles
      all_articles = []
      articles = Article.where("created_at > ?", 2.days.ago)
      views_articles = Article.all.order("total_viewers desc").limit(10)
      articles.each do |article|
        media_url = ''
        media_url = url_for(article.media) if article.media.attached?
        all_articles<< {id: article.id, title: article.title, description: article.description, media: media_url}
      end
      views_articles.each do |article|
        media_url = ''
        media_url = url_for(article.media) if article.media.attached?
        all_articles<< {id: article.id, title: article.title, description: article.description, media: media_url}
      end
      all_articles.uniq! {|e| e[:id] }
      return all_articles
    end

    def get_events
      all_events = []
      events = Event.where("event_date > ?", Time.now)
      events.each do |event|
        image_url = ''; media_image_url = ''
        image_url = url_for(event.user.profile_photo) if event.user.profile_photo.attached?
        media_image_url = url_for(event.image) if event.image.attached?
        all_events << { first_name: event.user.first_name, last_name: event.user.last_name, profile_photo: image_url, event_id: event.id, title: event.title, description: event.description, event_date: event.event_date, event_time: event.event_time, image: media_image_url, total_goings: event.goings.count }
      end
      return all_events
    end

  end
  