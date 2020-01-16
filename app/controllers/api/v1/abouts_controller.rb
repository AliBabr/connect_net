# frozen_string_literal: true

class Api::V1::AboutsController < ApplicationController
  before_action :authenticate
  before_action :is_admin, only: %i[create update_about]

  # methode that enable disable user notification status
  def create
    if params[:text].present?
      about = About.new(text: params[:text])
      if about.save
        render json: { about: about.text }, status: 200
      else
        render json: { errors: about.errors.messages }, status: 400
      end
    else
      render json: { message: "text can't be blank...!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def update_about
    if params[:text].present?
      about = About.first.update(text: params[:text])
      if about.errors.any?
        render json: { errors: about.errors.messages }, status: 400
      else
        render json: { about: about.text }, status: 200
      end
    else
      render json: { message: "text can't be blank...!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_about
    about = About.first
    render json: { about: about.text }
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def is_admin
    if @user.role.role_type == "admin"
      return true
    else
      render json: { message: "Only admin can create about..!" }
    end
  end
end
