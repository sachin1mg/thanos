FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    vendor

    after :create do |user, evaluator|
      roles = evaluator[:roles]
      user.roles = roles if roles.present?
    end

    trait :admin do
      after :create do |user|
        role = Role.find_by(label: 'Admin') || FactoryBot.create(:role, :admin)
        user.add_role role
      end
    end
  end
end
