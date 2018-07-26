class Location < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :vendor
  has_many :inventories
end
