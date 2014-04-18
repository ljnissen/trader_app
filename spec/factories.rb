FactoryGirl.define do
  factory :user do
    name     "LJ Nissen"
    email    "ljnissen@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end