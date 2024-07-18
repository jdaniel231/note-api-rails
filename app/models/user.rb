class User < ApplicationRecord
  has_secure_password

  enum role: { root: "root", admin: "admin", client: "client" }
end
