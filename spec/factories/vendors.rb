FactoryBot.define do
  factory :vendor do
    name { Faker::Name.name }
    invoice_number_template { %w[DD-MM-YYYY-123 YYYY-MM-DD-123].sample }

    trait :active do
      status :active
    end

    trait :inactive do
      status :inactive
    end
  end
end
