class Permission < ApplicationRecord
  enum status: { active: 'active', inactive: 'inactive' }

  validates_presence_of :label

  has_and_belongs_to_many :roles
end