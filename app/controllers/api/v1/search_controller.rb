# frozen_string_literal: true

class Api::V1::SearchController < ApplicationController
  before_action :authenticate

  def index
    users = User.all
    if params[:latitude].present? && params[:longitude].present? && params[:radius]
      latitude = params[:latitude]; longitude = params[:longitude]; radius = params[:radius]
      users = User.near([latitude, longitude], radius, units: :km)
      while users.length > 100
        radius = radius.to_i / 2
        users = User.near([latitude, longitude], radius, units: :km)
      end
    end

    if params[:city].present?
      users = city_search(users)
    end
    if params[:country].present?
      users = country_search(users)
    end
    # if params[:field].present?
    #   users = field_search(users)
    # end
    if params[:skill].present?
      users = skill_search(users)
    end
    render json: users, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def city_search(users)
    return users.where(city: params[:city])
  end

  def country_search(users)
    return users.where(country: params[:country])
  end

  def skill_search(users)
    return Skill.where(text: params[:text]).first.users
  end

  def city_search(users)
    return users.where(city: params[:city])
  end
end
