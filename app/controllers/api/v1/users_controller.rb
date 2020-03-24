# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :authenticate, only: %i[update_account update_password user_data log_out get_user get_twillio_token] # callback for validating user
  before_action :forgot_validation, only: [:forgot_password]
  before_action :before_reset, only: [:reset_password]
  before_action :set_user, only: %i[get_user get_ratings]

  # Method which accept credential from user and sign in and return user data with authentication token
  def sign_in
    if params[:email].blank?
      render json: { message: "Email can't be blank!" }
    else
      user = User.find_by_email(params[:email])
      if user.present? && user.valid_password?(params[:password])
        image_url = ""; category = ""
        category = user.role.category.title if user.role.category.present?
        image_url = url_for(user.profile_photo) if user.profile_photo.attached?
        render json: { email: user.email, first_name: user.first_name, last_name: user.last_name, city: user.city, country: user.country, latitude: user.latitude, longitude: user.longitude, profile_photo: image_url, role: user.role.role_type, category: category, "UUID" => user.id, "Authentication" => user.authentication_token }, status: 200
      else
        render json: { message: "No Email and Password matching that account were found" }, status: 400
      end
    end
  rescue StandardError => e # rescue if any exception occurr
    render json: { message: "Error: Something went wrong... " }, status: 400
  end

  def sign_in_with_social
    if params[:social_token].present? && params[:coming_from].present?
      user = User.find_by_social_token(params[:social_token])
      if user.present?
        image_url = ""; category = ""
        category = user.role.category.title if user.role.category.present?
        image_url = url_for(user.profile_photo) if user.profile_photo.attached?
        render json: { email: user.email, first_name: user.first_name, last_name: user.last_name, profile_photo: image_url, city: user.city, country: user.country, latitude: user.latitude, longitude: user.longitude, role: user.role.role_type, category: category, "UUID" => user.id, "Authentication" => user.authentication_token }, status: 200
      else
        render json: { message: "No socail token matching that account were found" }, status: 400
      end
    else
      render json: { message: "Social token and coming from can't be blank" }, status: 400
    end
  rescue StandardError => e # rescue if any exception occurr
    render json: { message: "Error: Something went wrong... #{e}" }, status: 400
  end

  def get_user
    image_url = ""; category = ""
    category = @param_user.role.category.title if @user.role.category.present?
    image_url = url_for(@user.profile_photo) if @user.profile_photo.attached?
    render json: { first_name: @user.first_name, last_name: @user.last_name, email: @user.email, profile_photo: image_url, role: @user.role.role_type, category: category, city: @user.city, country: @user.country, latitude: @user.latitude, longitude: @user.longitude }, status: 200
  rescue StandardError => e # rescue if any exception occurr
    render json: { message: "Error: Something went wrong... " }, status: 400
  end

  def get_ratings
    all_ratings = ""
    if @param_user.role.role_type == "professional"
      feedbacks = Feedback.where(professional_id: @param_user.id)
      avarage_rating = feedbacks.pluck(:professional_rating).sum.to_f / feedbacks.count.to_f
      feedbacks.each do |feedback|
        all_ratings << { feedback_id: feedback.id, review: feedback.professional_feedback, rating: professional_rating, job: feedback.job }
      end
    else
      feedbacks = Feedback.where(customer_id: @param_user.id)
      avarage_rating = feedbacks.pluck(:customer_rating).sum.to_f / feedbacks.count.to_f
      feedbacks.each do |feedback|
        all_ratings << { feedback_id: feedback.id, review: feedback.customer_feedback, rating: customer_rating, job: feedback.job }
      end
    end
    render json: {ratings: all_ratings, avarage_rating: avarage_rating}, status: 200
  rescue StandardError => e # rescue if any exception occurr
    render json: { message: "Error: Something went wrong... " }, status: 400
  end

  def sign_up_with_social
    if params[:coming_from].present? && params[:social_token].present?
      if params[:role].present?
        user = User.new(user_params); user.id = SecureRandom.uuid # genrating secure uuid token
        user.user_type = params[:role]
        if user.save
          if params[:security_images].present?
            set_security_images(user)
          end
          sign_up_helper(user)
        else
          render json: { errors: user.errors.messages }, status: 400
        end
      else
        render json: { message: "Role can't blank.." }, status: 400
      end
    else
      render json: { message: "Social Token & coming from can't blank.." }, status: 400
    end
  rescue StandardError => e # rescue if any exception occurr
    render json: { message: "Error: Something went wrong... #{e}" }, status: 400
  end

  # Method which accepts parameters from user and save data in db
  def sign_up
    if params[:password].present?
      if params[:role].present?
        user = User.new(user_params); user.id = SecureRandom.uuid;  # genrating secure uuid token
        user.user_type = params[:role]
        if user.save
          if params[:security_images].present?
            set_security_images(user)
          end
          sign_up_helper(user)
        else
          render json: { errors: user.errors.messages }, status: 400
        end
      else
        render json: { message: "Role & security should be present" }, status: 400
      end
    else
      render json: { message: "password can't be blank!" }, status: 400
    end
  rescue StandardError => e # rescue if any exception occurr
    render json: { message: "Error: Something went wrong... #{e}" }, status: 400
  end

  # Method that expire user session
  def log_out
    @user.update(authentication_token: nil)
    render json: { message: "Logged out successfuly!" }, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  # Method take parameters and update user account
  def update_account
    @user.update(user_params)
    if @user.errors.any?
      render json: { errors: @user.errors.messages }, status: 400
    else
      image_url = ""; category = ""
      category = @user.role.category.title if @user.role.category.present?
      image_url = url_for(@user.profile_photo) if @user.profile_photo.attached?
      render json: { first_name: @user.first_name, last_name: @user.last_name, email: @user.email, profile_photo: image_url, role: @user.role.role_type, category: category, city: @user.city, country: @user.country, latitude: @user.latitude, longitude: @user.longitude }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  # Method take current password and new password and update password
  def update_password
    if params[:current_password].present? && @user.valid_password?(params[:current_password])
      if params[:new_password].present?
        @user.update(password: params[:new_password])
        if @user.errors.any?
          render json: { errors: user.errors.messages }, status: 400
        else
          render json: { message: "Password updated successfully!" }, status: 200
        end
      else
        render json: { message: "password can't be blank!" }, status: 400
      end
    else
      render json: { message: "Current Password is not present or invalid!" }, status: 400
    end
  rescue StandardError => e # rescue if any exception occurr
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  # Method that render reset password form
  def reset
    @token = params[:tokens]
    @id = params[:id]
  end

  # Method that send email while user forgot password
  def forgot_password
    UserMailer.forgot_password(@user, @token).deliver
    @user.update(reset_token: @token)
    render json: { message: "Please check your Email for reset password!" }, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  # Method that take new password and confirm password and reset user password
  def reset_password
    if (params[:token] === @user.reset_token) && (@user.updated_at > DateTime.now - 1)
      @user.update(password: params[:password], password_confirmation: params[:confirm_password], reset_token: "")
      render "reset" if @user.errors.any?
    else
      @error = "Token is expired"; render "reset"
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_twillio_token
    if @user.twillio_token.present?
      render json: { identity: @user.email, token: @user.twillio_token }, status: 200
    else
      identity = @user.email
      grant = Twilio::JWT::AccessToken::ChatGrant.new
      grant.service_sid = ENV["TWILIO_CHAT_SERVICE_SID"]
      token = Twilio::JWT::AccessToken.new(
        ENV["TWILIO_ACCOUNT_SID"],
        ENV["TWILIO_API_KEY"],
        ENV["TWILIO_API_SECRET"],
        [grant],
        identity: identity,
      )
      if token.present?
        @user.update(twillio_token: token.to_jwt)
        render json: { identity: identity, token: token.to_jwt }, status: 200
      else
        render json: { message: "something went wrong" }, status: 401
      end
    end
  end

  private

  def user_params # permit user params
    params.permit(:email, :password, :first_name, :last_name, :profile_photo, :city, :latitude, :longitude, :coming_from, :social_token, :country)
  end

  # Helper method for forgot password method
  def forgot_validation
    if params[:email].blank?
      render json: { message: "Email can't be blank!" }, status: 400
    else
      @user = User.where(email: params[:email]).first
      if @user.present?
        o = [("a".."z"), ("A".."Z")].map(&:to_a).flatten; @token = (0...15).map { o[rand(o.length)] }.join
      else
        render json: { message: "Invalid Email!" }, status: 400
      end
    end
  end

  # Helper method for reset password method
  def before_reset
    @id = params[:id]; @token = params[:token]; @user = User.find_by_id(params[:id])
    if params[:password] == params[:confirm_password]
      return true
    else
      @error = "Password and confirm password should match"
      render "reset"
    end
  end

  def sign_up_helper(user)
    role = Role.new(role_type: params[:role], user_id: user.id)
    if params[:role] == "professional"
      if params[:category_id].present? && Category.find_by_id(params[:category_id].to_i).present?
        role.category = Category.find_by_id(params[:category_id].to_i)
      end
    end
    role.save
    if user.role.category.present?
      category = user.role.category.title
    else
      category = ""
    end
    security_images = security_images_urls(user); image_url = ""
    image_url = url_for(user.profile_photo) if user.profile_photo.attached?
    render json: { email: user.email, first_name: user.first_name, last_name: user.last_name, profile_photo: image_url, role: user.role.role_type, category: category, city: user.city, country: user.country, latitude: user.latitude, longitude: user.longitude, security_images: security_images, "UUID" => user.id, "Authentication" => user.authentication_token }, status: 200
  end

  def set_security_images(user)
    security_images = UserSecurityImage.new()
    images = params[:security_images].values
    security_images.images = images
    security_images.user = user
    security_images.save
  end

  def security_images_urls(user)
    images = []
    if user.user_security_image.present?
      if user.user_security_image.images.attached?
        user.user_security_image.images.each do |photo|
          images << url_for(photo)
        end
      end
    end
    images
  end

  def set_user # instance methode for job
    @param_user = User.find_by_id(params[:user_id])
    if @param_user.present?
      return true
    else
      render json: { message: "User Not found!" }, status: 404
    end
  end
end
