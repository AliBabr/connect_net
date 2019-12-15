# frozen_string_literal: true
Stripe.api_key = ENV["STRIPE_API_KEY"]

class StripePayment
  def initialize(customer, job)
    @user = user
    @porfessional = porfessional
  end

  def charge(price, fee)
    charge = Stripe::Charge.create({
      amount: price,
      currency: "usd",
      source: @user.stripe_card_token,
      application_fee_amount: fee,
    }, stripe_account: @porfessional.stripe_user_id)

    if charge.id.present?
      return plan
    else
      return nil
    end
  end
end
