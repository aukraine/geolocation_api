# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
Geolocation.destroy_all
User.destroy_all

_user = FactoryBot.create(:user, email: 'user@mail.com', password: 'password')

FactoryBot.create_list(:geolocation, 2, :with_jsonb_location)
FactoryBot.create_list(:geolocation, 2, :ipv6, :with_url, :with_jsonb_location)
FactoryBot.create_list(:geolocation, 3, :with_url, :with_jsonb_location)
