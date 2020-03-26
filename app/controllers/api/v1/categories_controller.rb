# frozen_string_literal: true

class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate, only: %i[create, destroy]
  before_action :set_category, only: %i[destroy]
  before_action :is_admin, only: %i[create destroy]

  # methode that enable disable user notification status
  def create
    category = Category.create(category_params)
    if category.errors.any?
      render json: { errors: category.errors.messages }, status: 400
    else
      render json: { id: category.id, title: category.title }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    categories = Category.all
    render json: categories, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy
    @category.destroy
    render json: { message: "category deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def set_category # instance methode for category
    @category = Category.find_by_id(params[:id])
    if @category.present?
      return true
    else
      render json: { message: "category Not found!" }, status: 404
    end
  end

  def is_admin
    if @user.role.role_type == "admin"
      return true
    else
      render json: { message: "Only admin can create/update/destroy category!" }
    end
  end

  def category_params
    params.permit(:title)
  end
end
