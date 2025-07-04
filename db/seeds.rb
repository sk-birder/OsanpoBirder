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
  name: 'hoge',
  area: '東京都',
  hide_area: true,
  birth_year: 2005,
  hide_birth_year: true,
  introduction: 'テストユーザ1 非公開-非公開-有効',
  is_active: true
)
User.create!(
  email: 'b@b',
  password: 'bbbbbb',
  name: 'fuga',
  area: '京都府',
  hide_area: true,
  birth_year: 2000,
  hide_birth_year: false,
  introduction: 'テストユーザ2 非公開-公開-有効',
  is_active: true
)
User.create!(
  email: 'c@c',
  password: 'cccccc',
  name: 'piyo',
  area: '福岡県',
  hide_area: false,
  birth_year: 1995,
  hide_birth_year: false,
  introduction: 'テストユーザ3 公開-公開-有効',
  is_active: true
)
User.create!(
  email: 'd@d',
  password: 'dddddd',
  name: 'hogehoge',
  area: '宮城県',
  hide_area: true,
  birth_year: 1990,
  hide_birth_year: true,
  introduction: 'テストユーザ4 非公開-非公開-退会済み',
  is_active: false
)
User.create!(
  email: 'e@e',
  password: 'eeeeee',
  name: 'fugafuga',
  area: '大阪府',
  hide_area: false,
  birth_year: 1985,
  hide_birth_year: true,
  introduction: 'テストユーザ5 公開-非公開-退会済み',
  is_active: false
)
User.create!(
  email: 'f@f',
  password: 'ffffff',
  name: 'piyopiyo',
  area: '沖縄県',
  hide_area: false,
  birth_year: 1980,
  hide_birth_year: false,
  introduction: 'テストユーザ6 公開-公開-退会済み',
  is_active: false
)

Admin.create!(
  email: 'admin@hoge.com',
  password: 'hogehoge',
  name: '主管理者',
  introduction: 'テスト',
  main_admin: true,
  is_active: true
)