# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Category.find_or_create_by(name: "Science")
Category.find_or_create_by(name: "Technology")
Category.find_or_create_by(name: "Engineering")
Category.find_or_create_by(name: "Art")
Category.find_or_create_by(name: "Math")
Article.find_or_create_by(title: "Hello World",
                          content: "test",
                          is_public: true,
                          category_id: 1,
                          user_id: 1)