FactoryBot.define do
  factory :invoice do
    sales_order
    number { Faker::Lorem.characters(10) }
    date { Faker::Date.between(2.days.ago, Date.today) }
    attachment_file_name { 10.times.map{ ('a'..'z').to_a.sample }.join('') + '.pdf' }
    attachment_content_type { 'application/pdf' }
    attachment_file_size { 1024 }
  end
end
