FactoryBot.define do
  factory :role do
    label { Faker::Lorem.word }

    trait :admin do
      label 'Admin'

      after :create do |role, evaluator|
        permissions = evaluator[:permissions] || []
        if permissions.empty?
          permissions = Permission.active.present? ? Permission.active : [FactoryBot.create(:permission)]
        end

        role.permissions = permissions
      end
    end

    trait :vendor do
      label 'Vendor'
    end

    trait :operations do
      label 'Operations'
    end

    trait :random do
      label 'Random'
    end

    trait :with_parent do
      association :parent, factory: :role
    end
  end
end
