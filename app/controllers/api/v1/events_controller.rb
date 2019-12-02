# frozen_string_literal: true

class Api::V1::EventsController < ApplicationController
  before_action :authenticate
  before_action :set_event, only: %i[destroy]

  # methode that enable disable user notification status
  def create
    event = Event.new(event_params)
    event.user = @user
    if event.save
      image_url = ''; media_image_url = ''
      image_url = url_for(@user.profile_photo) if @user.profile_photo.attached?
      media_image_url = url_for(event.image) if event.image.attached?
      render json: { first_name: @user.first_name, last_name: @user.last_name, profile_photo: image_url, event_id: event.id, title: event.title, description: event.description, event_date: event.event_date, event_time: event.event_time, image: media_image_url }, status: 200
    else
      render json: event.errors.messages, status: 400
    end
  rescue StandardError => e
    render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
  end

  def index
    events = Event.all; all_events = []
    events.each do |event|
      image_url = ''; media_image_url = ''
      image_url = url_for(event.user.profile_photo) if event.user.profile_photo.attached?
      media_image_url = url_for(event.image) if event.image.attached?
      all_events << { first_name: event.user.first_name, last_name: event.user.last_name, profile_photo: image_url, event_id: event.id, title: event.title, description: event.description, event_date: event.event_date, event_time: event.event_time, image: media_image_url, total_goings: event.goings.count }
    end
    render json: all_events, status: 200
  rescue StandardError => e
    render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
  end

  def destroy
    @event.destroy
    render json: { message: 'event deleted successfully!' }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
  end

  def set_going
    if params[:event_id].present? && Event.find_by_id(params[:event_id].to_i)
      going = Going.new(event_id: params[:event_id].to_i, user_id: @user.id)
      if going.save
        render json: {message: "Going Added successfully..!"}, status: 200
      else
        render json: going.errors.messages, status: 400
      end
    else
      render json: {message: "event id invalid or empty..!"}, status: 400
    end
  rescue StandardError => e
    render json: { message: 'Error: Something went wrong... ' }, status: :bad_request
  end
  private

  def set_event # instance methode for event
    @event = Event.find_by_id(params[:id])
    if @event.present?
      return true
    else
      render json: { message: 'event Not found!' }, status: 404
    end
  end

  def event_params
    params.permit(:title, :description, :event_date, :event_time, :image)
  end
end
