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

  def descendant_ids
    children.pluck(:id) + children.map(&:descendant_ids).flatten
  end

  def descendants
    Role.where(id: descendant_ids)
  end

  def self_and_descendants
    Role.where(id: descendant_ids.push(id))
  end

  def permissions_given
    Permission.joins(:roles).where(roles: { id: descendant_ids.push(id) })
  end

  #
  # Add given permission to role
  # @param permission [Permission] Permission
  #
  def add_permission(permission)
    return if self.permissions.exists?(permission.id)
    self.permissions << permission
  end
end