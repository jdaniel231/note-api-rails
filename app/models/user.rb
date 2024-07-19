class User < ApplicationRecord
  has_secure_password

  has_many :groups
  has_and_belongs_to_many :groups

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true

  enum role: { root: "root", admin: "admin", client: "client" }
end
