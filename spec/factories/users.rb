FactoryGirl.define do

  factory :user do
    full_name     "Tony Stark"
    display_name  "Iron Man"
    password      "password"
    sequence(:email) { |n| "ironman#{n}@example.com" }

    factory :super_admin do
      super_admin   true
    end

    factory :invalid_user do
      full_name     nil
    end

    factory :user_with_valid_cc do
      last_4_digits   "7777"
      customer_id     "cus_faux_stripe"
    end
  end
end
