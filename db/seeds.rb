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
  prefecture: '東京都',
  hide_prefecture: true,
  birth_year: 2005,
  hide_birth_year: true,
  introduction: 'テストユーザ1 非公開-非公開-有効',
  is_active: true,
  is_forbidden: false
)
User.create!(
  email: 'b@b',
  password: 'bbbbbb',
  name: 'fuga',
  prefecture: '京都府',
  hide_prefecture: true,
  birth_year: 2000,
  hide_birth_year: false,
  introduction: 'テストユーザ2 非公開-公開-有効',
  is_active: true,
  is_forbidden: false
)
User.create!(
  email: 'c@c',
  password: 'cccccc',
  name: 'piyo',
  prefecture: '福岡県',
  hide_prefecture: false,
  birth_year: 1995,
  hide_birth_year: false,
  introduction: 'テストユーザ3 公開-公開-有効',
  is_active: true,
  is_forbidden: false
)
User.create!(
  email: 'd@d',
  password: 'dddddd',
  name: 'hogehoge',
  prefecture: '宮城県',
  hide_prefecture: true,
  birth_year: 1990,
  hide_birth_year: true,
  introduction: 'テストユーザ4 非公開-非公開-退会済み',
  is_active: false,
  is_forbidden: false
)
User.create!(
  email: 'e@e',
  password: 'eeeeee',
  name: 'fugafuga',
  prefecture: '大阪府',
  hide_prefecture: false,
  birth_year: 1985,
  hide_birth_year: true,
  introduction: 'テストユーザ5 公開-非公開-退会済み',
  is_active: false,
  is_forbidden: false
)
User.create!(
  email: 'f@f',
  password: 'ffffff',
  name: 'piyopiyo',
  prefecture: '沖縄県',
  hide_prefecture: false,
  birth_year: 1980,
  hide_birth_year: false,
  introduction: 'テストユーザ6 公開-公開-退会済み',
  is_active: false,
  is_forbidden: false
)
User.create!(
  email: 'z@z',
  password: 'zzzzzz',
  name: 'forbidden',
  prefecture: '沖縄県',
  hide_prefecture: false,
  birth_year: 1980,
  hide_birth_year: false,
  introduction: 'テストユーザ7 除名済み',
  is_active: false,
  is_forbidden: false
)


Admin.create!(
  email: 'admin@admin',
  password: 'mainadmin',
  name: '主管理者',
  introduction: 'テスト',
  main_admin: true,
  is_active: true,
  is_forbidden: false
)
Admin.create!(
  email: 'subadmin@subadmin',
  password: 'subadmin',
  name: '副管理者',
  introduction: 'テスト',
  main_admin: false,
  is_active: true,
  is_forbidden: false
)
Admin.create!(
  email: 'deadmin@deadmin',
  password: 'deadmin',
  name: '退会副管理者',
  introduction: 'テスト',
  main_admin: false,
  is_active: false,
  is_forbidden: false
)
Admin.create!(
  email: 'banadmin@banadmin',
  password: 'banadmin',
  name: '除名副管理者',
  introduction: 'テスト',
  main_admin: false,
  is_active: true,
  is_forbidden: true
)