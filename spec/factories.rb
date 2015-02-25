# This will guess the User class
FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "User #{n}"}
    sequence(:email) {|n| "email#{n}@andela.co"}
  end

  factory :campaign do
    title 'Food for the Poor'
    deadline Date.tomorrow
    amount '60000'
    description 'Never go hungry again.'
    youtube_url 'https://www.youtube.com/watch?v=7WJk-z5AmXk'

    user
  end

  factory :invalid_campaign, class: Campaign do
    title ''
    deadline ''
    amount ''
    description ''
    youtube_url ''
  end
end