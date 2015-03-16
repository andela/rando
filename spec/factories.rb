# This will guess the User class
FactoryGirl.define do

  factory :user do
    sequence(:first_name) { |n| "FirstName#{n}" }
    sequence(:last_name) { |n| "LastName#{n}" }
    sequence(:name) { |n| "FirstName#{n} LastName#{n}" }
    sequence(:email) { |n| "email#{n}@andela.co" }

    after(:build) { |user| user.class.skip_callback(:create, :after, :create_account) }

    factory :user_with_callback do
      after(:create) { |user| user.send(:create_account) }
    end
  end

  factory :campaign do
    sequence(:title) { |n| "Food for the Poor #{n}"}
    deadline Date.tomorrow + 1
    amount '60000'
    description 'Never go hungry again.'
    youtube_url 'https://www.youtube.com/watch?v=7WJk-z5AmXk'

    user
  end

  factory :role do
    name 'admin'
  end

  factory :invalid_campaign, class: Campaign do
    title ''
    deadline ''
    amount ''
    description ''
    youtube_url ''
  end
end