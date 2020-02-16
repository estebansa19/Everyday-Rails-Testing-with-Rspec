FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description 'A test project'
    due_on Date.current + 1.week
    association :owner

    trait :with_notes do
      after(:create) { |project| create_list(:note, 5, project: project) }
    end

    trait :due_yesterday do
      due_on Date.yesterday
    end

    trait :due_today do
      due_on Date.current
    end

    trait :due_tomorrow do
      due_on Date.tomorrow
    end

    trait :invalid do
      name nil
    end
  end
end
