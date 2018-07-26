class Role < ApplicationRecord
  validates_presence_of :label

  has_and_belongs_to_many :users
  has_and_belongs_to_many :permissions

  has_many :children, class_name: 'Role', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Role', foreign_key: 'parent_id', optional: true

  def self.default_role
    vendor_role
  end

  def self.vendor_role
    self.find_or_create_by!(label: 'vendor')
  end
end