class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :display_name,
                  :email,
                  :full_name,
                  :password,
                  :password_confirmation,
                  :store_id,
                  :store_name,
                  :stripe_token,
                  :card_number,
                  :card_code,
                  :card_month,
                  :card_year

  attr_accessor :store_name, :stripe_token, :card_number, :card_code, :card_month, :card_year

  before_save :generate_token, if: :card_number_exists?
  before_save :update_stripe, if: :stripe_token_exists?

  validates_uniqueness_of :email
  validates_presence_of :full_name, :email, :password
  validates :display_name, :length => { :minimum => 2,
    :maximum => 32 }, :allow_blank => true

  has_many :user_store_roles
  has_many :stores, :through => :user_store_roles
  has_many :bids


  def assign_super_admin
    self.super_admin = true
    self.save
  end

  def is_super_admin?
    self.super_admin
  end

  def valid_credit_card?
    self.last_4_digits.present?
  end

  def assign_role(store_id, role)
    UserStoreRole.find_or_initialize_by_user_id_and_store_id(user_id: self.id,
                                                             store_id: store_id).update_attributes(role: role)
  end

  def stripe_description
    "#{full_name} #{email}"
  end

  def generate_token
    card_token = Stripe::Token.create(
      :card => {
      :number => card_number,
      :exp_month => card_month.to_i,
      :exp_year => card_year.to_i,
      :cvc => card_code.to_i
    },
    )
    self.stripe_token = card_token.id

  rescue Stripe::StripeError => e
    logger.error "StripeError: " + e.message
    errors.add :base, "#{e.message}."
    false
  end

  def update_stripe
    if customer_id.nil?
      if !stripe_token.present?
        raise "An unexpected error occured while processing your request"
      end

      customer = Stripe::Customer.create(
        email: email,
        description: stripe_description,
        card: stripe_token
      )
    else
      customer = Stripe::Customer.retrieve(customer_id)
      if stripe_token.present?
        customer.card = stripe_token
      end

      customer.email = email
      customer.description = stripe_description
      customer.save
    end

    self.last_4_digits = customer.active_card.last4
    self.customer_id = customer.id
    self.stripe_token = nil

  rescue Stripe::StripeError => e
    logger.error "StripeError: " + e.message
    errors.add :base, "#{e.message}."
    self.stripe_token = nil
    false
  end

  private

  def stripe_token_exists?
    stripe_token.present?
  end

  def card_number_exists?
    card_number.present?
  end

end
