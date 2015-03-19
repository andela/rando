# This will guess the User class
FactoryGirl.define do

  factory :user do
    sequence(:first_name) { |n| "FirstName#{n}" }
    sequence(:last_name) { |n| "LastName#{n}" }
    sequence(:name) { |n| "FirstName#{n} LastName#{n}" }
    sequence(:email) { |n| "email#{n}@andela.co" }

    after(:build) { |user| user.class.skip_callback(:create, :after, :create_account) }

    factory :user_with_account do
      after(:create) { |user| user.send(:create_account) }
    end
  end

  factory :campaign do
    sequence(:title) { |n| "Food for the Poor #{n}"}
    deadline Date.tomorrow + 1
    needed '60000'
    description 'Never go hungry again.'
    youtube_url 'https://www.youtube.com/watch?v=7WJk-z5AmXk'
    raised '2000'

    after(:build) { |campaign| campaign.class.skip_callback(:create, :after, :create_account) }

    factory :campaign_with_account do
      after(:create) { |campaign| campaign.send(:create_account) }
    end

    user

    after(:build) { |campaign| campaign.class.skip_callback(:create, :after, :create_account) }

    factory :campaign_with_callback do
      after(:create) { |campaign| campaign.send(:create_account) }
    end
  end

  factory :role do
    name 'admin'
  end

  factory :invalid_campaign, class: Campaign do
    title ''
    deadline ''
    needed ''
    description ''
    youtube_url ''
    raised ''
  end

  factory :funded_campaign, class: Campaign do
    sequence(:title) { |n| "Food for the Poor #{n}"}
    deadline Date.tomorrow + 1
    needed '23000'
    description 'Never go hungry again.'
    youtube_url 'https://www.youtube.com/watch?v=7WJk-z5AmXk'
    raised '23000'

    user
  end
end