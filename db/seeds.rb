# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# User.create(username: "admin@outlabs.com", password: "123456", role: "admin")
# Company.create(name: "Outlabs", email: "root@outlabs.com", phone: "1234567890", user_id: 19)

# group = Group.create(name: 'react', company_id: 1, user_id: 19, user_ids: [19])


user_ids = [20] # Substitua pelos IDs reais dos usuários

# Encontrar o grupo específico pelo ID
group = Group.find_by(id: 2)

# Associar os usuários ao grupo
if group
  group.user_ids = user_ids
  group.save
  puts "Usuários adicionados ao grupo com sucesso!"
else
  puts "Grupo não encontrado!"
end