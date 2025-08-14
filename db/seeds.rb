# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  email: 'a@a',
  password: 'aaaaaa',
  name: 'テストユーザ1',
  prefecture: '東京都',
  hide_prefecture: true,
  birth_year: 2005,
  hide_birth_year: true,
  introduction: '都道府県 非公開-誕生年 非公開-アクティブ',
  is_active: true,
  is_forbidden: false
)
User.create!(
  email: 'b@b',
  password: 'bbbbbb',
  name: 'テストユーザ2',
  prefecture: '京都府',
  hide_prefecture: true,
  birth_year: 2000,
  hide_birth_year: false,
  introduction: '都道府県 非公開-誕生年 公開-アクティブ',
  is_active: true,
  is_forbidden: false
)
User.create!(
  email: 'c@c',
  password: 'cccccc',
  name: 'テストユーザ3',
  prefecture: '福岡県',
  hide_prefecture: false,
  birth_year: 1995,
  hide_birth_year: false,
  introduction: '都道府県 公開-誕生年 公開-アクティブ',
  is_active: true,
  is_forbidden: false
)
User.create!(
  email: 'd@d',
  password: 'dddddd',
  name: '退会済ユーザ1',
  prefecture: '宮城県',
  hide_prefecture: true,
  birth_year: 1990,
  hide_birth_year: true,
  introduction: '都道府県 非公開-誕生年 非公開-退会済み',
  is_active: false,
  is_forbidden: false
)
User.create!(
  email: 'e@e',
  password: 'eeeeee',
  name: '退会済ユーザ2',
  prefecture: '大阪府',
  hide_prefecture: false,
  birth_year: 1985,
  hide_birth_year: true,
  introduction: '都道府県 公開-誕生年 非公開-退会済み',
  is_active: false,
  is_forbidden: false
)
User.create!(
  email: 'f@f',
  password: 'ffffff',
  name: '退会済ユーザ3',
  prefecture: '沖縄県',
  hide_prefecture: false,
  birth_year: 1980,
  hide_birth_year: false,
  introduction: '都道府県 公開-誕生年 公開-退会済み',
  is_active: false,
  is_forbidden: false
)
User.create!(
  email: 'z@z',
  password: 'zzzzzz',
  name: '除名済みユーザ',
  prefecture: '東京都',
  hide_prefecture: false,
  birth_year: 2000,
  hide_birth_year: false,
  introduction: '除名済',
  is_active: false,
  is_forbidden: true
)

users = User.all
users.each do |user|
  file_path = Rails.root.join('app/assets/images/default.png')
  user.profile_image.attach(io: File.open(file_path), filename: 'default.png', content_type: 'image/png')
end

Admin.create!(
  email: 'admin@admin',
  password: 'mainadmin',
  name: '主管理者',
  introduction: 'メイン管理者',
  main_admin: true,
  is_active: true,
  is_forbidden: false
)
Admin.create!(
  email: 'subadmin@subadmin',
  password: 'subadmin',
  name: '副管理者',
  introduction: 'サブ管理者',
  main_admin: false,
  is_active: true,
  is_forbidden: false
)
Admin.create!(
  email: 'deadmin@deadmin',
  password: 'deadmin',
  name: '退会副管理者',
  introduction: '退会済のサブ管理者',
  main_admin: false,
  is_active: false,
  is_forbidden: false
)
Admin.create!(
  email: 'banedadmin@banedadmin',
  password: 'banedadmin',
  name: '除名副管理者',
  introduction: '除名されたサブ管理者',
  main_admin: false,
  is_active: true,
  is_forbidden: true
)

admins = Admin.all
admins.each do |admin|
  file_path = Rails.root.join('app/assets/images/default.png')
  admin.profile_image.attach(io: File.open(file_path), filename: 'default.png', content_type: 'image/png')
end

Category.create(name: '野鳥')
Category.create(name: '野生動物（野鳥除く）')
Category.create(name: '飼育動物')
Category.create(name: '植物')
Category.create(name: '風景')
Category.create(name: '休憩ポイント')
Category.create(name: '公園')
Category.create(name: 'ショップ')
