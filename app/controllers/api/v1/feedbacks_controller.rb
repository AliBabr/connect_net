# frozen_string_literal: true

class Api::V1::FeedbacksController < ApplicationController
  before_action :authenticate
  before_action :is_professional, only: %i[customer_feedback]
  before_action :is_customer, only: %i[professional_feedback]

  # methode that enable disable user notification status
  def customer_feedback
    if params[:job_id].present? && Job.find_by_id(params[:job_id]).present?
      job = Job.find_by_id(params[:job_id])
      if job.status == "compelete"
        customer = job.user
        professional = job.order.application.user
        if job.feedback.present?
          job.feedback.update(professional_id: professional, customer_id: customer.id, customer_feedback: params[:feedback], customer_rating: params[:rating])
          render json: { message: "Your feedback has been saved" }
        else
          feedback = Feedback.new(professional_id: professional, customer_id: customer.id, customer_feedback: params[:feedback], customer_rating: params[:rating])
          feedback.job = job
          feedback.save
          render json: { message: "Your feedback has been saved" }
        end
      else
        render json: { message: "Job should be compelete!" }, status: 400
      end
    else
      render json: { message: "job id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def professional_feedback
    if params[:job_id].present? && Job.find_by_id(params[:job_id]).present?
      job = Job.find_by_id(params[:job_id])
      if job.status == "compelete"
        customer = job.user
        professional = job.order.application.user
        if job.feedback.present?
          job.feedback.update(professional_id: professional, customer_id: customer.id, professional_feedback: params[:feedback], professional_rating: params[:rating])
          render json: { message: "Your feedback has been saved" }
        else
          feedback = Feedback.new(professional_id: professional, customer_id: customer.id, professional_feedback: params[:feedback], professional_rating: params[:rating])
          feedback.job = job
          feedback.save
          render json: { message: "Your feedback has been saved" }
        end
      else
        render json: { message: "Job should be compelete!" }, status: 400
      end
    else
      render json: { message: "job id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def is_customer
    if @user.role.role_type == "customer"
      return true
    else
      render json: { message: "Only customer can give feedback to professional..!" }
    end
  end

  def is_professional
    if @user.role.role_type == "professional"
      return true
    else
      render json: { message: "Only professional can give feedback to customer..!" }
    end
  end
end
