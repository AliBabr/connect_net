# frozen_string_literal: true

class Api::V1::SearchController < ApplicationController
  before_action :authenticate

  def index
    if params[:skill].present?
      users = skill_search(users)
    else
      users = User.where(user_type: "professional")
    end

    if params[:latitude].present? && params[:longitude].present? && params[:radius]
      latitude = params[:latitude]; longitude = params[:longitude]; radius = 100
      all_users = User.near([latitude, longitude], radius, units: :km)
      users = all_users.where(user_type: "professional")
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

    if params[:field].present?
      users = field_search(users)
    end

    result = []
    users.each do |user|
      image_url = ""
      image_url = url_for(user.profile_photo) if user.profile_photo.attached?
      rating = get_rating(user)
      result << { user_id: user.id, first_name: user.first_name, last_name: user.last_name, latitude: user.latitude, longitude: user.longitude, city: user.city, country: user.country, profile_photo: image_url, total_projects: user.applications.where(status: "complete").count, rating: rating }
    end
    render json: result, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def search_by_user_id
    result = []
    if params[:user_id].present? && User.find_by_id(params[:user_id]).present?
      user = User.find_by_id(params[:user_id])
      rating = get_rating(user)
      image_url = ""
      image_url = url_for(user.profile_photo) if user.profile_photo.attached?
      active_orders = user.applications.where(status: "active").count
      complete_orders = user.applications.where(status: "complete").count
      reviews = get_reviews(user)
      projects = get_projects(user)
      skills = get_skills(user)
      result << { user_id: user.id, first_name: user.first_name, last_name: user.last_name, latitude: user.latitude, longitude: user.longitude, city: user.city, country: user.country, profile_photo: image_url, rating: rating, skills: skills, active_orders: active_orders, complete_orders: complete_orders, reviews: reviews, projects: projects }
      render json: result, status: 200
    else
      render json: { message: "User id invalid or empty..!" }, status: 400
    end
  end

  def all_users
    users = User.where(user_type: "professional")
    result = []
    users.each do |user|
      image_url = ""
      image_url = url_for(user.profile_photo) if user.profile_photo.attached?
      rating = get_rating(user)
      result << { user_id: user.id, first_name: user.first_name, last_name: user.last_name, latitude: user.latitude, longitude: user.longitude, city: user.city, country: user.country, profile_photo: image_url, total_projects: user.applications.where(status: "complete").count, rating: rating }
    end
    render json: result, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def city_search(users)
    return users.city_search(params[:city]).uniq
  end

  def country_search(users)
    return users.country_search(params[:country]).uniq
  end

  def skill_search(users)
    skill_users = User.where(user_type: "professional")
    skill = Skill.search(params[:skill])
    if skill.present?
      skill.each do |s|
        skill_users = s.users
      end
    end

    return skill_users
  end

  def field_search(users)
    field = Category.search(params[:field])
    field = field.uniq
    field_users = []
    search_users = []
    if field.present?
      field.each do |f|
        roles = f.roles
        roles.each do |role|
          field_users << role.user
        end
      end
      field_users.each do |user|
        u = users.find_by_id(user.id)
        if u.present?
          search_users << u
        end
      end
    end

    return search_users
  end

  def get_rating(user)
    feedbacks = Feedback.where(professional_id: user.id)
    ratings = feedbacks.pluck(:professional_rating)
    averrage_rating = ratings.inject { |sum, el| sum + el }.to_f / ratings.size
    return averrage_rating
  end

  def get_reviews(user)
    reviews = []
    feedbacks = Feedback.where(professional_id: user.id)
    if feedbacks.present?
      feedbacks.each do |feedback|
        cutomer = User.find_by_id(feedback.customer_id)
        image_url = ""
        image_url = url_for(cutomer.profile_photo) if cutomer.profile_photo.attached?
        reviews << { profile_photo: image_url, first_name: cutomer.first_name, last_name: cutomer.last_name, review: feedback.professional_feedback, rating: feedback.professional_rating, date: feedback.created_at }
      end
    end
    return reviews
  end

  def get_projects(user)
    all_projects = []
    applications = user.applications.where(status: "complete")
    if applications.present?
      applications.each do |application|
        order = application.order
        source = get_source_urls(order)
        all_projects << { project_name: order.name, source_urls: source }
      end
    end
    return all_projects
  end

  def get_source_urls(order)
    sources = []
    if order.order_source_files.attached?
      order.order_source_files.each do |source|
        sources << url_for(source)
      end
    end
    return sources
  end

  def get_skills(user)
    all_skills = []
    skills = user.skills
    if skills.present?
      skills.each do |skill|
        all_skills << { skill_name: skill.text }
      end
    end
    return all_skills
  end
end
