FactoryBot.define do
  factory :vendor_supplier_contract do
    vendor
    supplier
    priority { [1, 2, nil].sample }

    trait :active do
      status :active
    end

    trait :inactive do
      status :inactive
    end
  end
end
