# frozen_string_literal: true

class Api::V1::JobsController < ApplicationController
  before_action :authenticate
  before_action :set_job, only: %i[destroy]

  # methode that enable disable user notification status
  def create
    job = Job.new(job_params)
    job.user = @user; job.status = "pending"
    if params[:media].present?
      images = params[:media].values
      job.media = images
    end
    if job.save
      media = media_urls(job); image_url = ""
      image_url = url_for(@user.profile_photo) if @user.profile_photo.attached?
      render json: { first_name: @user.first_name, last_name: @user.last_name, profile_photo: image_url, job_id: job.id, title: job.title, description: job.description, media: media, posted_date: job.created_at }, status: 200
    else
      render json: job.errors.messages, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    jobs = Job.all; all_jobs = []
    jobs.each do |job|
      media = media_urls(job)
      image_url = ""
      image_url = url_for(job.user.profile_photo) if job.user.profile_photo.attached?
      all_jobs << { first_name: job.user.first_name, last_name: job.user.last_name, profile_photo: image_url, job_id: job.id, title: job.title, description: job.description, media: media, posted_date: job.created_at, total_proposal: job.applications.count }
    end
    render json: all_jobs, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy
    @job.destroy
    render json: { message: "job deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def apply
    if params[:job_id].present? && Job.find_by_id(params[:job_id].to_i)
      application = Application.new(application_params)
      application.user = @user; application.status = "pending"
      application.job = Job.find_by_id(params[:job_id].to_i)
      if application.save
        render json: { application_id: application.id, cover_description: application.cover_description, bid_price: application.bid_price, required_days: application.required_days }, status: 200
      else
        render json: application.errors.messages, status: 400
      end
    else
      render json: { message: "job id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_all_proposals
    if params[:job_id].present? && Job.find_by_id(params[:job_id].to_i)
      job = Job.find_by_id(params[:job_id].to_i)
      applications = get_proposals(job)
      render json: applications
    else
      render json: { message: "job id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def place_order
    if params[:job_id].present? && Job.find_by_id(params[:job_id]).present?
      if params[:application_id].present? && Application.find_by_id(params[:application_id]).present?
        order = Order.new(order_params)
        order.job = Job.find_by_id(params[:job_id]); order.application = Application.find(params[:application_id])
        Job.find_by_id(params[:job_id]).update(status: "active"); Application.find(params[:application_id]).update(status: "active")
        order.payment_status = "pending"
        if order.save
          render json: { message: "Order has been placed..." }, status: 200
        end
      else
        render json: { message: "Application id invalid or empty..!" }, status: 400
      end
    else
      render json: { message: "job id invalid or empty..!" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def confirm_completion
    if params[:job_id].present? && Job.find_by_id(params[:job_id]).present?
      if params[:payment_status].present? && params[:payment_status] == "done" || params[:payment_status] == "Done"
        job = Job.find_by_id(params[:job_id])
        job.order.update(payment_status: "done"); job.order.application.update(status: "complete"); job.update(status: "complete")
        render json: { message: "Thank you for your response...!" }
      else
        render json: { message: "Payment status is invalid empty..!" }, status: 400
      end
    else
      render json: { message: "job id invalid or empty..!" }, status: 400
    end
  end

  private

  def set_job # instance methode for job
    @job = Job.find_by_id(params[:id])
    if @job.present?
      return true
    else
      render json: { message: "job Not found!" }, status: 404
    end
  end

  def application_params
    params.permit(:cover_description, :bid_price, :required_days)
  end

  def job_params
    params.permit(:title, :description, :price, :deadline)
  end

  def order_params
    params.permit(:price, :completion_time)
  end

  def media_urls(job)
    media = []
    if job.media.attached?
      job.media.each do |photo|
        media << url_for(photo)
      end
    end
    media
  end

  def get_proposals(job)
    applications = job.applications
    all_applications = []
    applications.each do |application|
      image_url = ""
      image_url = url_for(application.user.profile_photo) if application.user.profile_photo.attached?
      all_applications << { first_name: application.user.first_name, last_name: application.user.last_name, profile_photo: image_url, application_id: application.id, cover_description: application.cover_description, bid_price: application.bid_price, required_days: application.required_days }
    end
    return all_applications
  end
end
