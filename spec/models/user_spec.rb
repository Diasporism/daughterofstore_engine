require 'spec_helper'

describe User do

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it "should not be valid without a full name" do
    expect(build(:user, full_name: nil)).to have(1).errors_on(:full_name)
  end

  it "should not be valid without a email" do
    expect(build(:user, email: nil)).to have(1).errors_on(:email)
  end

  it "should not be valid without a password" do
    expect(build(:user, password: nil)).to have(1).errors_on(:password)
  end

  it "is invalid with a duplicate email address" do
    create(:user, email: "ironman@example.com")
    user = build(:user, email: "ironman@example.com")
    expect(user).to have(1).errors_on(:email)
  end

  it "should have an array of stores" do
    user = create(:user)
    expect(user.stores.class).to eq Array
  end

  describe '.update_stripe' do

    context "with a non-existing user" do
      before do
        successful_stripe_response = StripeHelper::Response.new("success")
        Stripe::Customer.stub(:create).and_return(successful_stripe_response)
        @user = User.new(email: "test@testign.com", stripe_token: 12345, full_name: 'tester', password: 'password')
      end

      it "creates a new user with successful stripe response" do
        @user.save!
        new_user = User.last
        new_user.customer_id.should eq("youAreSuccessful")
        new_user.last_4_digits.should eq("4242")
        new_user.stripe_token.should be_nil
      end
    end
  end

  describe '.is_super_admin?' do
    before do
      @user = create(:super_admin)
    end

    it "should confirm the user is a super admin" do
      expect(@user.is_super_admin?).to be
    end
  end

  describe '.assign_super_admin' do
    before do
      @user = create(:user)
    end

    it "should assign make the user into a super_admin" do
      @user.assign_super_admin
      expect(@user).to be_super_admin
    end
  end

  describe '.assign_role' do
    before do
      @user = create(:user)
      @store = create(:store)
    end

    it "should assign the user as an admin of the Avengers store" do
      @user.assign_role(@store.id, 'admin')
      expect(@user.stores).to match_array [@store]

    end
  end

end
