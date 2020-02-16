FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name 'Pepe'
    last_name 'Calavera'
    sequence(:email) { |n| "pepe_calavera#{n}@mail.com" }
    password 'pepito-calavera-123'
  end
end