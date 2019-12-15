# frozen_string_literal: true

class Api::V1::PaymentController < ApplicationController
  before_action :authenticate
  before_action :is_customer, only: %i[save_card_token process_paymnt]
  before_action :is_professional, only: %i[save_stripe_connect_user]

  def save_card_token
    if params[:card_token].present?
      @user.update(stripe_card_token: params[:card_token])
      if @user.errors.any?
        render json: @user.errors.messages, status: 400
      else
        render json: { message: "Card token has been saved successfully..!" }, status: 200
      end
    else
      render json: { message: "Stripe card token can't be blank..!" }, status: 401
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def save_stripe_connect_user
    if params[:stripe_user_id].present?
      @user.update(stripe_user_id: params[:stripe_user_id])
      if @user.errors.any?
        render json: @user.errors.messages, status: 400
      else
        render json: { message: "Stripe user has been saved successfully..!" }, status: 200
      end
    else
      render json: { message: "Stripe user id can't be blank..!" }, status: 401
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def process_paymnt
    if params[:job_id].present? && Job.find_by_id(params[:job_id]).present?
      job = Job.find_by_id(params[:job_id])
      professional = job.order.application.user
      price = job.order.price
      fee = calculate_fee(price)
      response = StripePayment.new(@user, professional).charge(price.to_i, fee)
      if response.present?
        render json: { message: "Payment has been successfully processed..!" }, status: 200
      else
        render json: { message: "Something went wrong with your account please check..." }, status: 401
      end
    else
      render json: { message: "job id is invalid or empty..!" }, status: 400
    end
  end

  private

  def is_customer
    if @user.role.role_type == "customer"
      return true
    else
      render json: { message: "Only customer should have stripe card token..!" }
    end
  end

  def is_professional
    if @user.role.role_type == "professional"
      return true
    else
      render json: { message: "Only professional should have stripe connect user id..!" }
    end
  end

  def calculate_fee(price)
    price = price
    fee = (15.to_f / 100.to_f) * price.to_f
    return fee
  end
end
