# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_token_authenticatable User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :role, dependent: :destroy
  has_one :user_security_image, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :profile_photo
  

  private

  def after_successful_token_authentication
    # Make the authentication token to be disposable - for example
    renew_authentication_token!
  end

  # Function will return false if token doesn't mtch but return nil if user not found
  def self.validate_token(id, auth_token)
    user = find_by_id(id)
    user.authentication_token == auth_token if user.present?
  end

  protected

  def password_required?
    false
  end
end
