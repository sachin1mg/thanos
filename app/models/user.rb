class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Disabled devise properties: :registerable, :recoverable, :rememberable
  devise :database_authenticatable, :trackable, :validatable, :recoverable, :timeoutable

  validates_presence_of :email

  has_and_belongs_to_many :roles
  has_many :permissions, through: :roles

  #
  # Add given role to user
  # @param role [Role] Role
  #
  def add_role(role)
    return if self.roles.exists?(role.id)
    self.roles << role
  end

  #
  # Remove given role from user
  # @param role [Role] Role
  #
  def remove_role(role)
    self.roles.destroy(role)
  end

  def generate_jwt
    JWT.encode({ id: id,
                 exp: 60.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end

  def permissions_given
    role_ids = roles.includes(:children)
                     .map(&:self_and_descendants)
                     .flatten
                     .map(&:id)

    Permission.joins(:roles)
              .where(roles: { id: role_ids })
              .distinct
  end
end