# frozen_string_literal: true

class Api::V1::SkillsController < ApplicationController
  before_action :authenticate
  before_action :set_skill, only: %i[destroy]
  before_action :is_admin, only: %i[create index destroy]

  # methode that enable disable user notification status
  def create
    skill = Skill.create(skill_params)
    if skill.errors.any?
      render json: skill.errors.messages, status: 400
    else
      render json: { id: skill.id, text: skill.text }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    skills = Skill.all
    render json: skills, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy
    @skill.destroy
    render json: { message: "skill deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def add_skill
    if params[:skills].present?
      skills = params[:skills].values
      skills.each do |skill|
        if Skill.find_by_id(skill.to_i).present?
          @user.skills << Skill.find_by_id(skill.to_i)
          @user.save
        end
      end
      render json: { message: "Skills has been added successfully..!" }
    else
      render json: { message: "skill id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def remove_skill
    if params[:id].present? && Skill.find_by_id(params[:id]).present?
      skill = Skill.find_by_id(params[:id])
      @user.skills.delete(skill)
      render json: { message: "Skill has been removed successfully..!" }
    else
      render json: { message: "skill id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def set_skill # instance methode for skill
    @skill = Skill.find_by_id(params[:id])
    if @skill.present?
      return true
    else
      render json: { message: "skill Not found!" }, status: 404
    end
  end

  def is_admin
    if @user.role.role_type == "admin"
      return true
    else
      render json: { message: "Only admin can create/update/destroy skill!" }
    end
  end

  def skill_params
    params.permit(:text)
  end
end
