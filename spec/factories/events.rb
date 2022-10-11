FactoryBot.define do
  factory :event do
    association :user

    title { "Event" }
    address { "Antarctica" }
    datetime { DateTime.now }
  end
end
